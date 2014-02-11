//
//  MyScene.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 10/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "MyScene.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@implementation MyScene

@synthesize background;
@synthesize selectedNode;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
       
        //Loading the background
        background = [SKSpriteNode spriteNodeWithImageNamed:@"mapBeta1"];
        [background setName:@"background"];
        [background setAnchorPoint:CGPointZero];
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            background.size = CGSizeMake(background.size.width/3.0, background.size.height/3.0);
        } else if (IS_IPAD) {
            background.size = CGSizeMake(background.size.width/1.6, background.size.height/1.6);
        }
        [self addChild:background];
        
        
        
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self findSelectedNodeInTouch:positionInScene];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([selectedNode.name isEqualToString:@"background"]) {
        CGPoint currentLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        float newPosX = (previousLocation.x - currentLocation.x);
        float newPosY = (previousLocation.y - currentLocation.y);
        CGPoint newPos = CGPointMake(newPosX, newPosY);
        [self scrollMap: newPos];
    }
    
    
}

- (void) scrollMap: (CGPoint) newPos {
    CGSize winSize = self.size;
    CGPoint scrollPoint = CGPointMake(background.position.x - newPos.x, background.position.y - newPos.y);
    scrollPoint.x = MIN(scrollPoint.x, 0);
    scrollPoint.x = MAX(scrollPoint.x, -[background size].width+ winSize.width);
    scrollPoint.y = MIN(scrollPoint.y, 0);
    scrollPoint.y = MAX(scrollPoint.y, -[background size].height+ winSize.height);
    
    [background setPosition: scrollPoint];
}


- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    NSLog(@"touch on screen");
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
	if(![selectedNode isEqual:touchedNode]) {
		selectedNode = touchedNode;
        NSLog(@"touched %@", selectedNode.name);
		if([[touchedNode name] isEqualToString:@"tower"]) {
			
		}
	}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
