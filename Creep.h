//
//  Creep.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Tower, Map, MapScene, Bullet;

@interface Creep : SKSpriteNode {
    int maxHP;
    int currentHP;
    float walkingSpeed;
    float walkingTime;
    int nextDestinationIndex;  // index of array of points
    CGPoint nextDestination;
    CGPoint lastDestination;
    BOOL active;
    NSString *creepCode;
    float safeToTurn;
}

@property MapScene *mapScene;
@property NSTimer *movementTimer;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code;
- (void) doActivate;
- (void) kill;

@end
