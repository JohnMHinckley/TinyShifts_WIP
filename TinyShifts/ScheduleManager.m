//
//  ScheduleManager.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/21/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ScheduleManager.h"
#import "DailyTimeIntervals.h"

@implementation ScheduleManager



//---------------------------------------------------------------------------------------------------------------------------------



static ScheduleManager* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(ScheduleManager*) sharedManager
{
    // Method returns a pointer to the shared singleton of this class.
    
    if (nil == sharedSingleton)
    {
        // Only if the singleton has not yet been allocated, is it allocated, here.
        // Thus, it is allocated only once in the program, i.e. it's a SINGLETON.
        //sharedSingleton = [[super allocWithZone:NULL] init];
        sharedSingleton = [[super alloc] init];
    }
    return sharedSingleton;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id) init
{
    self = [super init];
    
    timeIntervals = [[NSMutableDictionary alloc] init];
    
    
    
    //---------------------------------------------
    // Set up the array of time intervals
    DailyTimeIntervals* a = nil;
    
    // onse set of following instructions for each time interval
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Very early morning";
    a.start_hour = 0;
    a.start_minute = 0;
    a.bAvailable = NO;
    [timeIntervals  setValue:a forKey:a.interval_name];
    
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Morning";
    a.start_hour = 8;
    a.start_minute = 0;
    a.bAvailable = YES;
    [timeIntervals  setValue:a forKey:a.interval_name];
    
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Noon";
    a.start_hour = 11;
    a.start_minute = 0;
    a.bAvailable = YES;
    [timeIntervals  setValue:a forKey:a.interval_name];
    
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Afternoon";
    a.start_hour = 13;
    a.start_minute = 0;
    a.bAvailable = YES;
    [timeIntervals  setValue:a forKey:a.interval_name];
    
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Evening";
    a.start_hour = 18;
    a.start_minute = 0;
    a.bAvailable = YES;
   [timeIntervals  setValue:a forKey:a.interval_name];
    
    a = [[DailyTimeIntervals alloc] init];
    a.interval_name = @"Night";
    a.start_hour = 21;
    a.start_minute = 0;
    a.bAvailable = NO;
    [timeIntervals  setValue:a forKey:a.interval_name];
    //---------------------------------------------
   
    
                     
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) getNextRandomEventTime
{
    /*
     Pseudorandomly pick the next time for an event.
     
     Procedure:
     1. Form an array of minutes for a whole week, 10080 elements.
     2. initialize array m[i] = i;
     3. read time interval boundaries from remote database (temporarily, use local array member timeIntervals).
     4. set minute array elements = 0 where time intervals are unavailable
     5. set all minute array elements = 0 from the beginning up to 1 hour from now.
     6. if not using Google calendar:
     7. sort the minute array in ascending order of value
     8. find the index of the lowest non-zero element
     9. If a non-zero element does not exist: there are no more events to do this week.
     10. Otherwise, pick Nr random number from [n1 to 10080]
     11. Select the smallest random number.  Use this as the time for the next notification.
     12. Register the next notification.
     
     */
    const int secondsPerWeek = 60 * 24 * 7;
    
    // step 1
    int m [secondsPerWeek];
    
    // step 2
    for (int i = 0; i < secondsPerWeek; i++)
    {
        m[i] = i;
    }
    
    // Step 4.
    // How many time intervals are there?
    NSUInteger numberOfTimeIntervals = [timeIntervals count];
    
    if (numberOfTimeIntervals <= 0)
    {
        NSLog(@"Error in ScheduleManager::getNextRandomEventTime: number of time intervals = %d", numberOfTimeIntervals);
        assert(numberOfTimeIntervals > 0);
    }
    else
    {
        // positive number of time intervals.
        // For the morning through evening time intervals, set the available flag to whatever is current for this user.
        DailyTimeIntervals* a = (DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"];
        a.bAvailable = 
        
    }
    
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
