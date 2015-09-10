//
//  RDB_Schedule.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

/* Modification log
 
 Date			Author			Action
 --------------------------------------------------------
 10-Sep-2015	J. M. Hinckley	Added synthesization of NSInteger properties availableVEarly and availableNight.
 
 */


#import "RDB_Schedule.h"
#import "Schedule_Rec.h"

@implementation RDB_Schedule

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize bUseGoogleCalendar;
@synthesize weeklyFrequency;
@synthesize availableVEarly;    // added 10-Sep-2015
@synthesize availableNight;     // added 10-Sep-2015
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
    dateRecord          = [Schedule_Rec sharedManager].dateRecord;
    timeRecord          = [Schedule_Rec sharedManager].timeRecord;
    bUseGoogleCalendar  = [Schedule_Rec sharedManager].bUseGoogleCalendar;
    weeklyFrequency     = [Schedule_Rec sharedManager].weeklyFrequency;
    availableVEarly     = [Schedule_Rec sharedManager].availableVEarly;         // added 10-Sep-2015
    availableNight      = [Schedule_Rec sharedManager].availableNight;          // added 10-Sep-2015
    availableMorning    = [Schedule_Rec sharedManager].availableMorning;
    availableNoon       = [Schedule_Rec sharedManager].availableNoon;
    availableAfternoon  = [Schedule_Rec sharedManager].availableAfternoon;
    availableEvening    = [Schedule_Rec sharedManager].availableEvening;
    
    return self;
    
}


@end
