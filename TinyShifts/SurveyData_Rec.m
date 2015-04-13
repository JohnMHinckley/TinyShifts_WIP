//
//  SurveyData_Rec.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "SurveyData_Rec.h"

@implementation SurveyData_Rec

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize moodFeeling;
@synthesize moodEnergy;
@synthesize moodCode;
@synthesize qWantResourceInfo1;
@synthesize videoShown;
@synthesize dateStartVideoPlay;
@synthesize timeStartVideoPlay;
@synthesize dateEndVideoPlay;
@synthesize timeEndVideoPlay;
@synthesize qVideoHelpful;
@synthesize qVideoWatchAgain;
@synthesize qVideoRecommend;
@synthesize qWantResourceInfo2;
@synthesize didTransmitThisRecord;



//---------------------------------------------------------------------------------------------------------------------------------



static SurveyData_Rec* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(SurveyData_Rec*) sharedManager
{
    // Returns a pointer to the shared singleton of this class.
    // If the singleton has not yet been allocated and initialized, it will be done here.
    
    if (nil == sharedSingleton)
    {
        // The singleton has not yet been created, so allocate and initialize it here.
        // This is done only once in the program.
        
        sharedSingleton = [[super alloc] init];
        
    }
    else
    {
        // The singleton has already been created, so do nothing more here.
        // Just return the existing non-null pointer.
    }
    return sharedSingleton;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id) init
{
    participantId = [[NSMutableString alloc] initWithString:@""];
    dateRecord = [[NSMutableString alloc] initWithString:@""];
    timeRecord = [[NSMutableString alloc] initWithString:@""];
    dateStartVideoPlay = [[NSMutableString alloc] initWithString:@""];
    timeStartVideoPlay = [[NSMutableString alloc] initWithString:@""];
    dateEndVideoPlay = [[NSMutableString alloc] initWithString:@""];
    timeEndVideoPlay = [[NSMutableString alloc] initWithString:@""];
    
    [self clearData];
    
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void)clearData
{
    // Clear or initialize all data values
    
    idRecord                = 0;
    participantId           = @"";
    dateRecord                    = @"";
    timeRecord                    = @"";
    moodFeeling             = 0;
    moodEnergy              = 0;
    moodCode                = 0;
    qWantResourceInfo1      = 0;
    videoShown              = 0;
    dateStartVideoPlay      = @"";
    timeStartVideoPlay      = @"";
    dateEndVideoPlay        = @"";
    timeEndVideoPlay        = @"";
    qVideoHelpful           = 0;
    qVideoWatchAgain        = 0;
    qVideoRecommend         = 0;
    qWantResourceInfo2      = 0;
    didTransmitThisRecord   = 0;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
