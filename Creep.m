//
//  Creep.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Creep.h"
#import "MapScene.h"

@implementation Creep {
    NSMutableArray *creepImagesUp;
    NSMutableArray *creepImagesDown;
    NSMutableArray *creepImagesLeft;
    NSMutableArray *creepImagesRight;
    NSMutableArray *wayPoints;
}

@synthesize mapScene, creepSprite;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code {
    if ((self=[super init])) {
        mapScene = map;
        creepCode = code;
        
        maxHP = 40;
        currentHP = maxHP;
        active = NO;
        walkingSpeed = 7.0;
        walkingTime = 0.005; // ?? FPS
        
        [self setupWayPoints];
        
        creepSprite = [[SKSpriteNode alloc] initWithImageNamed:@"spider"];
        creepSprite.size = CGSizeMake(creepSprite.frame.size.width/5, creepSprite.frame.size.height/5);
        
        [self addChild:creepSprite];
        [self setPosition:lastDestination];
        
        [self creepMovement];
        
    }
    return self;
}

- (void) creepMovement {
    //SKAction mov
    //NSLog(@"%f, %f", nextDestination.x, nextDestination.y);
    
    if ([mapScene doesCircle:self.position withRadius:4 collideWithCircle:nextDestination collisionCircleRadius:2]) {
        
        if (nextDestinationIndex == 14) {
            nextDestinationIndex = 1;
            nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
            lastDestination = [[wayPoints objectAtIndex:0] CGPointValue];
            self.position = CGPointMake(lastDestination.x, lastDestination.y);
        } else {
            lastDestination = nextDestination;
            nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex++] CGPointValue];
        }
    }
    
    if (nextDestination.x != lastDestination.x) /* moving along X */ {
        if (lastDestination.x < nextDestination.x)  /* LEFT */{
            [self runAction:[SKAction moveByX:walkingSpeed y:0 duration:0]];
        } else /* RIGHT */ {
            [self runAction:[SKAction moveByX:-walkingSpeed y:0 duration:0]];
        }
    }
    if (nextDestination.y != lastDestination.y) /* moving along Y */{
        if (lastDestination.y < nextDestination.y)  /* UP */{
            [self runAction:[SKAction moveByX:0 y:walkingSpeed duration:0]];
        } else /* DOWN */ {
            [self runAction:[SKAction moveByX:0 y:-walkingSpeed duration:0]];
        }
    }
    
    SKAction *a = [SKAction sequence:@[
                                       [SKAction waitForDuration:walkingTime],
                                       [SKAction runBlock:^{[self creepMovement];}]
                                       ]];
    [self runAction:a];
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

@end
