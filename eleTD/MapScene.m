//
//  Map.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//


#import "MapScene.h"
#import "Bullet.h"
#import "Tower.h"
#import "Creep.h"
#import "ViewController.h"
#import "Map.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@implementation MapScene

@synthesize background;
@synthesize selectedNode;
@synthesize towers, enemies;

float iPadScale = 1.6;
float iPhoneScale = 3.5;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // NO IDEA WHY THIS DOESNT WORK
        //viewController = [(Map*)self.view getViewController];
        //parentMap = (Map*)self.view;
        
        enemies = [[NSMutableArray alloc] init];
        towers = [[NSMutableArray alloc]init];
        currentLvl = 1;
        
        //Loading the background
        background = [SKSpriteNode spriteNodeWithImageNamed:@"mapBeta1"];
        [background setName:@"background"];
        [background setAnchorPoint:CGPointZero];
        // scalling the background size
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            background.size = CGSizeMake(background.size.width/iPhoneScale, background.size.height/iPhoneScale);
        } else if (IS_IPAD) {
            background.size = CGSizeMake(background.size.width/iPadScale, background.size.height/iPadScale);
        }
        [self addChild:background];
        
        
        // importing building spots
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"towerLocations" ofType:@"plist"];
        NSArray * towerPositions = [NSArray arrayWithContentsOfFile:plistPath];
        towerBases = [[NSMutableArray alloc] init];
        
        for(NSDictionary * towerPos in towerPositions)
        {
            SKSpriteNode * towerBase = [SKSpriteNode spriteNodeWithImageNamed:@"buildHighlight"];
            [background addChild:towerBase];
            towerBase.size = CGSizeMake(towerBase.size.width/iPadScale, towerBase.size.height/iPadScale);
            [towerBase setPosition:CGPointMake([[towerPos objectForKey:@"x"] intValue],
                                       [[towerPos objectForKey:@"y"] intValue])];
            //NSLog(@"grass spot x: %f,   y: %f",towerBase.position.x, towerBase.position.y);
            [towerBases addObject:towerBase];
            towerBase.name = @"build_spot";
            towerBase.hidden = TRUE;
        }
        
        // creating a testing creep
        
        // creating multiple creeps (x20)
        creepCreator = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                       selector:@selector(createCreep) userInfo:nil repeats:YES];
        
        
        
        /*
        SKSpriteNode *ts = [[SKSpriteNode alloc] initWithImageNamed:@"spider"];
        [background addChild:ts];
        ts.position = CGPointMake(400, 400);
        ts.yScale = 0.5;
        ts.xScale = 0.5;
        //PHYSICS
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        ts.physicsBody.affectedByGravity = false;
        ts.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ts.size.width, ts.size.height)];
        [ts.physicsBody applyForce:CGVectorMake(0, 50)];
        ts.physicsBody.friction = 0.0;
        ts.physicsBody.linearDamping = 0;
         */
        
    }
    return self;
}

- (void) createCreep {
    
    //NSLog(@"adding creep");
    
    Creep *creep = [[Creep alloc]initWithMap:self andCode:@""];
    [background addChild:creep];
    [enemies addObject:creep];
    
    if ([enemies count] == 1) {
        [creepCreator invalidate];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionOnMap = [touch locationInNode:background];
    [self findSelectedNodeInTouch:positionOnMap];
    //NSLog(@"towers array: %@", towers);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint currentLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    float newPosX = (previousLocation.x - currentLocation.x);
    float newPosY = (previousLocation.y - currentLocation.y);
    CGPoint newPos = CGPointMake(newPosX, newPosY);
    [self scrollMap: newPos];
    
    if ([selectedNode.name isEqualToString:@"build_spot"]) {
        selectedNode.hidden = true;
        selectedNode = nil;
        [(Map *)self.view setEleButtonHidden:true];
    }
    
    
}

- (void) scrollMap: (CGPoint) newPos {
    CGSize winSize = self.size;
    CGPoint scrollPoint = CGPointMake(background.position.x - newPos.x, background.position.y - newPos.y);
    scrollPoint.x = MIN(scrollPoint.x, 0);
    scrollPoint.x = MAX(scrollPoint.x, -[background size].width+ winSize.width);
    scrollPoint.y = MIN(scrollPoint.y, 0);
    scrollPoint.y = MAX(scrollPoint.y, -[background size].height+ winSize.height);
    
    [background setPosition: scrollPoint];
}


- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    //NSLog(@"map location: x= %f, y= %f", touchLocation.x, touchLocation.y);
    SKNode *touchedNode = (SKNode *)[background nodeAtPoint:touchLocation];
    
    // deactivate nodes now that there is a new touch
    if ([[selectedNode name] isEqualToString:@"build_spot"] && selectedNode != touchedNode) {
        selectedNode.hidden = true;
    }
    
	if(![selectedNode isEqual:touchedNode]) {
		selectedNode = touchedNode;
        //NSLog(@"touched %@", selectedNode.name);
        [(Map *)self.view setEleButtonHidden:TRUE];
        
		if([[touchedNode name] isEqualToString:@"tower"]) {
			
		} else if ([[touchedNode name] isEqualToString:@"build_spot"]) {
            selectedNode.hidden = false;
            [self glowBuildSpot];
            // show element picker button
            [(Map *)self.view setEleButtonHidden:false];
            //[parentMap test];
        }
	}
    // else { touching the same thing }
}

- (void) glowBuildSpot {
    selectedNode.alpha = 0;
    SKAction *glow = [SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:1], [SKAction fadeAlphaTo:0.5 duration:1]]];
    
    // double check its a build_spot
    if ([selectedNode.name isEqualToString:@"build_spot"]) {
        [selectedNode runAction:[SKAction repeatActionForever:glow]];
    }
    
}

- (void) buildTowerOfType: (NSString*)code {
    NSLog(@"BUILDING TOWER");
    Tower *tower = [[Tower alloc] initWithMap:self code:code];
    [background addChild:tower];
    [tower setPosition:CGPointMake(selectedNode.frame.origin.x + selectedNode.frame.size.width/2, selectedNode.frame.origin.y + selectedNode.frame.size.height/2)];
    [towers addObject:tower];
}

-(BOOL)doesCircle:(CGPoint) circlePoint withRadius:(float) radius
collideWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo {
    
    float xdif = circlePoint.x - circlePointTwo.x;
    float ydif = circlePoint.y - circlePointTwo.y;
    
    float distance = sqrt(xdif*xdif+ydif*ydif);
    
    if(distance <= radius+radiusTwo) {
        return YES;
    }
    
    return NO;
}

- (void) enemyGotKilled {
    NSLog(@"enemy got killed. no code added yet");
}

- (void) levelEnded {
    currentLvl ++;
    NSLog(@"level ended. level %d coming up... (once code has been added)",currentLvl);
}

- (void) update: (NSTimeInterval) currentTime {
   
    for (Creep *creepy in enemies) {
        [creepy creepMovementTimer];
    }
    
    for (Tower *tower in towers) {
        [tower towerUpdate];
    }
}

@end
