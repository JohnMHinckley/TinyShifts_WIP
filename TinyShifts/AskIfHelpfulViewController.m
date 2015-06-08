//
//  AskIfHelpfulViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AskIfHelpfulViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "AskWatchAgainViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"

@interface AskIfHelpfulViewController ()

@end

@implementation AskIfHelpfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
//    // Adjust the navigation item
//    // Right button
//    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
//    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
//    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
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


- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AskWatchAgainViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWatchAgainViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}


-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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



- (IBAction)buttonPressedYes:(CGradientButton *)sender {
    [GlobalData sharedManager].videoWasHelpful = VIDEO_WAS_HELPFUL_YES; // save result
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AskWatchAgainViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWatchAgainViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedNo:(CGradientButton *)sender {
    [GlobalData sharedManager].videoWasHelpful = VIDEO_WAS_HELPFUL_NO; // save result
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AskWatchAgainViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWatchAgainViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedNotSure:(CGradientButton *)sender {
    [GlobalData sharedManager].videoWasHelpful = VIDEO_WAS_HELPFUL_DONTKNOW; // save result
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AskWatchAgainViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWatchAgainViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
}











@end
