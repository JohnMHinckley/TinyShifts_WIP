//
//  ActivationViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ActivationViewController.h"
#import "AppDelegate.h"

@interface ActivationViewController ()

@end

@implementation ActivationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)OKButtonPressed:(CGradientButton *)sender {
    // The OK button on the activation screen has been pressed.
    
    // Check if the activation code is valid.
    BOOL bCodeIsValid = YES;
    
    if (bCodeIsValid)   // Check whether code is valid.
    {
        // Enable the tab bar items
        activeTabBarController.tabBar.userInteractionEnabled = YES;
        
       // Code is valid, so return to the start screen.
        [activeNavigationController popViewControllerAnimated:NO];
    }
    else
    {
        // Code is not valid.  Inform user, erase entered code and stay on this screen.
    }
}

-(void) setActiveNavigationController:(UINavigationController*) nc
{
    // Set the active navigation controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active navigation controller is inherited from the calling view controller and is used to get back
    // to the calling view controller when the work in this view controller is done.
    
    activeNavigationController = nc;
}

-(void) setActiveTabBarController:(UITabBarController*) tc
{
    // Set the tab bar controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active tab bar controller is inherited from the calling view controller and is accessed
    // in order to control its being enabled or not.
    activeTabBarController = tc;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}

-(void) portraitLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = true;
}

#pragma mark - interface posiiton

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}

@end
