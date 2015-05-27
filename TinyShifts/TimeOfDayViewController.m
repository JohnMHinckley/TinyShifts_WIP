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
@synthesize responseAlert;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if (screenInstance == 2)
//    {
//        Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
//        [GlobalData sharedManager].timeOfDayAvailMorning = rec.availableMorning;
//        [GlobalData sharedManager].timeOfDayAvailNoon = rec.availableNoon;
//        [GlobalData sharedManager].timeOfDayAvailAfternoon = rec.availableAfternoon;
//        [GlobalData sharedManager].timeOfDayAvailEvening = rec.availableEvening;
//    }
//    
//
//    // Set the switches
//    switchMorning.on = ([GlobalData sharedManager].timeOfDayAvailMorning > 0 ? NO : YES);
//    switchNoon.on = ([GlobalData sharedManager].timeOfDayAvailNoon > 0 ? NO : YES);
//    switchAfternoon.on = ([GlobalData sharedManager].timeOfDayAvailAfternoon > 0 ? NO : YES);
//    switchEvening.on = ([GlobalData sharedManager].timeOfDayAvailEvening > 0 ? NO : YES);
//    
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
    // Next button is pressed.
    
    // TODO:
    // if all time intervals are selected for NOT receiving notifications, then
    // set up a notification to remind the user to change this, at 6 p.m. on Friday.
    if ([GlobalData sharedManager].timeOfDayAvailMorning == 0
        && [GlobalData sharedManager].timeOfDayAvailNoon == 0
        && [GlobalData sharedManager].timeOfDayAvailAfternoon == 0
        && [GlobalData sharedManager].timeOfDayAvailEvening == 0)
    {
        NSLog(@"All intervals are omitted from reminders");
#pragma mark ******* TODO item
        // If parameters are changed on this screen, set a flag to form a local notification if and when the changes are saved.
        // else, if parameters are not changed, and if a local notification is not already registered, form one now.
        
    }
        
    
    // Go to next screen.
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
    SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
    vc.navigationItem.hidesBackButton = NO;
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
        [GlobalData sharedManager].timeOfDayAvailMorning = (int)rec.availableMorning;
        [GlobalData sharedManager].timeOfDayAvailNoon = (int)rec.availableNoon;
        [GlobalData sharedManager].timeOfDayAvailAfternoon = (int)rec.availableAfternoon;
        [GlobalData sharedManager].timeOfDayAvailEvening = (int)rec.availableEvening;
    }
    
    
    // Set the switches
    switchMorning.on = ([GlobalData sharedManager].timeOfDayAvailMorning > 0 ? NO : YES);
    switchNoon.on = ([GlobalData sharedManager].timeOfDayAvailNoon > 0 ? NO : YES);
    switchAfternoon.on = ([GlobalData sharedManager].timeOfDayAvailAfternoon > 0 ? NO : YES);
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
//    if (screenInstance == 2 && bDataChanged_Mode2)
//    {
//        // Ask user whether to save or discard changes on this screen.
//        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Data Changed"
//                              message:@"Do you want save or discard your changes on the Time of Day screen?"
//                              delegate:self
//                              cancelButtonTitle:@"Discard" otherButtonTitles:@"Save",nil];
//        
//        self.responseAlert = alert;     // Set the responseAlert so that the alert handler will know which alert is initiating it.
//        
//        [alert show];
//    }
}


-(void) viewDidDisappear:(BOOL)animated
{
    if (screenInstance == 2 && bDataChanged_Mode2)
    {
        // Ask user whether to save or discard changes on this screen.
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Data Changed"
                              message:@"Do you want save or discard your changes on the Time of Day screen?"
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

//-(void) sendSchedule
//{
//    // Record part of the database record for Schedule.
//    
//    Schedule_Rec* rec2 = [Schedule_Rec sharedManager];
//    
//    rec2.idRecord++; // increment the record id
//    
//    rec2.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
//    
//    // Get the current date and time and save these in the InfoReadingActivity_Rec object.
//    NSDateFormatter *dateFormatter1;
//    NSDateFormatter *dateFormatter2;
//    
//    //date formatter with just date and no time
//    dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
//    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
//    
//    //date formatter with no date and just time
//    dateFormatter2 = [[NSDateFormatter alloc] init];
//    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
//    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
//    
//    rec2.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
//    rec2.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
//    
//    rec2.weeklyFrequency = [GlobalData sharedManager].frequency;
//    
//    rec2.availableMorning = [GlobalData sharedManager].timeOfDayAvailMorning;
//    rec2.availableNoon = [GlobalData sharedManager].timeOfDayAvailNoon;
//    rec2.availableAfternoon = [GlobalData sharedManager].timeOfDayAvailAfternoon;
//    rec2.availableEvening = [GlobalData sharedManager].timeOfDayAvailEvening;
//    
//    
//    
//    
//    // Send the schedule to the remote database.
//    
//    Responder* responder2 = [Responder responder:self
//                              selResponseHandler:@selector(responseHandlerSendSchedule:)
//                                 selErrorHandler:@selector(errorHandler:)];
//    
//    RDB_Schedule* record2 = [[RDB_Schedule alloc] init];
//    
//    id<IDataStore> dataStore2 = [backendless.persistenceService of:[RDB_Schedule class]];
//    
//    [dataStore2 save:record2 responder:responder2];
//    
//    
//    
//}
//
//
//
////---------------------------------------------------------------------------------------------------------------------------------
//
//
//
//-(id)responseHandlerSendSchedule:(id)response
//{
//    NSLog(@"Response Handler for send Schedule: Response = %@", response);
//    
//    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    
//    return response;
//}
//
//
//
////---------------------------------------------------------------------------------------------------------------------------------



- (IBAction)switchChangedMorning:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailMorning = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
//    if (screenInstance == 2)
//    {
//        [self sendSchedule];
//    }
}

- (IBAction)switchChangedNoon:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailNoon = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
//    if (screenInstance == 2)
//    {
//        [self sendSchedule];
//    }
}

- (IBAction)switchChangedAfternoon:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailAfternoon = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
//    if (screenInstance == 2)
//    {
//        [self sendSchedule];
//    }
}

- (IBAction)switchChangedEvening:(UISwitch *)sender {
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    
    [GlobalData sharedManager].timeOfDayAvailEvening = (sender.isOn ? 0 : 1); // set flag
    NSLog(@"Availability times: Morning, Noon, Afternoon, Evening = %d, %d, %d, %d",
          [GlobalData sharedManager].timeOfDayAvailMorning,
          [GlobalData sharedManager].timeOfDayAvailNoon,
          [GlobalData sharedManager].timeOfDayAvailAfternoon,
          [GlobalData sharedManager].timeOfDayAvailEvening);
    
//    if (screenInstance == 2)
//    {
//        [self sendSchedule];
//    }
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
