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
    NSMutableArray *attackedByTowers;
    
    float walkingTime;
    int nextDestinationIndex;  // index of array of points
    
    BOOL active;
    NSString *creepCode;
    float safeToTurn;
    
    SKSpriteNode *healthBarRed;
    SKSpriteNode *healthBarGreen;
    
    NSMutableArray *deadEnemies;
    
    int waypointWaitingTime;
    
    SKTexture *up;
    SKTexture *down;
    SKTexture *right;
    SKTexture *left;
}

@property MapScene *mapScene;
@property NSTimer *movementTimer;
@property CGPoint nextDestination;
@property CGPoint lastDestination;
@property float walkingSpeed;
@property float maxHP;
@property float currentHP;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code;
- (void) doActivate;
- (void) kill;
- (void) creepMovementTimer;

- (void) getAttackedBy: (Tower *) tower;
- (void) gotLostSight:(Tower *)attacker;
- (void) getDamaged:(float)damage withSplashRadius: (float) splash withEffect: (NSString*) effect;

@end
