//
//  FrequencyViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "FrequencyViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "TimeOfDayViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "Schedule_Rec.h"
#import "RDB_Schedule.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"


@interface FrequencyViewController ()

@end

@implementation FrequencyViewController
@synthesize sliderFrequency;
@synthesize labelSliderValue;
@synthesize screenInstance;
@synthesize responseAlert;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Frequency";
    
    
    //if (screenInstance == 1)
    {
        // Right button
        CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
        [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
//    if (screenInstance == 2)
//    {
//        Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
//        [GlobalData sharedManager].frequency = rec.weeklyFrequency;
//    }
//
//    sliderFrequency.value = [GlobalData sharedManager].frequency;
//    labelSliderValue.text = [NSString stringWithFormat:@"%d", (int) sliderFrequency.value]; // value displayed on the screen
//    
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
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    TimeOfDayViewController* vc = [sb instantiateViewControllerWithIdentifier:@"TimeOfDayViewController"];
    vc.navigationItem.hidesBackButton = NO;
    [vc setScreenInstance:screenInstance];  // tell next screen where on storyboard we are coming from
    [[self navigationController] pushViewController:vc animated:YES];
    
}


-(void) viewWillAppear:(BOOL)animated
{
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = NO;    // Initialize data change flag
    }
    
    
    if (screenInstance == 2)
    {
        Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
        [GlobalData sharedManager].frequency = rec.weeklyFrequency;
    }
    
    sliderFrequency.value = [GlobalData sharedManager].frequency;
    labelSliderValue.text = [NSString stringWithFormat:@"%d", (int) sliderFrequency.value]; // value displayed on the screen
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}





-(void) viewWillDisappear:(BOOL)animated
{
    if (screenInstance == 2 && bDataChanged_Mode2)
    {
        // Ask user whether to save or discard changes on this screen.
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Data Changed"
                              message:@"Do you want save or discard your changes on the Weekly Frequency screen?"
                              delegate:[GlobalData sharedManager] // delegate:self
                              cancelButtonTitle:@"Discard" otherButtonTitles:@"Save",nil];
        
        self.responseAlert = alert;     // Set the responseAlert so that the alert handler will know which alert is initiating it.
        
        [alert show];
    }
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


- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].frequency = sliderFrequency.value;
    labelSliderValue.text = [NSString stringWithFormat:@"%d", (int) sliderFrequency.value]; // value displayed on the screen
    
    if (screenInstance == 2)
    {
//        [self sendSchedule];
    }
    
    NSLog(@"Frequency value = %d", [GlobalData sharedManager].frequency);
}



-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}


//- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    // the user clicked one of the #/Cancel buttons
//    
//    if (actionSheet == responseAlert)
//    {
//        
//        // the user clicked one of the #/Cancel buttons
//        
//        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
//        
//        if ([title isEqualToString:@"Save"])
//        {
//            NSLog(@"Save changes on Calendar screen.");
//        }
//        else if ([title isEqualToString:@"Discard"])
//        {
//            NSLog(@"Discard changes on Calendar screen.");
//        }
//        
//    }
//    
//    
//}


@end
