//
//  Tower.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 2/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MapScene;
@class Map;
@class Creep;
@class ViewController;

@interface Tower : SKNode {
    float attackRadius;
    float attackSpeed;
    float attackSplash;
    float attackDamage;
    NSString *attackModifier;
    
    NSString *towerCode;
}

@property (nonatomic, weak) MapScene *mapScene;
@property (nonatomic, strong) SKSpriteNode *towerSprite;

-(id)initWithMap: (MapScene *)map code: (NSString *)code;


@end
