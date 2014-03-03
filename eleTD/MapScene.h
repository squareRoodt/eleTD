//
//  MapScene.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MapScene : SKScene {
    NSMutableArray *towerBases;
}

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKNode *selectedNode;

@end
