//
//  ElementPickerScene.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//                                       NOTES:
// - to make the element draggers go to their location first and then start animating, (ie) fire burst in flames on fire
// and not on the last element, then just make the animation perform a block skaction before the current block which changes
// the position. (for now it looks cool when you spam it)

#import "ElementPickerScene.h"

@implementation ElementPickerScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        currentDrag = [[SKNode alloc]init];
        
        atom1 = [[AtomNode alloc] initWithRotation:0];
        atom2 = [[AtomNode alloc] initWithRotation:45];
        atom3 = [[AtomNode alloc] initWithRotation:90];
        atom1.position = CGPointMake(330, 381);
        atom2.position = CGPointMake(330, 381);
        atom3.position = CGPointMake(330, 381);
        atom1.atomEmitter.targetNode = self;
        atom2.atomEmitter.targetNode = self;
        atom3.atomEmitter.targetNode = self;
        [self addChild:atom1];
        [self addChild:atom2];
        [self addChild:atom3];
        //[atom1 animate];
        //[atom2 animate];
        //[atom3 animate];
        
        //atomParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire" ofType:@"sks"]];
        isRemovingAtom = false;
        [self addChild:currentDrag];
        endPoint = CGPointMake(330, 381);
        
        
        /*spamControlTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                            target:self
                                                          selector:@selector(spamChecker)
                                                          userInfo:nil
                                                           repeats:YES];*/
        
        eleFire = [SKSpriteNode spriteNodeWithImageNamed:@"selectF1"];
        eleWater = [SKSpriteNode spriteNodeWithImageNamed:@"selectW1"];
        eleLight = [SKSpriteNode spriteNodeWithImageNamed:@"selectL1"];
        eleNature = [SKSpriteNode spriteNodeWithImageNamed:@"selectN1"];
        eleDark = [SKSpriteNode spriteNodeWithImageNamed:@"selectD1"];
        eleNull = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
        
        eleFire.name = @"fire";
        eleWater.name = @"water";
        eleLight.name = @"light";
        eleNature.name = @"nature";
        eleDark.name = @"dark";
        eleNull.name = @"null";
        [self addChild:eleNull];
        currentElement = eleNull;
        
        // iPad dimensions
        selectableF = CGRectMake(64, 441, 265, 199);
        selectableW = CGRectMake(341, 430, 226, 196);
        selectableL = CGRectMake(464, 151, 153, 277);
        selectableN = CGRectMake(183, 89, 268, 120);
        selectableD = CGRectMake(50, 163, 143, 238);
        atomCenter = CGRectMake(271, 292, 110, 140);
        
        elements = [[NSMutableArray alloc] initWithObjects:eleFire, eleWater, eleLight, eleNature, eleDark, nil];
        CGPoint elePoint = CGPointMake(45, 70);
        float eleScale = 3.5; // smaller is bigger
        
        for (SKSpriteNode *element in elements) {
            [element setAnchorPoint:CGPointZero];
            element.position = elePoint;
            element.size = CGSizeMake(element.size.width/eleScale, element.size.height/eleScale);
            [self addChild:element];
        }
        
        // ===============================================  SKActions  =============================================
        
        // SKActions
        // (fire)
        dragFire =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire" ofType:@"sks"]];
        dragFire2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire2" ofType:@"sks"]];
        dragFire.targetNode = self;
        dragFire2.targetNode = self;
        [currentDrag addChild:dragFire2];
        [currentDrag addChild:dragFire];
        CGPoint fireLocation =CGPointMake(187, 541);
        
        fireExplosion = [SKAction sequence:@[[SKAction runBlock:^{currentDrag.position = fireLocation;}],
                                             [SKAction runBlock:^{
            currentDrag.position = fireLocation;
            dragFire.particleBirthRate = 2000;
            dragFire2.particleBirthRate = 250;
            dragFire.particleScale = 1.3;
            dragFire2.particleSpeed = 120;
            dragFire.particlePositionRange = CGVectorMake(100, 50);
            dragFire2.particlePositionRange = CGVectorMake(100, 50);
        }],
                                             [SKAction waitForDuration:0.05],
                                             [SKAction runBlock:^{
            dragFire.particleBirthRate = 650;
            dragFire2.particleBirthRate = 250;
            dragFire.particleScale = 0.5;
            dragFire2.particleSpeed = 79;
            dragFire.particlePositionRange = CGVectorMake(25.5, 4.5);
            dragFire2.particlePositionRange = CGVectorMake(22, 7.6);
            dragFire.particleBirthRate = 385;
            dragFire2.particleBirthRate = 60;
        }],
                                             [SKAction waitForDuration:1]
                                             ]];
    }
    
    
    
    // (water)
    dragWater =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragWater" ofType:@"sks"]];
    dragWater.targetNode = self;
    [currentDrag addChild:dragWater];
    CGPoint waterLocation =CGPointMake(460, 540);
    
    waterExplosion = [SKAction sequence:@[[SKAction runBlock:^{currentDrag.position = waterLocation;}],
                                          [SKAction runBlock:^{
        currentDrag.position = waterLocation;
        dragWater.particleBirthRate = 4000;
        dragWater.particleSpeedRange = 400;
        dragWater.particleLifetime = 2.0;
    }],
                                         [SKAction waitForDuration:0.05],
                                         [SKAction runBlock:^{
        dragWater.particleBirthRate = 275;
        dragWater.particleSpeedRange = 110;
        dragWater.particleLifetime = 1.4;
    }]
                                       
                                         ]];
    
    // (nature)
    dragNature1 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragNature1" ofType:@"sks"]];
    dragNature2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragNature2" ofType:@"sks"]];
    dragNature3 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragNature3" ofType:@"sks"]];
    dragNature1.targetNode = self;
    dragNature2.targetNode = self;
    dragNature3.targetNode = self;
    [currentDrag addChild:dragNature1];
    CGPoint natureLocation = CGPointMake(334, 114);
    
    // special case for nature
    [self addChild:dragNature3];
    [self addChild:dragNature2];
    [dragNature2 setZPosition:10];
    dragNature2.position = CGPointMake(natureLocation.x, natureLocation.y + 60);
    dragNature3.position = CGPointMake(natureLocation.x, natureLocation.y + 60);
    
    natureExplosion = [SKAction sequence:@[ [SKAction runBlock:^{currentDrag.position = natureLocation;}],
                                          [SKAction runBlock:^{
        dragNature3.particleBirthRate = 500;
        dragNature2.particleBirthRate = 200;
        dragNature1.particleBirthRate = 40;
    }],
                                          [SKAction waitForDuration:0.05],
                                          [SKAction runBlock:^{
        dragNature3.particleBirthRate = 0;
        dragNature2.particleBirthRate = 0;
        
    }]
                                          ]];
    
    // (light)
    dragLight1 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragLight3" ofType:@"sks"]];
    dragLight2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragLight4" ofType:@"sks"]];
    dragLight3 = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragLight2" ofType:@"sks"]];
    dragLight3.targetNode = self;
    dragLight1.targetNode = self;
    dragLight2.targetNode = self;
    [currentDrag addChild:dragLight2];
    [currentDrag addChild:dragLight1];
    [currentDrag addChild:dragLight3];
    dragLight1.zPosition = 100;
    CGPoint lightLocation =CGPointMake(555, 286);
    
    lightExplosion = [SKAction sequence:@[ [SKAction runBlock:^{currentDrag.position = lightLocation;}],
                                          [SKAction runBlock:^{
        dragLight2.particleBirthRate = 640;
        dragLight1.particleBirthRate = 130;
        dragLight3.particleBirthRate = 17;
    }],
                                          [SKAction waitForDuration:0.05],
                                          [SKAction runBlock:^{
        
        dragLight3.particleBirthRate = 0;
    }]
                                          ]];
    
    
    // (dark)
    dragDark =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragDark" ofType:@"sks"]];
    dragDark2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragDark2" ofType:@"sks"]];
    dragDark.targetNode = self;
    dragDark2.targetNode = self;
    [currentDrag addChild:dragDark];
    [currentDrag addChild:dragDark2];
    CGPoint darkLocation =CGPointMake(108, 298);
    
    darkExplosion = [SKAction sequence:@[ [SKAction runBlock:^{currentDrag.position = darkLocation;}],
                                          [SKAction runBlock:^{
        dragDark.particleBirthRate = 5000;
        dragDark.particleLifetime = 2;
        dragDark.particleScale = 0.2;
        dragDark.particleSpeed = 150;
        
    }],
                                          [SKAction waitForDuration:0.05],
                                          [SKAction runBlock:^{
        dragDark.particleBirthRate = 500;
        dragDark.particleLifetime = 3.8;
        dragDark.particleScale = 0.2;
        dragDark.particleSpeed = 0;
        dragDark2.particleBirthRate = 1.3;
        dragDark2.particleScale = 0.4;
        
    }]
                                          ]];
    // ===============================================  SKActions  =============================================
    
    [self removeElementDraggers];
    return self;
}

//  TOUCH BEGAN
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    //NSLog(@"%@", currentDrag.children);
    [self findSelectedNodeInTouch:positionInScene];
    
}

- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    //NSLog(@"touch on element picker screen");
    NSLog(@"X: %f,   Y: %f", touchLocation.x, touchLocation.y);
    // assume you are adding atoms until told you are removing
    isRemovingAtom = false;
    
    if (CGRectContainsPoint(selectableF, touchLocation)) {
        currentElement = eleFire;
        [self runAction: fireExplosion];
        
    } else if (CGRectContainsPoint(selectableW, touchLocation)) {
        currentElement = eleWater;
        [self runAction:waterExplosion];
        
    } else if (CGRectContainsPoint(selectableL, touchLocation)) {
        currentElement = eleLight;
        [self runAction:lightExplosion];
        
    } else if (CGRectContainsPoint(selectableN, touchLocation)) {
        currentElement = eleNature;
        [self runAction:natureExplosion];
        
    } else if (CGRectContainsPoint(selectableD, touchLocation)) {
        currentElement = eleDark;
        [self runAction: darkExplosion];
        
    } else if (CGRectContainsPoint(atomCenter, touchLocation)) {
        // removing an element from the atom
        isRemovingAtom = true;
    } else {
        currentElement = eleNull;
    }
    
    NSLog(@"touched %@ element", currentElement.name);
	
}

// TOUCH MOVED
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    
    if (isRemovingAtom) {
        
    } else {
        if ([currentElement.name isEqualToString:@"fire"]) {
            
            if (positionInScene.y < (-1.1189 * positionInScene.x) + 750.23) {
                // y = mx + c
                [currentDrag runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (-1.1189 * positionInScene.x) + 750.23) duration:0.01]];
            } else {
                // x = (y - c) / m
                [currentDrag runAction:[SKAction moveTo:CGPointMake((positionInScene.y - 750.23)/-1.1189, positionInScene.y) duration:0.01]];
            }
            
            // add new element to atom collection
            if (currentDrag.position.y <= endPoint.y) {
                [self removeElementDraggers];
                [self addElement:@"F"];
            }
            
            // dragged out of range
            if (currentDrag.position.y > 700) {
                [self removeElementDraggers];
            }
            
        } else if ([currentElement.name isEqualToString:@"water"]) {
            // movement
            // y = 1.22x - 21.2
            if (positionInScene.y < (1.22 * positionInScene.x) - 21.2) {
                // y = mx + c
                [currentDrag runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (1.22 * positionInScene.x) - 21.2) duration:0.01]];
            } else {
                // x = (y - c) / m
                [currentDrag runAction:[SKAction moveTo:CGPointMake((positionInScene.y + 21.2)/1.22, positionInScene.y) duration:0.01]];
            }
            
            // add new element to atom collection
            if (currentDrag.position.y <= endPoint.y) {
                [self removeElementDraggers];
                [self addElement:@"W"];
            }
            
            // dragged out of range
            if (currentDrag.position.y > 700) {
                [self removeElementDraggers];
            }
            
        } else if ([currentElement.name isEqualToString:@"light"]) {
            [currentDrag runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (-0.42 * positionInScene.x) + 520) duration:0.01]];
            
            
            // add new element to atom collection
            if (currentDrag.position.x <= endPoint.x) {
                [self removeElementDraggers];
                [self addElement:@"L"];
            }
            
            // dragged out of range
            if (currentDrag.position.x > self.view.bounds.size.width) {
                [self removeElementDraggers];
            }
            
        } else if ([currentElement.name isEqualToString:@"nature"]) {
            [currentDrag runAction:[SKAction moveTo:CGPointMake(endPoint.x, positionInScene.y) duration:0.01]];
            
            
            // add new element to atom collection
            if (currentDrag.position.y >= endPoint.y) {
                [self removeElementDraggers];
                [self addElement:@"N"];
            }
            
            // dragged out of range
            if (currentDrag.position.y < 0) {
                [self removeElementDraggers];
            }
            
        } else if ([currentElement.name isEqualToString:@"dark"]) {
            [currentDrag runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (0.374 * positionInScene.x) + 257.6) duration:0.01]];
            
            
            // add new element to atom collection
            if (currentDrag.position.x >= endPoint.x) {
                [self removeElementDraggers];
                [self addElement:@"D"];
            }
            
            // dragged out of range
            if (currentDrag.position.x < 0) {
                [self removeElementDraggers];
            }
        }
    }
    
}

- (void) addElement: (NSString *) elementType {
    NSLog(@"added %@ element", elementType);
    
}


// TOUCH ENDED
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   // NSLog(@"finger lifted     %@", currentDrag.children);
    [self removeElementDraggers];
    /*
    if ([currentElement.name isEqualToString:@"fire"]) {
        [self removeElementDraggers];
    } else if ([currentElement.name isEqualToString:@"water"]) {
        [self removeElementDraggers];
        
    } else if ([currentElement.name isEqualToString:@"light"]) {
        
    } else if ([currentElement.name isEqualToString:@"nature"]) {
        
    } else if ([currentElement.name isEqualToString:@"dark"]) {
        
    }*/
    
}


- (void) removeElementDraggers {
    currentElement = eleNull;
    dragFire.particleBirthRate = 0;
    dragFire2.particleBirthRate = 0;
    dragWater.particleBirthRate = 0;
    dragDark.particleBirthRate = 0;
    dragDark2.particleBirthRate = 0;
    dragNature1.particleBirthRate = 0;
    dragNature2.particleBirthRate = 0;
    dragNature3.particleBirthRate = 0;
    dragLight1.particleBirthRate = 0;
    dragLight2.particleBirthRate = 0;
    dragLight3.particleBirthRate = 0;
}


/*
- (float) findNextRotationPosY: (CGPoint) currentPos {
    return (5 * (sqrtf(25 - (currentPos.x * currentPos.x)))) / 25;
}*/


@end
