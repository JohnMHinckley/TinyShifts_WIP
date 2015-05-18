//
//  SendBaselineViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "SendBaselineViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "PersonalData_Rec.h"
#import "Schedule_Rec.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"
#import "RDB_PersonalData.h"
#import "RDB_Schedule.h"
#import "StartViewController.h"
#import "ScheduleManager.h"

@interface SendBaselineViewController ()

@end

@implementation SendBaselineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonPressed:(CGradientButton *)sender {
    // Submit the baseline survey data and pop the navigation stack to the start screen.
    
    
    
    
    
    
    // Record part of the database record for PersonalData and Schedule.
    
    PersonalData_Rec* rec = [PersonalData_Rec sharedManager];   // a singleton object
//    Schedule_Rec* rec2 = [Schedule_Rec sharedManager];          // a singleton object
    
    
    
    
    // Supply immediate data to the singletons
    
    rec.idRecord++; // increment the record id
//    rec2.idRecord++; // increment the record id
    
    rec.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
//    rec2.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
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
    
    rec.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
//    rec2.dateRecord = [rec.dateRecord copy];
//    rec2.timeRecord = [rec.timeRecord copy];
    
    
    
    
    // Transfer global data to the singletons
    
    rec.gender = [GlobalData sharedManager].gender;
    rec.age = [GlobalData sharedManager].age;
    rec.ethnicity = [GlobalData sharedManager].ethnicity;
    
//    rec2.bUseGoogleCalendar = [GlobalData sharedManager].bUseGoogleCal;
//    
//    rec2.weeklyFrequency = [GlobalData sharedManager].frequency;
//    
//    rec2.availableMorning = [GlobalData sharedManager].timeOfDayAvailMorning;
//    rec2.availableNoon = [GlobalData sharedManager].timeOfDayAvailNoon;
//    rec2.availableAfternoon = [GlobalData sharedManager].timeOfDayAvailAfternoon;
//    rec2.availableEvening = [GlobalData sharedManager].timeOfDayAvailEvening;
    
    
    
    
    // Send the personal data to the remote database.
    
    Responder* responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandlerSendPersonalData:)
                                selErrorHandler:@selector(errorHandler:)];
    
    RDB_PersonalData* record = [[RDB_PersonalData alloc] init];    // this transfers the data from the singleton object to the RDB transfer object
    
    id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_PersonalData class]];
    
    [dataStore save:record responder:responder];
    
    
    
//    // Send the schedule to the remote database.
//    
//    Responder* responder2 = [Responder responder:self
//                             selResponseHandler:@selector(responseHandlerSendSchedule:)
//                                selErrorHandler:@selector(errorHandler:)];
//    
//    RDB_Schedule* record2 = [[RDB_Schedule alloc] init];    // this transfers the data from the singleton object to the RDB transfer object
//    
//    id<IDataStore> dataStore2 = [backendless.persistenceService of:[RDB_Schedule class]];
//    
//    [dataStore2 save:record2 responder:responder2];
    
    
    
//    // Save the schedule data to the local database.
//    [[CDatabaseInterface sharedManager] saveSchedule:rec2];

    
    
    
    
    
    
    
    // Save the schedule data.
    // Data will be sent to the remote database and also stored in the local database.
    [[ScheduleManager sharedManager] updateSchedule];
    
    
    
    
    
    
    
    
    [GlobalData sharedManager].initialPass = INITIAL_PASS_NO;
  

    [[CDatabaseInterface sharedManager] saveBaselineSurveyStatus:1]; // record fact that baseline survey has been done.

    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    

}




//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendInfoReadingActivity:(id)response
{
    NSLog(@"Response Handler for send InfoReadingActivity: Response = %@", response);
    
    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"In error handler.");
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendPersonalData:(id)response
{
    NSLog(@"Response Handler for send PersonalData: Response = %@", response);
    
    [[[UIAlertView alloc] initWithTitle:@"Baseline Data Set 1 Received." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendSchedule:(id)response
{
    NSLog(@"Response Handler for send Schedule: Response = %@", response);
    
    [[[UIAlertView alloc] initWithTitle:@"Baseline Data Set 2 Received" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
