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
        currentDrag = [[SKNode alloc]init];
        isRemovingAtom = false;
        canClickElement = true;
        [self addChild:currentDrag];
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
    }
    // (water)
    waterExplosion = [SKAction sequence:@[[SKAction runBlock:^{
        dragWater.particleBirthRate = 4000;
        dragWater.particleSpeedRange = 400;
        dragWater.particleLifetime = 2.0;
    }],
                                         [SKAction waitForDuration:0.05],
                                         [SKAction runBlock:^{
        dragWater.particleBirthRate = 466;
        dragWater.particleSpeedRange = 160;
        dragWater.particleLifetime = 1.4;
    }],
                                         [SKAction waitForDuration:1]
                                         ]];
    
    return self;
}

- (void) spamChecker {
    canClickElement = true;
}

//  TOUCH BEGAN
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
        [self findSelectedNodeInTouch:positionInScene];
      
    
}

- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    //NSLog(@"touch on element picker screen");
    NSLog(@"X: %f,   Y: %f", touchLocation.x, touchLocation.y);
    // assume you are adding atoms until told you are removing
    isRemovingAtom = false;
    [currentDrag removeAllChildren];
    
    if (CGRectContainsPoint(selectableF, touchLocation)) {
        currentElement = eleFire;
        
        // adding fire particles
        dragFire =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire" ofType:@"sks"]];
        dragFire2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire2" ofType:@"sks"]];
        CGPoint fireLocation =CGPointMake(187, 541);
        currentDrag.position = fireLocation;
        //dragFire2.position = fireLocation;
        //dragFire.position = fireLocation;
        dragFire.targetNode = self;
        dragFire2.targetNode = self;
        
        
        [currentDrag addChild:dragFire2];
        [currentDrag addChild:dragFire];
        [self runAction: fireExplosion];
        
    } else if (CGRectContainsPoint(selectableW, touchLocation)) {
        currentElement = eleWater;
        
        // adding water particles
        dragWater =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragWater" ofType:@"sks"]];
        CGPoint waterLocation =CGPointMake(460, 540);
        currentDrag.position = waterLocation;
        dragWater.targetNode = self;
        
        [currentDrag addChild:dragWater];
        [self runAction:waterExplosion];
        
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
        currentElement = eleNull;
    }
    
    NSLog(@"touched %@ element", currentElement.name);
	
}

// TOUCH MOVED
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint endPoint = CGPointMake(330, 381);
    
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
                [self removeFire];
                [self addElement:@"F"];
            }
            
            // dragged out of range
            if (currentDrag.position.y > 650) {
                [self removeFire];
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
                [self removeWater];
                [self addElement:@"W"];
            }
            
            // dragged out of range
            if (currentDrag.position.y > 650) {
                [self removeWater];
            }
            
        } else if ([currentElement.name isEqualToString:@"light"]) {
            
        } else if ([currentElement.name isEqualToString:@"nature"]) {
            
        } else if ([currentElement.name isEqualToString:@"dark"]) {
            
        }
    }
    
}

- (void) addElement: (NSString *) elementType {
    NSLog(@"added %@ element", elementType);
    
}


// TOUCH ENDED
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"finger lifted");
    
    if ([currentElement.name isEqualToString:@"fire"]) {
        [self removeFire];
    } else if ([currentElement.name isEqualToString:@"water"]) {
        [self removeWater];
        
    } else if ([currentElement.name isEqualToString:@"light"]) {
        
    } else if ([currentElement.name isEqualToString:@"nature"]) {
        
    } else if ([currentElement.name isEqualToString:@"dark"]) {
        
    }
    
}

- (void) removeFire {
    currentElement = eleNull;
    dragFire.particleBirthRate = 0;
    dragFire2.particleBirthRate = 0;
    
    SKAction *remF2 = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{[currentDrag removeAllChildren];
    }] ]];
    
    [self runAction:remF2];
}

- (void) removeWater {
    currentElement = eleNull;
    dragWater.particleBirthRate = 0;
    
    SKAction *remW = [SKAction sequence:@[ [SKAction waitForDuration:0.3], [SKAction runBlock:^{ [currentDrag removeAllChildren];
    }] ]];
    
    [self runAction:remW];
}



@end
