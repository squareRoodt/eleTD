//
//  Creep.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//




/*
 self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
 self.physicsBody.usesPreciseCollisionDetection = false;
 mapScene.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
 self.physicsBody.friction = 0.0;
 self.physicsBody.linearDamping = 0;
 self.physicsBody.allowsRotation = true;
 //self.physicsBody.mass = 0.1;
 self.physicsBody.dynamic = true;
 self.physicsBody.affectedByGravity = false;
 
 [self.physicsBody applyForce:CGVectorMake(0, -100)];
 [self.physicsBody applyImpulse:CGVectorMake(0, -100)];
 
 
 
 SKSpriteNode *ts = [[SKSpriteNode alloc] initWithImageNamed:@"spider"];
 //[background addChild:ts];
 [mapScene.background addChild:ts];
 ts.position = CGPointMake(400, 400);
 ts.yScale = 0.5;
 ts.xScale = 0.5;
 //PHYSICS
 //self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
 ts.physicsBody.affectedByGravity = false;
 ts.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ts.size.width, ts.size.height)];
 
 ts.physicsBody.friction = 1;
 ts.physicsBody.linearDamping = 0.7;
 ts.physicsBody.allowsRotation = true;
 ts.physicsBody.dynamic = true;
 //[ts.physicsBody applyImpulse:CGVectorMake(0, 100)];
 //[ts.physicsBody applyImpulse:CGVectorMake(0, 200)];
 [ts.physicsBody applyForce:CGVectorMake(0, 200)];
 
 */

#import "Creep.h"
#import "MapScene.h"
#import "Tower.h"
#import "Bullet.h"

@implementation Creep {
    NSMutableArray *creepImagesUp;
    NSMutableArray *creepImagesDown;
    NSMutableArray *creepImagesLeft;
    NSMutableArray *creepImagesRight;
    NSMutableArray *wayPoints;
}

@synthesize mapScene, movementTimer, nextDestination, lastDestination, walkingSpeed;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code {
    if ((self=[super initWithImageNamed:@"spiderSmall"])) {
        mapScene = map;
        creepCode = code;
      
        maxHP = 40;
        currentHP = maxHP;
        active = NO;
        walkingSpeed = 5.0;
        walkingTime = 0.053; // ??? FPS
        
        [self setupWayPoints];
        [self setPosition:lastDestination];
        
        attackedByTowers = [[NSMutableArray alloc] initWithCapacity:5];
        
        // do a healthBar

    }
    return self;
}

- (void) creepMovementTimer {
    
    if ([mapScene doesCircle:self.position withRadius:2 collideWithCircle:nextDestination collisionCircleRadius:2] ) {
        
        if (nextDestinationIndex == 14) {
            nextDestinationIndex = 0;
            nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
            lastDestination = [[wayPoints objectAtIndex:0] CGPointValue];
            self.position = CGPointMake(lastDestination.x, lastDestination.y);
        }
        
        lastDestination = nextDestination;
        nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex++] CGPointValue];
    }
    
    
    if (nextDestination.x != lastDestination.x) /* moving along X */ {
        if (lastDestination.x < nextDestination.x)  /* LEFT */{
            self.position = CGPointMake(self.position.x + walkingSpeed, self.position.y);
        } else /* RIGHT */ {
            self.position = CGPointMake(self.position.x - walkingSpeed, self.position.y);
        }
    }
    if (nextDestination.y != lastDestination.y) /* moving along Y */{
        if (lastDestination.y < nextDestination.y)  /* UP */{
            self.position = CGPointMake(self.position.x, self.position.y + walkingSpeed);
        } else /* DOWN */ {
            self.position = CGPointMake(self.position.x, self.position.y - walkingSpeed);
        }
    }
}

- (void) setupWayPoints {
    if ([wayPoints count] < 1) {
        
        CGPoint p1 = CGPointMake(265, 1320);
        CGPoint p2 = CGPointMake(265, 1045);
        CGPoint p3 = CGPointMake(125, 1045);
        CGPoint p4 = CGPointMake(125, 655);
        CGPoint p5 = CGPointMake(415, 655);
        CGPoint p6 = CGPointMake(415, 785);
        CGPoint p7 = CGPointMake(660, 785);
        CGPoint p8 = CGPointMake(660, 400);
        CGPoint p9 = CGPointMake(125, 400);
        CGPoint p10 = CGPointMake(125, 95);
        CGPoint p11 = CGPointMake(950, 95);
        CGPoint p12 = CGPointMake(950, 1050);
        CGPoint p13 = CGPointMake(540, 1050);
        CGPoint p14 = CGPointMake(540, 1320);
        
        wayPoints = [[NSMutableArray alloc] init];
        
        [wayPoints addObject:[NSValue valueWithCGPoint:p1]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p2]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p3]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p4]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p5]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p6]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p7]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p8]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p9]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p10]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p11]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p12]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p13]];
        [wayPoints addObject:[NSValue valueWithCGPoint:p14]];
        
        nextDestinationIndex = 1;
        nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
        lastDestination = [[wayPoints objectAtIndex:0] CGPointValue];
        
    }
}

- (void) doActivate {
    
}

- (void) kill {
    
}

-(void)getRemoved
{
    for(Tower * attacker in attackedByTowers)
    {
        [attacker targetKilled];
    }
    
    //[self.parent removeChild:self cleanup:YES];
    [self removeFromParent];
    [mapScene.enemies removeObject:self];
    
    //Notify the game that we killed an enemy so we can check if we can send another wave
    [mapScene enemyGotKilled];
}

-(void)getAttackedBy:(Tower *)attacker
{
    [attackedByTowers addObject:attacker];
}

-(void)gotLostSight:(Tower *)attacker
{
    [attackedByTowers removeObject:attacker];
}

-(void)getDamaged:(float)damage
{
    currentHP -=damage;
    if(currentHP <=0)
    {
        [self getRemoved];
    }
}



@end
