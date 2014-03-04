//
//  ElementPicker.h
//  eleTD
//
//  Created by Jan-Dawid Roodt on 4/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class ViewController;

@interface ElementPicker : SKView {
    
}

@property ViewController *viewController;

- (id) initWithFrame:(CGRect)frame andViewController: (ViewController *) vc;
- (void) setCode: (NSString *)newCode;
- (void) updateTowerLabel;

@end
