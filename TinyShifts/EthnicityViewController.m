//
//  EthnicityViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "EthnicityViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
//#import "CalendarViewController.h"
#import "FrequencyViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "CDatabaseInterface.h"

@interface EthnicityViewController ()

@end

@implementation EthnicityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Ethnicity";
    
    
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

    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.  
                                    CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from baseline survey.
    [[self navigationController] pushViewController:vc animated:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}


-(void) viewWillAppear:(BOOL)animated
{
//    // Control whether the user can interact with the tab bar buttons, based on whether the
//    // baseline survey has been completed yet.
//    // Determine whether baseline survey has been done yet.  If it has, set State = 1, otherwise, set State = 0.
//    
//    if ([[CDatabaseInterface sharedManager] getBaselineSurveyStatus] == 1)
//    {
//        // Baseline survey has been done, so enable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//    }
//    else
//    {
//        // Baseline survey has not been done, so disable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = NO;
//    }
    
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

- (IBAction)buttonPressedAsian:(CGradientButton *)sender {
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.
     CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    [GlobalData sharedManager].ethnicity = ETHNICITY_ASIAN ; // save result
    NSLog(@"Ethnicity value saved: %d", [GlobalData sharedManager].ethnicity);
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from the main storyboard

    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedBlack:(CGradientButton *)sender {
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.
     CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    [GlobalData sharedManager].ethnicity = ETHNICITY_BLACK ; // save result
    NSLog(@"Ethnicity value saved: %d", [GlobalData sharedManager].ethnicity);
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from the main storyboard
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedHispanic:(CGradientButton *)sender {
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.
     CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    [GlobalData sharedManager].ethnicity = ETHNICITY_HISPANIC ; // save result
    NSLog(@"Ethnicity value saved: %d", [GlobalData sharedManager].ethnicity);
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from the main storyboard
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedWhite:(CGradientButton *)sender {
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.
     CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    [GlobalData sharedManager].ethnicity = ETHNICITY_WHITE ; // save result
    NSLog(@"Ethnicity value saved: %d", [GlobalData sharedManager].ethnicity);
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from the main storyboard
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedOther:(CGradientButton *)sender {
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from CalendarViewController to FrequencyViewController.
     CalendarViewController will be moved to the end of the Schedule storyboard, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    [GlobalData sharedManager].ethnicity = ETHNICITY_OTHER ; // save result
    NSLog(@"Ethnicity value saved: %d", [GlobalData sharedManager].ethnicity);
    
    // Go to next screen
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    //CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:1];   // signifies that this is coming from the main storyboard
    
    [[self navigationController] pushViewController:vc animated:YES];
}










@end
