//
//  Creep.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Tower, Map, MapScene, Bullet;

@interface Creep : SKNode {
    int maxHP;
    int currentHP;
    float walkingSpeed;
    int nextDestinationIndex;  // index of array of points
    CGPoint nextDestination;
    BOOL active;
    NSString *creepCode;
}

@property MapScene *mapScene;
@property SKSpriteNode *creepSprite;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code;
- (void) doActivate;
- (void) kill;

@end
