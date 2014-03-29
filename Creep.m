//
//  Creep.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 3/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//


#import "Creep.h"
#import "MapScene.h"
#import "Tower.h"
#import "Bullet.h"

@implementation Creep {
    NSMutableArray *creepImagesUp;
    NSMutableArray *creepImagesDown;
    NSMutableArray *creepImagesLeft;
    NSMutableArray *creepImagesRight;
    NSMutableArray *wayPoints;
}

@synthesize mapScene, movementTimer, nextDestination, lastDestination, walkingSpeed, maxHP, currentHP;

- (id) initWithMap: (MapScene*) map andCode: (NSString*) code {
    if ((self=[super initWithImageNamed:@"c1d"])) {
        
        deadEnemies = [[NSMutableArray alloc]init];
        mapScene = map;
        creepCode = code;
        
        waypointWaitingTime = 0;
      
        maxHP = 40;
        currentHP = maxHP;
        active = NO;
        walkingSpeed = 120.0;
        walkingTime = 0.053; // ??? FPS
        
        [self setupWayPoints];
        [self setPosition:lastDestination];
        
        attackedByTowers = [[NSMutableArray alloc] initWithCapacity:5];
        
        // do a healthBar
        healthBarGreen = [[SKSpriteNode alloc]initWithImageNamed:@"hpGreen"];
        healthBarRed = [[SKSpriteNode alloc]initWithImageNamed:@"hpRed"];
        healthBarGreen.position = CGPointMake(-25, 25);
        healthBarRed.position = CGPointMake(-25, 25);
        [healthBarGreen setAnchorPoint:CGPointZero];
        [healthBarRed setAnchorPoint:CGPointZero];
        
        [self addChild:healthBarRed];
        [self addChild:healthBarGreen];
        
        up = [SKTexture textureWithImageNamed:@"c1u"];
        down = [SKTexture textureWithImageNamed:@"c1d"];
        right = [SKTexture textureWithImageNamed:@"c1l"];
        left = [SKTexture textureWithImageNamed:@"c1r"];
        
    }
    return self;
}

- (void) creepMovementTimer: (NSTimeInterval)time {
    
    if (!oldTime) {
        oldTime = time;
    }
    
    
    waypointWaitingTime ++;
    
    // waypoints
    if ([mapScene doesCircle:self.position withRadius:5 collideWithCircle:nextDestination collisionCircleRadius:5] &&
        waypointWaitingTime >= 3) {
        
        waypointWaitingTime = 0;
        
        if (nextDestinationIndex == 13) {
            nextDestinationIndex = 0;   // compensating for next ++
            nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
            lastDestination = [[wayPoints objectAtIndex:0] CGPointValue];
            self.position = CGPointMake(lastDestination.x, lastDestination.y);
        }
        
        lastDestination = nextDestination;
        nextDestinationIndex ++;
        nextDestination = [[wayPoints objectAtIndex:nextDestinationIndex] CGPointValue];
        
        self.position = lastDestination;
        
        // creep directions
        //NSLog(@"%d", nextDestinationIndex);
        
        switch (nextDestinationIndex) {
            case 1:
                self.texture = down;
                break;
                
            case 2:
                self.texture = left;
                break;
                
            case 3:
                self.texture = down;
                break;
                
            case 4:
                self.texture = right;
                break;
                
            case 5:
                self.texture = up;
                break;
                
            case 6:
                self.texture = right;
                break;
                
            case 7:
                self.texture = down;
                break;
                
            case 8:
                self.texture = left;
                break;
                
            case 9:
                self.texture = down;
                break;
                
            case 10:
                self.texture = right;
                break;
                
            case 11:
                self.texture = up;
                break;
                
            case 12:
                self.texture = left;
                break;
                
            case 13:
                self.texture = up;
                break;
                
            default:
                self.texture = down;
                break;
        }
    }
    
    float walkingSpeedTimeAffected = walkingSpeed * (time - oldTime);
    
    if (nextDestination.x != lastDestination.x) /* moving along X */ {
        if (lastDestination.x < nextDestination.x)  /* LEFT */{
            self.position = CGPointMake(self.position.x + walkingSpeedTimeAffected, self.position.y);
        } else /* RIGHT */ {
            self.position = CGPointMake(self.position.x - walkingSpeedTimeAffected, self.position.y);
        }
    }
    if (nextDestination.y != lastDestination.y) /* moving along Y */{
        if (lastDestination.y < nextDestination.y)  /* UP */{
            self.position = CGPointMake(self.position.x, self.position.y + walkingSpeedTimeAffected);
        } else /* DOWN */ {
            self.position = CGPointMake(self.position.x, self.position.y - walkingSpeedTimeAffected);
        }
    }
    
    oldTime = time;
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

-(void)getRemoved
{
    for(Tower * attacker in attackedByTowers)
    {
        [attacker targetKilled];
    }
    
    //[self.parent removeChild:self cleanup:YES];
    [self removeFromParent];
    [mapScene.enemies removeObject:self];
    
    //Notify the game that we killed an enemy so we can check if we can send another wave
    [mapScene enemyGotKilled];
    
    // check for next level
    if ([mapScene.enemies count] == 0) {
        [mapScene levelEnded];
    }
}

-(void)getAttackedBy:(Tower *)attacker
{
    [attackedByTowers addObject:attacker];
}

-(void)gotLostSight:(Tower *)attacker
{
    [attackedByTowers removeObject:attacker];
}



-(void)getDamaged:(float)damage withSplashRadius: (float) splash withEffect: (NSString*) effect
{
    
    for (Creep *enemy in mapScene.enemies) {
        if ([mapScene doesCircle:self.position withRadius:splash collideWithCircle:enemy.position collisionCircleRadius:10]) {
            enemy.currentHP -=damage;
            enemy->healthBarGreen.xScale = enemy.currentHP/enemy.maxHP;
            if(enemy.currentHP <=0)
            {
                //[enemy getRemoved];
                [deadEnemies addObject:enemy];
            }
        }
    }
    
    for (Creep *enemy in deadEnemies) {
        [enemy getRemoved];
    }
}



@end
