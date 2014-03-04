//
//  ElementPicker.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 4/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "ElementPicker.h"
#import "ViewController.h"

@implementation ElementPicker

@synthesize viewController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andViewController: (ViewController *) vc {
    self = [super initWithFrame:frame];
    if (self) {
        viewController = vc;
    }
    return self;
}

- (void) setCode: (NSString *)newCode {
    [viewController setCurrentCode:newCode];
    NSLog(@"Element picker says code is %@", newCode);
}

- (void) updateTowerLabel {
    [viewController updateTowerLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
