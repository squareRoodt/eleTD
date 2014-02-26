//
//  AtomNode.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 25/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "AtomNode.h"

@implementation AtomNode
@synthesize atomEmitter;

// building circle on cartesian plane
int a = 2;
int b = 1;

// using velocity to turn atom
float atomAngle = 90;
float turn = 1;
float speed = 0.001;
int rad = 6;

- (id) initWithRotation: (float) angle {
    if (self = [super init]) {
        [self runAction:[SKAction rotateByAngle:angle duration:0]];
        //self.anchorPoint = CGPointZero;
        atomEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"atomParticleEffect" ofType:@"sks"]];
        atomEmitter.position = CGPointMake(0, 50);
        
        // SKAction
        SKAction *atomRotation = [SKAction sequence:@[[SKAction runBlock:^{
            // for a frame of 100 height
            if (atomAngle >= 10800) {
                atomAngle = 0;
            }
            atomAngle += 0.1;
            
            float x = turn * sin(atomAngle);
            float y = turn * cos(atomAngle)*2;
            [atomEmitter runAction:[SKAction moveByX:rad*x y:rad*y duration:speed]];
        }], [SKAction waitForDuration:speed]
                                            
                                            ]];
        
        
        [self addChild:atomEmitter];
        [self runAction:[SKAction repeatActionForever:atomRotation]];
        [self runAction:[SKAction repeatActionForever:atomRotation]];
    }
    return self;
}


- (void) animate {
    
    //[self runAction:[SKAction repeatActionForever:atomRotation]];
}

- (void) rotateBy: (float) angle {
    [self runAction:[SKAction rotateByAngle:angle duration:0]];
}

@end



/*
// calculations for atom's spinning
- (float) findNextRotationPosX: (float) y{
    NSLog(@"ATOM POSITION:   %f    %f", atomEmitter.position.x, atomEmitter.position.y);
    NSLog(@"y: %f", y);
    NSLog(@"x: %f", (a * (sqrtf((rad^2 * (b^2)) - (y * y)))) / (b^2));
    NSLog(@"circle x: %f", ((a * sqrtf((rad^2 * b^2) - (y*y))) / b));
    
    if (incY < 0) {
        return - (a * (sqrtf((rad^2 * (b*b)) - (y * y)))) / (b*b);
    } else {
        return (a * (sqrtf((rad^2 * (b*b)) - (y * y)))) / (b*b);
    }
    
}

- (float) findNextRotationPosY: (float) x {
    NSLog(@"ATOM POSITION:   %f    %f", atomEmitter.position.x, atomEmitter.position.y);
    NSLog(@"x: %f", x);
    NSLog(@"y: %f", (-0.5) * (sqrtf(8100 - (x*x))) );
    
    if (incX < 0) {
        return (0.5) * (sqrtf(8100 - (x*x)));
    } else {
        return (-0.5) * (sqrtf(8100 - (x*x)));
    }
    
    
}
 
 - (void) moveForward: (float) angle {
 float x = turn*2 * sin(angle);
 float y = turn * cos(angle);
 //NSLog(@"x");
 [atomEmitter runAction:[SKAction moveByX:rad*x y:rad*y duration:speed]];
 }
 
 */


