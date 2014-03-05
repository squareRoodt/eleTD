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

@property (nonatomic, weak) ViewController *viewController;

-(id)initWithViewController:(ViewController *)vc location:(CGPoint)location code: (NSString *)code;


@end
