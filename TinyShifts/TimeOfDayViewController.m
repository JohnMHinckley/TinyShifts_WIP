//
//  TimeOfDayViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "TimeOfDayViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "SendBaselineViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"

@interface TimeOfDayViewController ()

@end

@implementation TimeOfDayViewController
@synthesize screenInstance;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Time of Day";
    
    
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
   
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
    SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
    [[self navigationController] pushViewController:vc animated:YES];
   
}


-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    if (screenInstance == 1)
    {
        self.navigationItem.hidesBackButton = NO;   // show back button
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


- (IBAction)buttonPressedAnytime:(CGradientButton *)sender {
    [GlobalData sharedManager].timeOfDay = TOD_ANYTIME; // save result
    
    if (screenInstance == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (IBAction)buttonPressedMorning:(CGradientButton *)sender {
    [GlobalData sharedManager].timeOfDay = TOD_MORNING; // save result
    
    if (screenInstance == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (IBAction)buttonPressedNoon:(CGradientButton *)sender {
    [GlobalData sharedManager].timeOfDay = TOD_NOON; // save result
    
    if (screenInstance == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (IBAction)buttonPressedAfternoon:(CGradientButton *)sender {
    [GlobalData sharedManager].timeOfDay = TOD_AFTERNOON; // save result
    
    if (screenInstance == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (IBAction)buttonPressedEvening:(CGradientButton *)sender {
    [GlobalData sharedManager].timeOfDay = TOD_EVENING; // save result
    
    if (screenInstance == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}












-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}




















@end
