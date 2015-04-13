//
//  SendSurveyViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "SendSurveyViewController.h"
#import "GlobalData.h"
#import "ConstGen.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"
#import "RDB_SurveyData.h"
#import "SurveyData_Rec.h"

@interface SendSurveyViewController ()

@end

@implementation SendSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)submitButtonPressed:(CGradientButton *)sender {
    // Submit the main survey data and pop the navigation stack to the start screen.
    
    SurveyData_Rec* rec = [SurveyData_Rec sharedManager];
    
    rec.idRecord++;
    rec.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
    // Get the current date and time and save these in the SurveyData_Rec object.
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

    switch ([GlobalData sharedManager].moodMeterSelection)
    {
        case MOOD_METER_RED:
            rec.moodFeeling = -1;
            rec.moodEnergy = 1;
            break;
            
        case MOOD_METER_YELLOW:
            rec.moodFeeling = 1;
            rec.moodEnergy = 1;
            break;
            
        case MOOD_METER_BLUE:
            rec.moodFeeling = -1;
            rec.moodEnergy = -1;
            break;
            
        case MOOD_METER_GREEN:
            rec.moodFeeling = 1;
            rec.moodEnergy = -1;
           break;
            
            default:
            rec.moodFeeling = 0;
            rec.moodEnergy = 0;
           break;
    }
    
    rec.moodCode = [GlobalData sharedManager].moodTableSelection;
    
    rec.qWantResourceInfo1 = [GlobalData sharedManager].wantResourceInfo1;
    
    rec.videoShown = [GlobalData sharedManager].selectedVideo;
    
    rec.dateStartVideoPlay = [GlobalData sharedManager].dateStartVideoPlay;
    rec.timeStartVideoPlay = [GlobalData sharedManager].timeStartVideoPlay;
    rec.dateEndVideoPlay = [GlobalData sharedManager].dateEndVideoPlay;
    rec.timeEndVideoPlay = [GlobalData sharedManager].timeEndVideoPlay;
    
    rec.qVideoHelpful = [GlobalData sharedManager].videoWasHelpful;
    rec.qVideoWatchAgain = [GlobalData sharedManager].videoWatchAgain;
    rec.qVideoRecommend = [GlobalData sharedManager].videoRecommend;
    
    rec.qWantResourceInfo2 = [GlobalData sharedManager].wantResourceInfo2;
    
    
    
    
    // Send the survey data to the remote database
    
    Responder* responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandlerSendSurveyData:)
                                selErrorHandler:@selector(errorHandler:)];
    
    RDB_SurveyData* record = [[RDB_SurveyData alloc] init];
    
    id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_SurveyData class]];
    
    [dataStore save:record responder:responder];
    
    

    

    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}




//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendSurveyData:(id)response
{
    NSLog(@"Response Handler for send SurveyData: Response = %@", response);
    
    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"In error handler.");
}



//---------------------------------------------------------------------------------------------------------------------------------




@end
