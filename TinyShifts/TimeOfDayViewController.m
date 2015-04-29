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
#import "Schedule_Rec.h"
#import "RDB_Schedule.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"

@interface TimeOfDayViewController ()

@end

@implementation TimeOfDayViewController

@synthesize screenInstance;
@synthesize switchMorning;
@synthesize switchNoon;
@synthesize switchAfternoon;
@synthesize switchEvening;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the switches
    switchMorning.on = ([GlobalData sharedManager].timeOfDayAvailMorning > 0 ? YES : NO);
    switchNoon.on = ([GlobalData sharedManager].timeOfDayAvailNoon > 0 ? YES : NO);
    switchAfternoon.on = ([GlobalData sharedManager].timeOfDayAvailAfternoon > 0 ? YES : NO);
    switchEvening.on = ([GlobalData sharedManager].timeOfDayAvailEvening > 0 ? YES : NO);
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Time of Day";
    
    
    if (screenInstance != 2)
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
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
   
}


-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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


//- (IBAction)buttonPressedAnytime:(CGradientButton *)sender {
//    [GlobalData sharedManager].timeOfDay = TOD_ANYTIME; // save result
//    
//    if (screenInstance == 1)
//    {
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
//        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
//        vc.navigationItem.hidesBackButton = NO;
//        [[self navigationController] pushViewController:vc animated:YES];
//    }
//}
//
//- (IBAction)buttonPressedMorning:(CGradientButton *)sender {
//    [GlobalData sharedManager].timeOfDay = TOD_MORNING; // save result
//    
//    if (screenInstance == 1)
//    {
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
//        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
//        vc.navigationItem.hidesBackButton = NO;
//        [[self navigationController] pushViewController:vc animated:YES];
//    }
//}
//
//- (IBAction)buttonPressedNoon:(CGradientButton *)sender {
//    [GlobalData sharedManager].timeOfDay = TOD_NOON; // save result
//    
//    if (screenInstance == 1)
//    {
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
//        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
//        vc.navigationItem.hidesBackButton = NO;
//        [[self navigationController] pushViewController:vc animated:YES];
//    }
//}
//
//- (IBAction)buttonPressedAfternoon:(CGradientButton *)sender {
//    [GlobalData sharedManager].timeOfDay = TOD_AFTERNOON; // save result
//    
//    if (screenInstance == 1)
//    {
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
//        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
//        vc.navigationItem.hidesBackButton = NO;
//        [[self navigationController] pushViewController:vc animated:YES];
//    }
//}
//
//- (IBAction)buttonPressedEvening:(CGradientButton *)sender {
//    [GlobalData sharedManager].timeOfDay = TOD_EVENING; // save result
//    
//    if (screenInstance == 1)
//    {
//        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
//        SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
//        vc.navigationItem.hidesBackButton = NO;
//        [[self navigationController] pushViewController:vc animated:YES];
//    }
//}

-(void) sendSchedule
{
    // Record part of the database record for Schedule.
    
    Schedule_Rec* rec2 = [Schedule_Rec sharedManager];
    
    rec2.idRecord++; // increment the record id
    
    rec2.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
    // Get the current date and time and save these in the InfoReadingActivity_Rec object.
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    
    //date formatter with just date and no time
    dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    //date formatter with no date and just time
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
    
    rec2.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec2.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    rec2.weeklyFrequency = [GlobalData sharedManager].frequency;
    
    rec2.availableMorning = [GlobalData sharedManager].timeOfDayAvailMorning;
    rec2.availableNoon = [GlobalData sharedManager].timeOfDayAvailNoon;
    rec2.availableAfternoon = [GlobalData sharedManager].timeOfDayAvailAfternoon;
    rec2.availableEvening = [GlobalData sharedManager].timeOfDayAvailEvening;
    
    
    
    
    // Send the schedule to the remote database.
    
    Responder* responder2 = [Responder responder:self
                              selResponseHandler:@selector(responseHandlerSendSchedule:)
                                 selErrorHandler:@selector(errorHandler:)];
    
    RDB_Schedule* record2 = [[RDB_Schedule alloc] init];
    
    id<IDataStore> dataStore2 = [backendless.persistenceService of:[RDB_Schedule class]];
    
    [dataStore2 save:record2 responder:responder2];
    
    
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendSchedule:(id)response
{
    NSLog(@"Response Handler for send Schedule: Response = %@", response);
    
    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------



- (IBAction)switchChangedMorning:(UISwitch *)sender {
    [GlobalData sharedManager].timeOfDayAvailMorning = (sender.isOn ? 1 : 0); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
    if (screenInstance == 2)
    {
        [self sendSchedule];
    }
}

- (IBAction)switchChangedNoon:(UISwitch *)sender {
    [GlobalData sharedManager].timeOfDayAvailNoon = (sender.isOn ? 1 : 0); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
    if (screenInstance == 2)
    {
        [self sendSchedule];
    }
}

- (IBAction)switchChangedAfternoon:(UISwitch *)sender {
    [GlobalData sharedManager].timeOfDayAvailAfternoon = (sender.isOn ? 1 : 0); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
    if (screenInstance == 2)
    {
        [self sendSchedule];
    }
}

- (IBAction)switchChangedEvening:(UISwitch *)sender {
    [GlobalData sharedManager].timeOfDayAvailEvening = (sender.isOn ? 1 : 0); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
    if (screenInstance == 2)
    {
        [self sendSchedule];
    }
}












-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}




















@end
