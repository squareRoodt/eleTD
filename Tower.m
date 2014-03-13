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
        if ([code isEqualToString:@"FFN"]) {
            FFNrandomAttackChance = 20;
        } else {
            FFNrandomAttackChance = 0;
        }
        
        attackRadius = 250;
        attackSplash = 70;
        attackSpeed = 1;
        attackDamage = 10;
        attackModifier = code;
        bulletImg = @"";
        bulletSpeed = 0.4;
        
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
                                                 selector:@selector(readyWeapon) userInfo:nil repeats:YES];
     // should fire a shot as soon as in range
    //[self readyWeapon];
    //[self runAction:[SKAction sequence:@[ [SKAction waitForDuration:attackSpeed/2], [SKAction runBlock:^{[self readyWeapon];}] ] ]];
    [enemy getAttackedBy:self];
}

-(void)readyWeapon
{
    [self shootWeaponAt:currentCreep];
    
    // special FFN (volcano extra shot)
    if (FFNrandomAttackChance != 0) {
        if ((arc4random() % (100) <= FFNrandomAttackChance)) {
            // lag a little bit before the extra shot is fired
            // IN FUTURE PLAY A LITTLE SOUND THAT SHOWS THE USER GOT THE EXTRA SHOT
            
           [self runAction: [SKAction sequence:@[ [SKAction waitForDuration:attackSpeed/2],
                                  [SKAction runBlock:^{
                NSMutableArray *enemiesToAtt = [[NSMutableArray alloc]init];
                for (Creep *enemy in mapScene.enemies) {
                    if ([mapScene doesCircle:self.position withRadius:attackRadius collideWithCircle:enemy.position collisionCircleRadius:25]) {
                        [enemiesToAtt addObject:enemy];
                    }
                }
               
               if ([enemiesToAtt count] != 0) {
                   int randomCreep = arc4random() % ([enemiesToAtt count]);
                   [self shootWeaponAt:enemiesToAtt[randomCreep]];
               }
               
            }] ]] ];
            
        }
    }
    
}

- (void) shootWeaponAt: (Creep *) thisCreep {
    if (thisCreep) {
        Bullet * bullet = [[Bullet alloc]initWithCode:towerCode andImageName:bulletImg];
        [mapScene.background addChild:bullet];
        [bullet setPosition:self.position];
        NSMutableArray *actions = [[NSMutableArray alloc]initWithObjects:[SKAction moveTo:thisCreep.position duration:bulletSpeed],
                                   [SKAction runBlock:^{[self damageThisCreep: thisCreep]; [self removeBullet:bullet];}],
                                   nil];
        [bullet runAction:[SKAction sequence:actions]];
    }
}

-(void)removeBullet:(Bullet *)bullet
{
    [bullet removeFromParent];
}

-(void)damageThisCreep: (Creep*) creepToHurt
{
    [creepToHurt getDamaged:attackDamage withSplashRadius:attackSplash withEffect:attackModifier];
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
