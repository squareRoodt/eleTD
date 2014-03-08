//
//  MapScene.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class ViewController;
@class Map;

@interface MapScene : SKScene {
    NSMutableArray *towerBases;
    
    // these dont work??? have to manually use (Map*)self.view
    ViewController *viewController;
    Map *parentMap;
    NSTimer *creepCreator;
}

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKNode *selectedNode;
@property (nonatomic, strong) NSMutableArray *towers;
@property (nonatomic, strong) NSMutableArray *enemies;

- (void) buildTowerOfType: (NSString*)code;
-(BOOL)doesCircle:(CGPoint) circlePoint withRadius:(float) radius
collideWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo;

@end
