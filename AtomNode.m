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
float speed = 0.05;
int rad = 6;

- (id) initWithRotation: (float) angle {
    if (self = [super init]) {
        
        [self runAction:[SKAction rotateByAngle:angle duration:0]];
        self.anchorPoint = CGPointMake(20, 50);
        atomEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"atomParticleEffect" ofType:@"sks"]];
        atomEmitter.position = CGPointMake(30, 50);
        
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
        //[self runAction:[SKAction repeatActionForever:atomRotation]];
    }
    return self;
}

- (void) deleteElement: (NSString *) originElement {
    if ([originElement isEqualToString:@"F"]) {
        
    }
}

- (void) changeElement: (NSString *) elementChange {
    NSLog(@"change element to %@", elementChange);
    atomEmitter.particleColorSequence = nil;
    atomEmitter.particleColorBlendFactor = 1.0;
    
    // STILL NEEDS WORK. THE COLOURS ARE NOT GOOD ENOUGH
    if ([elementChange isEqualToString:@"F"]) {
        //atomEmitter.particleColor = [SKColor colorWithRed:1 green:122/255.0 blue:3/255.0 alpha:1];
        atomEmitter.particleColor = [SKColor redColor];
    } else if ([elementChange isEqualToString:@"W"]) {
        atomEmitter.particleColor = [SKColor colorWithRed:0 green:162/255.0 blue:1 alpha:1];
    } else if ([elementChange isEqualToString:@"L"]) {
        atomEmitter.particleColor = [SKColor colorWithRed:203/255.0 green:150/255.0 blue:1 alpha:1];
        //atomEmitter.particleColor = [SKColor ];
    } else if ([elementChange isEqualToString:@"N"]) {
        atomEmitter.particleColor = [SKColor colorWithRed:30/255.0 green:210/255.0 blue:0 alpha:1];
        //atomEmitter.particleColor = [SKColor greenColor];
    } else if ([elementChange isEqualToString:@"D"]) {
        //atomEmitter.particleColor = [SKColor colorWithRed:36/255.0 green:0 blue:110/255.0 alpha:1];
        atomEmitter.particleColor = [SKColor blackColor];
    } else {
        NSLog(@"ERROR atomic element was changed to an invalid element");
    }
}

- (void) rotateBy: (float) angle {
    [self runAction:[SKAction rotateByAngle:angle duration:0]];
}

- (void) turnOn {
    atomEmitter.particleBirthRate = 300;
}

- (void) turnOff {
    atomEmitter.particleBirthRate = 0;
}

- (void) spinOtherWay {
    
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


