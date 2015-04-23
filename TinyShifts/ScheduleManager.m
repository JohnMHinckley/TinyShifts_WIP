//
//  ScheduleManager.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/21/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ScheduleManager.h"
#import "GlobalData.h"
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
    const int minutesPerWeek = 60 * 24 * 7;
    
    // step 1
    int m [minutesPerWeek];
    
    // step 2
    for (int i = 0; i < minutesPerWeek; i++)
    {
        m[i] = i;
    }
    
    
    //=========================================================================================
    // Step 4.
    // How many time intervals are there?
    NSUInteger numberOfTimeIntervals = [timeIntervals count];
    
    
    // For each time interval, set the availability flag (very early morning and night are always unavailable).
    if (numberOfTimeIntervals <= 0)
    {
        NSLog(@"Error in ScheduleManager::getNextRandomEventTime: number of time intervals = %d", numberOfTimeIntervals);
        assert(numberOfTimeIntervals > 0);
    }
    else
    {
        // positive number of time intervals.
        // For the morning through evening time intervals, set the available flag to whatever is current for this user.
        DailyTimeIntervals* a = nil;
        
        a = (DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"];
        a.bAvailable = ([GlobalData sharedManager].timeOfDayAvailMorning == 1 ? YES:NO);
        
        a = (DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"];
        a.bAvailable = ([GlobalData sharedManager].timeOfDayAvailNoon == 1 ? YES:NO);
        
        a = (DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"];
        a.bAvailable = ([GlobalData sharedManager].timeOfDayAvailAfternoon == 1 ? YES:NO);
        
        a = (DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"];
        a.bAvailable = ([GlobalData sharedManager].timeOfDayAvailEvening == 1 ? YES:NO);
        
    }
    
    // Number of minutes per day.
    int numberMinutesPerDay = 60 * 24;
    
    // Loop over days of the week, Sunday = 0, ..., Saturday = 6.
    int start_minute = 0;
    int end_minute = 0;
    int idxMinute = 0;
    int mValue = 0;
    for (int idxDay = 0; idxDay < 7; idxDay++)
    {
        //-------------------------
        
        // Set values of very early morning minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Very early morning"]).start_hour * 60 // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Very early morning"]).start_minute;   // number of minutes to get from start of hour to given minute
        assert(start_minute >= 0);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_hour * 60            // number of minutes to get from start of day to start of the hour that starts the next interval
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_minute               // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
       
        // loop over minute indices, setting corresponding array elements according to availability flag.
        if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Very early morning"]).bAvailable == NO)
        {
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        
        
        //-------------------------
        
        // Set values of morning minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_hour * 60            // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_minute;              // number of minutes to get from start of hour to given minute
        assert(start_minute > end_minute);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_hour * 60               // number of minutes to get from start of day to start of the hour that starts the next interval
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_minute                  // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
        
        // loop over minute indices, setting corresponding array elements according to availability flag.
        if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).bAvailable == NO)
        {
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        
        
        //-------------------------
        
        // Set values of noon minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_hour * 60               // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_minute;                 // number of minutes to get from start of hour to given minute
        assert(start_minute > end_minute);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_hour * 60          // number of minutes to get from start of day to start of the hour that starts the next interval
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_minute             // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
        
        // loop over minute indices, setting corresponding array elements according to availability flag.
        if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).bAvailable == NO)
        {
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        
        
        //-------------------------
        
        // Set values of afternoon minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_hour * 60          // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_minute;            // number of minutes to get from start of hour to given minute
        assert(start_minute > end_minute);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_hour * 60            // number of minutes to get from start of day to start of the hour that starts the next interval
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_minute               // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
       
        // loop over minute indices, setting corresponding array elements according to availability flag.
        mValue = (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).bAvailable ? 1 : 0);
        
        for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
        {
            m[idxMinute] = 0;
        }
        
        
        //-------------------------
        
        // Set values of evening minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_hour * 60            // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_minute;              // number of minutes to get from start of hour to given minute
        assert(start_minute > end_minute);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_hour * 60              // number of minutes to get from start of day to start of the hour that starts the next interval
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_minute                 // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
        
        // loop over minute indices, setting corresponding array elements according to availability flag.
        if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).bAvailable == NO)
        {
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        
        
        //-------------------------
        
        // Set values of night minutes in minute array.
        
        // Starting minute index
        start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_hour * 60              // number of minutes to get from start of day to start of given hour
        + ((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_minute;                // number of minutes to get from start of hour to given minute
        assert(start_minute > end_minute);
        assert(start_minute < minutesPerWeek);
        
        // Ending minute index
        end_minute = (idxDay+1) * numberMinutesPerDay                                               // number of minutes to get to the start of the next day
        - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next day.  This is the end of the current interval.
        assert(end_minute >= start_minute);
        assert(end_minute < minutesPerWeek);
        
        // loop over minute indices, zeroing corresponding array elements.
        
        // loop over minute indices, setting corresponding array elements according to availability flag.
        if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).bAvailable == NO)
        {
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        
        //-------------------------
    }
    
    
    //=========================================================================================
    
    // Step 5. set all minute array elements = 0 from the beginning up to 1 hour from now.

    // what is the minute index of the current time?
    // Get today's date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
    
    // Get the minimum date/time as components.
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger minute = [components minute];
    NSInteger hour = [components hour];
    
    int currentMinuteIndex = (weekday - 1)*numberMinutesPerDay
    + hour * 60
    + minute;
    
    // Add one hour's worth of minutes
    end_minute = currentMinuteIndex + 60;
    
    
    // make sure not to go beyond end of week.
    if (end_minute >= minutesPerWeek)
    {
        end_minute = minutesPerWeek - 1;
    }
    
    start_minute = 0;
    
    for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
    {
        m[idxMinute] = 0;
    }
    
    
    
    //=========================================================================================
    // Check for use of Google calendar
    // if not using Google calendar...
    
    // Step 7. sort the minute array in ascending order of value
    


}



//---------------------------------------------------------------------------------------------------------------------------------



@end
