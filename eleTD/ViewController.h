//
//  ViewController.h
//  eleTD
//

//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController {
    SKView *mapSKView;
    SKView *toolbarSKView;
    SKView *elementPickerSKView;
    
    UIToolbar *elementPickerToolbar;
    UIView *toolbarUIView;
    
    SKScene *mapScene;
    SKScene *toolbarScene;
    SKScene *elementPickerScene;
    
    float deviceHeight;
    float deviceWidth;
}

- (void) openPicker;

@end
