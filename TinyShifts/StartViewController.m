//
//  StartViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "ActivationViewController.h"
#import "InfoListViewController.h"
#import "MoodMeterViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Establish the navigation controller for this line of screens.
    ((AppDelegate*)[UIApplication sharedApplication].delegate).navigationControllerMain = self.navigationController;
    
    
    // Test for activation.
    BOOL bActivated = NO;   // test value
    
    if (!bActivated)    // Has user activated app?
    {
        // User has not activated app.
        
        // Disable the tab bar items
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        // Create an instance of the activation view controller.
        ActivationViewController* vc = [[ActivationViewController alloc] initWithNibName:@"ActivationViewController" bundle:nil];
        
        // Send a pointer to the current navigation controller to the activation view controller so that we can get back to this controller after the activation work is done.
        [vc setActiveNavigationController:self.navigationController];
        
        // Send a pointer to the tab bar controller to the activation view controller, which will enable the tab bar if the app is properly activated.
        [vc setActiveTabBarController:self.tabBarController];
        
        // Display the activation view controller.
        [self.navigationController pushViewController:vc animated:NO];
    }
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

- (IBAction)startButtonPressed:(CGradientButton *)sender {
    // The start button has been pressed.
    
    
    
    BOOL bInitialPass = NO;    // TODO (001): Add a decision whether to go to this screen or to the MoodMeter screen.
    
    if (bInitialPass)
    {
        // This is the initial pass, so go to the InfoList screen.
        
        // Attempt to use storyboard to instantiate InfoListViewController.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"InfoList" bundle:nil];
        InfoListViewController* vc = [sb instantiateInitialViewController];
        
        // Send a pointer to the current navigation controller to the activation view controller so that we can get back to this controller after the activation work is done.
        [vc setActiveNavigationController:self.navigationController];
        
        
        // Tell the destination view controller, the mode under which it is being created.
        [vc setScreenMode:1];   // 1 signifies being created in the baseline survey (2 corresponds to coming from the tab bar).
        
        // Display the new view controller.
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        // This is not the initial pass, so go to the MoodMeter screen.
        
        // Attempt to use storyboard to instantiate MoodMeterViewController.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MoodMeterViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MoodMeterViewController"];
        
        // Display the new view controller.
        [self.navigationController pushViewController:vc animated:YES];
   }
    
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
