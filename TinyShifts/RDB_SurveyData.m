//
//  RDB_SurveyData.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_SurveyData.h"
#import "SurveyData_Rec.h"

@implementation RDB_SurveyData

@synthesize idRecord;
@synthesize participantId;
@synthesize date;
@synthesize time;
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


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord            = [SurveyData_Rec sharedManager].idRecord;
    participantId       = [SurveyData_Rec sharedManager].participantId;
    date                = [SurveyData_Rec sharedManager].date;
    time                = [SurveyData_Rec sharedManager].time;
    moodFeeling         = [SurveyData_Rec sharedManager].moodFeeling;
    moodEnergy          = [SurveyData_Rec sharedManager].moodEnergy;
    moodCode            = [SurveyData_Rec sharedManager].moodCode;
    qWantResourceInfo1  = [SurveyData_Rec sharedManager].qWantResourceInfo1;
    videoShown          = [SurveyData_Rec sharedManager].videoShown;
    dateStartVideoPlay  = [SurveyData_Rec sharedManager].dateStartVideoPlay;
    timeStartVideoPlay  = [SurveyData_Rec sharedManager].timeStartVideoPlay;
    dateEndVideoPlay    = [SurveyData_Rec sharedManager].dateEndVideoPlay;
    timeEndVideoPlay    = [SurveyData_Rec sharedManager].timeEndVideoPlay;
    qVideoHelpful       = [SurveyData_Rec sharedManager].qVideoHelpful;
    qVideoWatchAgain    = [SurveyData_Rec sharedManager].qVideoWatchAgain;
    qVideoRecommend     = [SurveyData_Rec sharedManager].qVideoRecommend;
    qWantResourceInfo2  = [SurveyData_Rec sharedManager].qWantResourceInfo2;
    
    return self;
    
}


@end
