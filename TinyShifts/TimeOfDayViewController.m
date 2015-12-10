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
#import "CalendarViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "Schedule_Rec.h"
#import "RDB_Schedule.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"

@interface TimeOfDayViewController ()

@end

@implementation TimeOfDayViewController

@synthesize screenInstance;
@synthesize switchVEarly;
@synthesize switchNight;
@synthesize switchMorning;
@synthesize switchNoon;
@synthesize switchAfternoon;
@synthesize switchEvening;
@synthesize responseAlert;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Time of Day";
    
    
//    if (screenInstance != 2)
 //   {
        // Right button
        CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
        [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
//    }
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
    // Next button is pressed.
    
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from SendBaselineViewController to CalendarViewController, in screen instance == 1 (baseline survey).
     
     */
    
    // TODO:
    // if all time intervals are selected for NOT receiving notifications, then
    // set up a notification to remind the user to change this, at 6 p.m. on Friday.
    if ([GlobalData sharedManager].timeOfDayAvailMorning == 0
        && [GlobalData sharedManager].timeOfDayAvailNoon == 0
        && [GlobalData sharedManager].timeOfDayAvailAfternoon == 0
        && [GlobalData sharedManager].timeOfDayAvailVEarly == 0
        && [GlobalData sharedManager].timeOfDayAvailNight == 0
        && [GlobalData sharedManager].timeOfDayAvailEvening == 0)
    {
        NSLog(@"All intervals are omitted from reminders");
#pragma mark ******* TODO item
        // If parameters are changed on this screen, set a flag to form a local notification if and when the changes are saved.
        // else, if parameters are not changed, and if a local notification is not already registered, form one now.
        
    }
        
    
    // Go to next screen.
    if (screenInstance == 1)
    {
        // doing the baseline survey: go to SendBaselineViewController.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else
    {
        // operating from the tab bar: go to CalendarViewController
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
        CalendarViewController* vc = [sb instantiateViewControllerWithIdentifier:@"CalendarViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:screenInstance];  // tell next screen where on storyboard we are coming from
        [[self navigationController] pushViewController:vc animated:YES];
    }
   
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
        [GlobalData sharedManager].timeOfDayAvailMorning = (int)rec.availableMorning;
        [GlobalData sharedManager].timeOfDayAvailNoon = (int)rec.availableNoon;
        [GlobalData sharedManager].timeOfDayAvailAfternoon = (int)rec.availableAfternoon;
        [GlobalData sharedManager].timeOfDayAvailVEarly = (int)rec.availableVEarly;
        [GlobalData sharedManager].timeOfDayAvailNight = (int)rec.availableNight;
        [GlobalData sharedManager].timeOfDayAvailEvening = (int)rec.availableEvening;
    }
    
    
    // Set the switches
    switchMorning.on = ([GlobalData sharedManager].timeOfDayAvailMorning > 0 ? NO : YES);
    switchNoon.on = ([GlobalData sharedManager].timeOfDayAvailNoon > 0 ? NO : YES);
    switchAfternoon.on = ([GlobalData sharedManager].timeOfDayAvailAfternoon > 0 ? NO : YES);
    switchVEarly.on = ([GlobalData sharedManager].timeOfDayAvailVEarly > 0 ? NO : YES);
    switchNight.on = ([GlobalData sharedManager].timeOfDayAvailNight > 0 ? NO : YES);
    switchEvening.on = ([GlobalData sharedManager].timeOfDayAvailEvening > 0 ? NO : YES);
    
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
                              message:@"Do you want to save or discard your changes on the Time of Day screen?"
                              delegate:[GlobalData sharedManager] // delegate:self
                              cancelButtonTitle:@"Discard" otherButtonTitles:@"Save",nil];
        
        self.responseAlert = alert;     // Set the responseAlert so that the alert handler will know which alert is initiating it.
        
        [alert show];
    }
}


-(void) viewDidDisappear:(BOOL)animated
{
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





- (IBAction)switchChangedNight:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailNight = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
    
}

- (IBAction)switchChangedVEarly:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailVEarly = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
    
}

- (IBAction)switchChangedMorning:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailMorning = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
}

- (IBAction)switchChangedNoon:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailNoon = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
}

- (IBAction)switchChangedAfternoon:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailAfternoon = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
}

- (IBAction)switchChangedEvening:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailEvening = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: VEarly, Morning, Noon, Afternoon, Evening, Night = %d, %d, %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailVEarly,
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening,
          [GlobalData sharedManager].timeOfDayAvailNight);
}












-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}











@end
