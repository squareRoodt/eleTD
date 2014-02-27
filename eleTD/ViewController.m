//
//  ViewController.m
//  eleTD
//
//  Created by Jan-Dawid Roodt on 10/02/14.
//  Copyright (c) 2014 JD. All rights reserved..
//

#import "ViewController.h"
#import "MapScene.h"
#import "ToolbarScene.h"
#import "ElementPickerScene.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    deviceHeight = self.view.bounds.size.height;
    deviceWidth = self.view.bounds.size.width;
    
    
    // Configure the SKViews
    if (IS_IPHONE_4) {
        mapSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
        toolbarSKView = [[SKView alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height, self.view.bounds.size.width,
                                                                self.view.bounds.size.height - self.view.bounds.size.width)];
         elementPickerSKView = [[SKView alloc]initWithFrame: mapSKView.frame];
    }
    
    else if (IS_IPHONE_5) {
        mapSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 568-160)];
        toolbarSKView = [[SKView alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height,
                                                                self.view.bounds.size.width, 160)];
        elementPickerSKView = [[SKView alloc]initWithFrame: mapSKView.frame];
    }
    
    else /* IS_IPAD */ {
        mapSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
        toolbarSKView = [[SKView alloc]initWithFrame:CGRectMake(0, mapSKView.bounds.size.height, self.view.bounds.size.width,
                                                                self.view.bounds.size.height - self.view.bounds.size.width)];
        elementPickerSKView = [[SKView alloc]initWithFrame: CGRectMake(
                                                                       mapSKView.bounds.size.width/15,
                                                                       mapSKView.bounds.size.height/15,
                                                                       mapSKView.bounds.size.width - (2* mapSKView.bounds.size.width/15),
                                                                       mapSKView.bounds.size.height - mapSKView.bounds.size.height/13)];
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
    [elementPickerSKView presentScene:elementPickerScene];
    
    
    // adding views
    [self.view addSubview:mapSKView];
    [self.view addSubview:toolbarSKView];
    [self.view addSubview:elementPickerSKView];
    elementPickerSKView.hidden = true;
    
    
    // adding buttons, icons and smaller objects
    UIButton *pickerButton = [[UIButton alloc]init];
    float buttonSize = (deviceHeight-deviceWidth) * 0.7;
    
    if (IS_IPHONE_4) {
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-20, (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
    }
    else if (IS_IPHONE_5) {
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15)-20, (deviceHeight-deviceWidth) * 0.15 -15, buttonSize-55, buttonSize-55);
    }
    else /* IS_IPAD */ {
        
        pickerButton.frame = CGRectMake(deviceWidth/3 + (deviceWidth/3 *0.15), (deviceHeight-deviceWidth) * 0.15, buttonSize, buttonSize);
    }
    
    [toolbarSKView addSubview:pickerButton];
    [pickerButton setBackgroundImage:[UIImage imageNamed:@"element button.png"] forState:UIControlStateNormal];
    [toolbarSKView addSubview:pickerButton];
    [pickerButton addTarget:self action:@selector(openPicker) forControlEvents:UIControlEventTouchDown];
    
}

- (void) openPicker {
    NSLog(@"entering element picker");
    elementPickerSKView.hidden = !elementPickerSKView.hidden;
    [elementPickerScene clearScreen];
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
