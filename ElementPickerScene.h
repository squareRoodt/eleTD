//
//  ElementPickerScene.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AtomNode.h"

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
    
    SKEmitterNode *atomParticles;
    AtomNode *atom1;
    AtomNode *atom2;
    AtomNode *atom3;
    AtomNode *currentAtom;
    
    SKAction *fireExplosion;
    SKAction *waterExplosion;
    SKAction *darkExplosion;
    SKAction *natureExplosion;
    SKAction *lightExplosion;
    SKAction *atomMovement;
    
    bool isRemovingAtom;
    //bool canClickElement;
    NSTimer *spamControlTimer;
    CGPoint endPoint;
}

@end
