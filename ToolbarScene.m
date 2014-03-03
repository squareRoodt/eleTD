//
//  ToolbarScene.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "ToolbarScene.h"

@implementation ToolbarScene
@synthesize background;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //Loading the background
        /*
        background = [SKSpriteNode spriteNodeWithImageNamed:@"mapBeta1"];
        [background setName:@"background"];
        [background setAnchorPoint:CGPointZero];
        
        [self addChild:background];
        */
        
        self.backgroundColor = [SKColor whiteColor];
        
       
    }
    return self;
}

    

@end
