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
    SKSpriteNode *eleNull;
    
    NSMutableArray *elements;
    
    SKSpriteNode *currentElement;
    
    CGRect selectableF;
    CGRect selectableW;
    CGRect selectableL;
    CGRect selectableN;
    CGRect selectableD;
    CGRect atomCenter;
    
    SKNode *currentDrag;
    SKEmitterNode *dragFire;
    SKEmitterNode *dragFire2;
    SKEmitterNode *dragWater;
    SKEmitterNode *dragDark;
    SKEmitterNode *dragDark2;
    SKEmitterNode *dragNature1;
    SKEmitterNode *dragNature2;
    SKEmitterNode *dragNature3;
    SKEmitterNode *dragLight1;
    SKEmitterNode *dragLight2;
    SKEmitterNode *dragLight3;
    
    SKAction *fireExplosion;
    SKAction *waterExplosion;
    SKAction *darkExplosion;
    SKAction *natureExplosion;
    SKAction *lightExplosion;
    
    bool isRemovingAtom;
    //bool canClickElement;
    NSTimer *spamControlTimer;
}

@end
