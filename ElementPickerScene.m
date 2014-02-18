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
        
        selectableF = CGRectMake(97, 492, 224, 181);
        selectableW = CGRectMake(333, 498, 199, 160);
        selectableL = CGRectMake(440, 252, 134, 246);
        selectableN = CGRectMake(198, 187, 237, 112);
        selectableD = CGRectMake(95, 248, 100, 230);
        
        elements = [[NSMutableArray alloc] initWithObjects:eleFire, eleWater, eleLight, eleNature, eleDark, nil];
        CGPoint elePoint = CGPointMake(78, 180);
        float eleScale = 4;
        
        for (SKSpriteNode *element in elements) {
            [element setAnchorPoint:CGPointZero];
            element.position = elePoint;
            element.size = CGSizeMake(element.size.width/eleScale, element.size.height/eleScale);
            [self addChild:element];
        }
        
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self findSelectedNodeInTouch:positionInScene];
}

- (void)findSelectedNodeInTouch:(CGPoint)touchLocation {
    NSLog(@"touch on element picker screen");
    
    if (CGRectContainsPoint(selectableF, touchLocation)) {
        currentElement = eleFire;
        
        // adding fire particles
        dragFire =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire" ofType:@"sks"]];
        dragFire2 =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"dragFire2" ofType:@"sks"]];
        dragFire2.position = touchLocation;
        dragFire.position = touchLocation;
        
        [self addChild:dragFire2];
        [self addChild:dragFire];
        
        [self runAction: [SKAction sequence:@[[SKAction runBlock:^{
            dragFire.particleBirthRate = 1000;
            dragFire2.particleBirthRate = 500;
            dragFire.particleScale = 0.9;
            dragFire2.particleSpeed = 120;}],
                                              [SKAction waitForDuration:0.05],
                                              [SKAction runBlock:^{
            dragFire.particleBirthRate = 292;
            dragFire2.particleBirthRate = 59;
            dragFire.particleScale = 0.5;
            dragFire2.particleSpeed = 79;}],
                                              ]]];
        
    } else if (CGRectContainsPoint(selectableW, touchLocation)) {
        currentElement = eleWater;
        
    } else if (CGRectContainsPoint(selectableL, touchLocation)) {
        currentElement = eleLight;
        
    } else if (CGRectContainsPoint(selectableN, touchLocation)) {
        currentElement = eleNature;
        
    } else if (CGRectContainsPoint(selectableD, touchLocation)) {
        currentElement = eleDark;
        
    } else {
        currentElement = Nil;
    }
    
    NSLog(@"touched %@ element", currentElement.name);
	
}


@end
