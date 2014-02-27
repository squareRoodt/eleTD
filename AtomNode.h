//
//  AtomNode.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 25/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AtomNode : SKSpriteNode {
    //SKAction *atomRotation;
    float incY;
    float nextY;
    float incX;
    float nextX;
}

@property SKEmitterNode *atomEmitter;
@property NSString *element;

- (void) deleteElement: (NSString *) originElement;
- (void) changeElement: (NSString *) element;
- (void) rotateBy: (float) angle;
- (id) initWithRotation: (float) angle;
- (void) turnOn;
- (void) turnOff;
- (void) spinOtherWay;

@end
