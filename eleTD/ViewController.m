//
//  ViewController.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 10/02/14.
//  Copyright (c) 2014 JD. All rights reserved..
//

#import "ViewController.h"
//#import "MapScene.h"
#import "ToolbarScene.h"
#import "ElementPickerScene.h"
#import "Map.h"
#import "Toolbar.h"
#import "ElementPicker.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@implementation ViewController

@synthesize pickerButton, pickerBackButton, pickerNextButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    deviceHeight = self.view.bounds.size.height;
    deviceWidth = self.view.bounds.size.width;
    
    currentCode = @"INCOMPLETE";
    
    // Configure the SKViews
    if (IS_IPHONE_4) {
        /*mapSKView = [[Map alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];*/
        mapSKView = [[Map alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width) andViewController:self];
        toolbarSKView = [[Toolbar alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height, self.view.bounds.size.width,
                                                                self.view.bounds.size.height - self.view.bounds.size.width) andViewController:self];
        
         elementPickerSKView = [[ElementPicker alloc]initWithFrame: mapSKView.frame andViewController:self];
    }
    
    else if (IS_IPHONE_5) {
        mapSKView = [[Map alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 568-160) andViewController:self];
        toolbarSKView = [[Toolbar alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height,
                                                                self.view.bounds.size.width, 160)andViewController:self];
        elementPickerSKView = [[ElementPicker alloc]initWithFrame: mapSKView.frame andViewController:self];
    }
    
    else /* IS_IPAD */ {
        mapSKView = [[Map alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)andViewController:self];
        toolbarSKView = [[Toolbar alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height, self.view.bounds.size.width,
                                                                self.view.bounds.size.height - self.view.bounds.size.width) andViewController:self];
        elementPickerSKView = [[ElementPicker alloc]initWithFrame: CGRectMake(
                                                                       mapSKView.bounds.size.width/15,
                                                                       mapSKView.bounds.size.height/15,
                                                                       mapSKView.bounds.size.width - (2* mapSKView.bounds.size.width/15),
                                                                       mapSKView.bounds.size.height - mapSKView.bounds.size.height/13) andViewController:self];
        elementPickerSKView.layer.cornerRadius = 25;
        elementPickerSKView.layer.masksToBounds = YES;
    }

    
    // Create and configure the scenes.
    mapScene = [MapScene sceneWithSize: mapSKView.bounds.size];
    mapScene.scaleMode = SKSceneScaleModeAspectFill;
    [mapSKView presentScene:mapScene];
    
    toolbarScene = [ToolbarScene sceneWithSize:toolbarSKView.bounds.size];
    toolbarScene.scaleMode = SKSceneScaleModeAspectFill;
    [toolbarSKView presentScene: toolbarScene];
    
    elementPickerScene = [ElementPickerScene sceneWithSize:elementPickerSKView.bounds.size];
    //[elementPickerSKView presentScene:elementPickerScene];
    
    mapSKView.showsFPS = YES;
    mapSKView.showsNodeCount = YES;
    elementPickerSKView.showsFPS = true;
    elementPickerSKView.showsNodeCount = true;
    
    
    // adding views
    [self.view addSubview:mapSKView];
    [self.view addSubview:toolbarSKView];
    [self.view addSubview:elementPickerSKView];
    elementPickerSKView.hidden = true;
    
    
    // adding buttons, icons and smaller objects
    towerName = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 400, 50)];
    towerName.font = [UIFont fontWithName:@"Verdana-Bold" size:19];
    [toolbarSKView addSubview:towerName];
    
    pickerButton = [[UIButton alloc]init];
    pickerNextButton = [[UIButton alloc]init];
    pickerBackButton = [[UIButton alloc]init];
    pickerButton.hidden = true;
    pickerBackButton.hidden = true;
    pickerNextButton.hidden = true;
    
    float buttonSize = (deviceHeight-deviceWidth) * 0.7;
    
    if (IS_IPHONE_4) {
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-20, (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
        pickerNextButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-100, (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
        pickerBackButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)+100, (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
    }
    else if (IS_IPHONE_5) {
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-20, (deviceHeight-deviceWidth) * 0.15 -15, buttonSize-55, buttonSize-55);
        pickerNextButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-100, (deviceHeight-deviceWidth) * 0.15 -15, buttonSize-55, buttonSize-55);
        pickerBackButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)+100, (deviceHeight-deviceWidth) * 0.15 -15, buttonSize-55, buttonSize-55);
    }
    else /* IS_IPAD */ {
        
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15), (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
        pickerNextButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-50, (deviceHeight-deviceWidth) * 0.15, buttonSize/1.5, buttonSize/1.5);
        pickerBackButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)+100, (deviceHeight-deviceWidth) * 0.15, buttonSize/1.5, buttonSize/1.5);
    }
    
    
    [pickerButton setBackgroundImage:[UIImage imageNamed:@"element button.png"] forState:UIControlStateNormal];
    [pickerNextButton setBackgroundImage:[UIImage imageNamed:@"ButtonNext.png"] forState:UIControlStateNormal];
    [pickerBackButton setBackgroundImage:[UIImage imageNamed:@"buttonBack.png"] forState:UIControlStateNormal];
    [toolbarSKView addSubview:pickerButton];
    [toolbarSKView addSubview:pickerBackButton];
    [toolbarSKView addSubview:pickerNextButton];
    [pickerNextButton addTarget:self action:@selector(buildTower) forControlEvents:UIControlEventTouchDown];
    [pickerBackButton addTarget:self action:@selector(cancleTower) forControlEvents:UIControlEventTouchDown];
    [pickerButton addTarget:self action:@selector(openPicker) forControlEvents:UIControlEventTouchDown];
    
    
}

- (void) openPicker {
    NSLog(@"entering element picker");
    elementPickerSKView.hidden = !elementPickerSKView.hidden;
    [elementPickerScene clearScreen];
    pickerButton.hidden = !pickerButton.hidden;
    pickerNextButton.hidden = !pickerNextButton.hidden;
    pickerBackButton.hidden = !pickerBackButton.hidden;
    pickerNextButton.enabled = NO;
    towerName.text = @"";
    
    if (elementPickerSKView.hidden) {
        toolbarScene = [ToolbarScene sceneWithSize:toolbarSKView.bounds.size];
        toolbarScene.scaleMode = SKSceneScaleModeAspectFill;
        [elementPickerSKView presentScene:toolbarScene];
    } else {
        [elementPickerSKView presentScene:elementPickerScene];
    }
}

- (void) setButtonHidden: (BOOL) status {
    pickerButton.hidden = status;
    
}

- (void)setCurrentCode:(NSString *)newCode {
    currentCode = newCode;
    NSLog(@"view controller says current code is %@", currentCode);
    pickerNextButton.enabled = YES;
}

- (NSString *) getCurrentCode {
    return currentCode;
}

/*- (void) setButtonModeConfirmOrDeny {
    [self setButtonHidden:true];
    
}*/

- (void) buildTower {
    [self openPicker];
    [mapScene buildTowerOfType:currentCode];
    currentCode = @"";
}
- (void) cancleTower {
    [self openPicker];
    currentCode = @"";
    towerName.text = @"";
}




- (NSString *) getCurrentName {
    
    // getting tower information
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"tower-info" ofType:@"plist"];
    NSArray * towernames = [NSArray arrayWithContentsOfFile:plistPath];
    
    for(NSDictionary * tower in towernames)
    {
        if ([[tower objectForKey:@"code"] isEqualToString:currentCode]) {
            return [tower objectForKey:@"name"];
        }
    }
    
    return [NSString stringWithFormat:@"INVALID CODE: %@", currentCode];
}

- (void) updateTowerLabel {
    towerName.text = [NSString stringWithFormat:@"%@ Tower", [self getCurrentName]];
}



// ROTATION CODE NEEDED HERE
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"rotation detected");
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
