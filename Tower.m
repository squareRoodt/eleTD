//
//  Tower.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 2/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Tower.h"
#import "Bullet.h"
#import "MapScene.h"
#import "Creep.h"

@implementation Tower

@synthesize mapScene, towerSprite;

-(id)initWithMap:(MapScene *)map code:(NSString *)code {
    if ((self= [super init])) {
        towerCode = code;
        mapScene = map;
        attacking = false;
        
        // load tower attributes
        attackRadius = 250;
        attackSpeed = 1;
        attackDamage = 10;
        attackModifier = @"NONE";
        
        towerSprite = [[SKSpriteNode alloc] initWithImageNamed:@"towerPlaceHolder"];
        [self addChild:towerSprite];
        
        
    }
    
    return self;
}


-(void)chosenEnemyForAttack:(Creep *)enemy
{
    
    currentCreep = nil;
    currentCreep = enemy;
    attackTimer = [NSTimer scheduledTimerWithTimeInterval:attackSpeed target:self
                                                 selector:@selector(shootWeapon) userInfo:nil repeats:YES];
    //[self shootWeapon]; // should fire a shot as soon as in range
    [enemy getAttackedBy:self];
}

-(void)shootWeapon
{
    //NSLog(@"shooting");
    Bullet * bullet = [[Bullet alloc]initWithCode:@"" andImageName:@""];
    [mapScene.background addChild:bullet];
    [bullet setPosition:self.position];
    NSMutableArray *actions = [[NSMutableArray alloc]initWithObjects:[SKAction moveTo:currentCreep.position duration:0.2],
                               [SKAction runBlock:^{[self damageEnemy]; [self removeBullet:bullet];}],
                               nil];
    [bullet runAction:[SKAction sequence:actions]];
    
}

-(void)removeBullet:(Bullet *)bullet
{
    [bullet removeFromParent];
}

-(void)damageEnemy
{
    [currentCreep getDamaged:attackDamage];
}

- (void) targetKilled
{
    if(currentCreep) {
        currentCreep = nil;
    }
    [attackTimer invalidate];
}

-(void)lostSightOfEnemy
{
    [currentCreep gotLostSight:self];
    if(currentCreep) {
        currentCreep = nil;
    }
    // NSLog(@"lost target");
    [attackTimer invalidate];
}

- (void) towerUpdate {
    if (currentCreep){
        //NSLog(@"current creep is active");
        if (![mapScene doesCircle:self.position withRadius:attackRadius collideWithCircle:currentCreep.position collisionCircleRadius:1])
        {
            [self lostSightOfEnemy];
        }
    }
    else {
        for(int i = [mapScene.enemies count]-1; i >= 0; i--)
        {
            Creep *suspectedCreep = mapScene.enemies[i];
            CGPoint suspectedCreepPoint = suspectedCreep.position;
            if([mapScene doesCircle:self.position withRadius:attackRadius collideWithCircle: suspectedCreepPoint collisionCircleRadius:1])
            {
                [self chosenEnemyForAttack:suspectedCreep];
                break;
            }
        }
    }
}
// Creep * enemy in mapScene.enemies
// I think it loses the creep instantly once it finds it so searching form the back might work better
@end
