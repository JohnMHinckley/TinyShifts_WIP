//
//  RDB_Schedule.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_Schedule.h"
#import "Schedule_Rec.h"

@implementation RDB_Schedule

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize weeklyFrequency;
@synthesize availableMorning;
@synthesize availableNoon;
@synthesize availableAfternoon;
@synthesize availableEvening;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord            = [Schedule_Rec sharedManager].idRecord;
    participantId       = [Schedule_Rec sharedManager].participantId;
    dateRecord                = [Schedule_Rec sharedManager].dateRecord;
    timeRecord                = [Schedule_Rec sharedManager].timeRecord;
    weeklyFrequency     = [Schedule_Rec sharedManager].weeklyFrequency;
    availableMorning    = [Schedule_Rec sharedManager].availableMorning;
    availableNoon       = [Schedule_Rec sharedManager].availableNoon;
    availableAfternoon  = [Schedule_Rec sharedManager].availableAfternoon;
    availableEvening    = [Schedule_Rec sharedManager].availableEvening;
    
    return self;
    
}


@end
