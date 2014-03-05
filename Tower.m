//
//  Tower.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 2/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Tower.h"

@implementation Tower

@synthesize mapScene, towerSprite;

-(id)initWithMap:(MapScene *)map code:(NSString *)code {
    if ((self= [super init])) {
        towerCode = code;
        mapScene = map;
        
        // load tower attributes
        attackRadius = 50;
        attackSpeed = 1;
        attackSpeed = 0;
        attackDamage = 10;
        attackModifier = @"NONE";
        
        towerSprite = [[SKSpriteNode alloc] initWithImageNamed:@"towerPlaceHolder"];
        [self addChild:towerSprite];
        
    }
    
    return self;
}

@end
