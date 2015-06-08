//
//  CalendarViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "CalendarViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "SendBaselineViewController.h"
#import "CDatabaseInterface.h"
#import "GlobalData.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize screenInstance;
@synthesize responseAlert;
@synthesize labelNextEvent;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Calendar";
    
    
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
    
//    if (screenInstance == 2)
//    {
//        Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
//        [GlobalData sharedManager].bUseGoogleCal = rec.bUseGoogleCalendar;
//    }
//    
//    self.switchUseGoogleCal.on = [GlobalData sharedManager].bUseGoogleCal;
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



- (IBAction)switchChangedUseGoogleCal:(UISwitch *)sender {
    // Use Google calendar switch changed state.
    // Record its current state.
    
    if (screenInstance == 2)
    {
        bDataChanged_Mode2 = YES;    // Set data change flag
    }
    

    
    //-------------------------------------------------
    //TODO: implement Google calendar use
    if (self.switchUseGoogleCal.isOn)   // temporary measure to turn it off
    {
        self.switchUseGoogleCal.on = NO;
    }
    //-------------------------------------------------
    
    [GlobalData sharedManager].bUseGoogleCal = self.switchUseGoogleCal.isOn;
}

-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}









- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     08-Jun-2015	J. M. Hinckley	Changed next screen from FrequencyViewController to SendBaselineViewController.
     
     */
    
    //UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    //FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SendBaseline" bundle:nil];
    SendBaselineViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendBaselineViewController"];
    vc.navigationItem.hidesBackButton = NO;
    //[vc setScreenInstance:screenInstance];
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
        [GlobalData sharedManager].bUseGoogleCal = rec.bUseGoogleCalendar;
    }
    
    self.switchUseGoogleCal.on = [GlobalData sharedManager].bUseGoogleCal;

    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    
    
    
    // Display the date/time of the next scheduled automatic reminder.
    [self displayNextReminderTime];
    
    
}

-(void) displayNextReminderTime
{
    // Display the date/time of the next scheduled automatic reminder.
    // Are there already any queued local notifications?
    NSArray* arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];    // Get the array of scheduled local notifications
    
    // Are there any?
    if ([arrNotifications count] > 0)
    {
        // YES:
        
        // Get the queued event
        UILocalNotification* queuedNotification = [arrNotifications objectAtIndex:0];
        
        NSDate* fD = queuedNotification.fireDate;    // for examining the firing date of the notification
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd 'at' HH:mm"];
        
        int numDone = [[CDatabaseInterface sharedManager] getNumberDoneEvents];
        int numTotal = [[CDatabaseInterface sharedManager] getTotalNumberEvents];
        
        labelNextEvent.text = [NSString stringWithFormat:@"Next scheduled reminder (%d/%d): %@", numDone+1, numTotal, [formatter stringFromDate:fD]];
    }
    else
    {
        labelNextEvent.text = @"No reminders scheduled";
    }
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
                              message:@"Do you want to save or discard your changes on the Google Calendar screen?"
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
