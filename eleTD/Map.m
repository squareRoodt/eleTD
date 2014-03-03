//
//  Map.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 4/03/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "Map.h"
#import "ViewController.h"

@implementation Map
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

- (void) setEleButtonHidden: (BOOL) status {
    [viewController setButtonHidden:status];
}

- (ViewController *) getViewController {
    return viewController;
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
