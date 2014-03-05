//
//  Creep.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Creep.h"

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
        walkingSpeed = 0.5;
        
        [self setupWayPoints];
        creepSprite = [[SKSpriteNode alloc] initWithImageNamed:@"towerPlaceHolder"];
        creepSprite.position = CGPointMake(0, 0);
        [self addChild:creepSprite];
        [self setPosition:nextDestination];
        
        
    }
    return self;
}

- (void) setupWayPoints {
    if ([wayPoints count] < 1) {
        
        CGPoint p1 = CGPointMake(265, 1320);
        CGPoint p2 = CGPointMake(265, 1045);
        CGPoint p3 = CGPointMake(125, 1045);
        CGPoint p4 = CGPointMake(115, 655);
        CGPoint p5 = CGPointMake(405, 650);
        CGPoint p6 = CGPointMake(415, 785);
        CGPoint p7 = CGPointMake(660, 785);
        CGPoint p8 = CGPointMake(665, 400);
        CGPoint p9 = CGPointMake(125, 395);
        CGPoint p10 = CGPointMake(120, 95);
        CGPoint p11 = CGPointMake(950, 105);
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
        
        nextDestinationIndex = 0;
        nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
    }
}

- (void) doActivate {
    
}

- (void) kill {
    
}

@end
