//
//  MoodMeterViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "MoodMeterViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "UnpleasantMoodListViewController.h"
#import "PleasantMoodListViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"

@interface MoodMeterViewController ()
{
    BOOL bResponseIsPleasant;
}

@end

@implementation MoodMeterViewController
{
    __weak IBOutlet UILabel *theLabel;
}
- (IBAction)nextPressed:(CGradientButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    // Adjust the navigation item
//    // Right button
//    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
//    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
//    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    // initialize the response
    bResponseIsPleasant = NO;
    
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
    
    if (bResponseIsPleasant)
    {
        PleasantMoodListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"PleasantMoodListViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else{
        UnpleasantMoodListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"UnpleasantMoodListViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    // Disable the tab bar items
 //   self.tabBarController.tabBar.userInteractionEnabled = NO;

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


- (IBAction)buttonPressedRed:(UIButton *)sender {
    [GlobalData sharedManager].moodMeterSelection = MOOD_METER_RED; // save result
    bResponseIsPleasant = NO;
    [self doNextScreen];
    
}

- (IBAction)buttonPressedYellow:(UIButton *)sender {
    [GlobalData sharedManager].moodMeterSelection = MOOD_METER_YELLOW; // save result
    bResponseIsPleasant = YES;
    [self doNextScreen];
}

- (IBAction)buttonPressedBlue:(UIButton *)sender {
    [GlobalData sharedManager].moodMeterSelection = MOOD_METER_BLUE; // save result
    bResponseIsPleasant = NO;
    [self doNextScreen];
}

- (IBAction)buttonPressedGreen:(UIButton *)sender {
    [GlobalData sharedManager].moodMeterSelection = MOOD_METER_GREEN; // save result
    bResponseIsPleasant = YES;
    [self doNextScreen];
}

-(void) doNextScreen
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (bResponseIsPleasant)
    {
        PleasantMoodListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"PleasantMoodListViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else{
        UnpleasantMoodListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"UnpleasantMoodListViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    
}
@end
