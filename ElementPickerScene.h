//
//  ElementPickerScene.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ElementPickerScene : SKScene {
    SKSpriteNode *eleFire;
    SKSpriteNode *eleWater;
    SKSpriteNode *eleLight;
    SKSpriteNode *eleNature;
    SKSpriteNode *eleDark;
    
    NSMutableArray *elements;
    
    SKSpriteNode *currentElement;
    
    CGRect selectableF;
    CGRect selectableW;
    CGRect selectableL;
    CGRect selectableN;
    CGRect selectableD;
    CGRect atomCenter;
    
    SKEmitterNode *dragFire;
    SKEmitterNode *dragFire2;
    
    SKAction *fireExplosion;
    
    bool isRemovingAtom;
    bool canClickElement;
    NSTimer *spamControlTimer;
}

@end
