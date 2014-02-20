//
//  ElementPickerScene.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 18/02/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "ElementPickerScene.h"

@implementation ElementPickerScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        isRemovingAtom = false;
        canClickElement = true;
        spamControlTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                            target:self
                                                          selector:@selector(spamChecker)
                                                          userInfo:nil
                                                           repeats:YES];
        
        eleFire = [SKSpriteNode spriteNodeWithImageNamed:@"selectF1"];
        eleWater = [SKSpriteNode spriteNodeWithImageNamed:@"selectW1"];
        eleLight = [SKSpriteNode spriteNodeWithImageNamed:@"selectL1"];
        eleNature = [SKSpriteNode spriteNodeWithImageNamed:@"selectN1"];
        eleDark = [SKSpriteNode spriteNodeWithImageNamed:@"selectD1"];
        
        eleFire.name = @"fire";
        eleWater.name = @"water";
        eleLight.name = @"light";
        eleNature.name = @"nature";
        eleDark.name = @"dark";
        
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
        
        
    }
    return self;
}

- (void) spamChecker {
    canClickElement = true;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    if (canClickElement) {
        [self findSelectedNodeInTouch:positionInScene];
        canClickElement = false;
    }
    
}

- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    //NSLog(@"touch on element picker screen");
    //NSLog(@"X: %f,   Y: %f", touchLocation.x, touchLocation.y);
    // assume you are adding atoms until told you are removing
    isRemovingAtom = false;
    
    if (CGRectContainsPoint(selectableF, touchLocation)) {
        
        currentElement = eleFire;
        
        // SKActions
        // (fire)
        fireExplosion = [SKAction sequence:@[[SKAction runBlock:^{
            dragFire.particleBirthRate = 2000;
            dragFire2.particleBirthRate = 250;
            dragFire.particleScale = 0.9;
            dragFire2.particleSpeed = 120;
            dragFire.particlePositionRange = CGVectorMake(100, 50);
            dragFire2.particlePositionRange = CGVectorMake(100, 50);
        }],
                                             [SKAction waitForDuration:0.05],
                                             [SKAction runBlock:^{
            dragFire.particleBirthRate = 450;
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
        
        // adding fire particles
        dragFire =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire" ofType:@"sks"]];
        dragFire2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire2" ofType:@"sks"]];
        CGPoint fireLocation =CGPointMake(187, 541);
        dragFire2.position = fireLocation;
        dragFire.position = fireLocation;
        dragFire.targetNode = self;
        dragFire2.targetNode = self;
        
        
        [self addChild:dragFire2];
        [self addChild:dragFire];
        [self runAction: fireExplosion];
        
    } else if (CGRectContainsPoint(selectableW, touchLocation)) {
        currentElement = eleWater;
        
    } else if (CGRectContainsPoint(selectableL, touchLocation)) {
        currentElement = eleLight;
        
    } else if (CGRectContainsPoint(selectableN, touchLocation)) {
        currentElement = eleNature;
        
    } else if (CGRectContainsPoint(selectableD, touchLocation)) {
        currentElement = eleDark;
        
    } else if (CGRectContainsPoint(atomCenter, touchLocation)) {
        // removing an element from the atom
        isRemovingAtom = true;
    } else {
        currentElement = Nil;
    }
    
    NSLog(@"touched %@ element", currentElement.name);
	
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // [_player runAction:[SKAction moveTo:[[touches anyObject] locationInNode:self] duration:0.01]];
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint endPoint = CGPointMake(330, 381);
    
    if (isRemovingAtom) {
        
    } else {
        if ([currentElement.name isEqualToString:@"fire"]) {
            
            if (positionInScene.y < (-1.1189 * positionInScene.x) + 750.23) {
                // y = mx + c
                [dragFire runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (-1.1189 * positionInScene.x) + 750.23) duration:0.01]];
                [dragFire2 runAction:[SKAction moveTo:CGPointMake(positionInScene.x, (-1.1189 * positionInScene.x) + 750.23) duration:0.01]];
            } else {
                // x = (y - c) / m
                [dragFire runAction:[SKAction moveTo:CGPointMake((positionInScene.y - 750.23)/-1.1189, positionInScene.y) duration:0.01]];
                [dragFire2 runAction:[SKAction moveTo:CGPointMake((positionInScene.y - 750.23)/-1.1189, positionInScene.y) duration:0.01]];
                
            }
            
            // add new element to atom collection
            if (dragFire.position.y <= endPoint.y) {
                
                [dragFire removeFromParent];
                [dragFire2 removeFromParent];
                currentElement = nil;
                
                [self addElement:@"F"];
            }
            
            // dragged out of range
            if (dragFire.position.y > 650) {
                dragFire.particleBirthRate = 0;
                dragFire2.particleBirthRate = 0;
                
                SKAction *remF = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{[dragFire removeFromParent];
                }] ]];
                SKAction *remF2 = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{[dragFire2 removeFromParent];
                }] ]];
                
                [self runAction:remF];
                [self runAction:remF2];
            }
            
        } else if ([currentElement.name isEqualToString:@"water"]) {
            
        } else if ([currentElement.name isEqualToString:@"light"]) {
            
        } else if ([currentElement.name isEqualToString:@"nature"]) {
            
        } else if ([currentElement.name isEqualToString:@"dark"]) {
            
        }
    }
    
}

- (void) addElement: (NSString *) elementType {
    NSLog(@"added %@ element", elementType);
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"finger lifted");
    
    if ([currentElement.name isEqualToString:@"fire"]) {
        NSLog(@"in fire method for delete");
        
        dragFire.particleBirthRate = 0;
        dragFire2.particleBirthRate = 0;
        
        SKAction *remF = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{[dragFire removeFromParent];
        }] ]];
        SKAction *remF2 = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{[dragFire2 removeFromParent];
        }] ]];
        
        [self runAction:remF];
        [self runAction:remF2];
        
    } else if ([currentElement.name isEqualToString:@"water"]) {
        
    } else if ([currentElement.name isEqualToString:@"light"]) {
        
    } else if ([currentElement.name isEqualToString:@"nature"]) {
        
    } else if ([currentElement.name isEqualToString:@"dark"]) {
        
    }
    
    currentElement = nil;
}



@end
