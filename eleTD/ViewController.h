//
//  ViewController.h
//  eleTD
//

//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "MapScene.h"
#import "ToolbarScene.h"
#import "ElementPickerScene.h"
//#import "Map.h"

@class Map;
@class MapScene;
@class Toolbar;
@class ElementPicker;

@interface ViewController : UIViewController {
    // idea: maybe the toolbar doesnt need to be a skview. that would save a lot of processing? but no sprite. which is orite??
    Map *mapSKView;
    Toolbar *toolbarSKView;
    ElementPicker *elementPickerSKView;
    
    UIToolbar *elementPickerToolbar;
    Toolbar *toolbarUIView;
    
    MapScene *mapScene;
    ToolbarScene *toolbarScene;
    ElementPickerScene *elementPickerScene;
    
    float deviceHeight;
    float deviceWidth;
    
    NSString *currentCode;
    UILabel *towerName;
    
}

@property UIButton *pickerButton;
@property UIButton *pickerNextButton;
@property UIButton *pickerBackButton;

- (void) openPicker;
- (void) setButtonHidden: (BOOL) status;
- (void) buildTower;
- (void) cancleTower;
- (void) updateTowerLabel;
- (void) setCurrentCode:(NSString *)currentCode;
- (NSString *) getCurrentCode;
- (NSString *) getCurrentName;

@end
