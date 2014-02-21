//
//  ViewController.h
//  eleTD
//

//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController {
    // idea: maybe the toolbar doesnt need to be a skview. that would save a lot of processing? but no sprite. which is orite??
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
