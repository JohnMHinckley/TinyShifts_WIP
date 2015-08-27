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
#import "Schedule_Rec.h"
#import "CDatabaseInterface.h"
#import "RDB_Schedule.h"
#import "Backendless.h"
#import "Notifications_Rec.h"
@import UIKit;

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
    
    
    dateMostRecentNotificationResponse = [NSDate dateWithTimeIntervalSince1970:0];  // initialize this date to a time way back...
   
    
                     
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSDate*) getNextRandomEventTime
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
    
    BOOL bStartNewWeek = NO;    // flag, YES when current week is done and this routine starts new week.
    
    
    NSDate* retval = nil;   // return value: pointer to a NSDate object.
    
    
    const int minutesPerWeek = 60 * 24 * 7;
    
    // Get today's date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = (int)[components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
    
    // Get the NSDate object for now
    NSDate* now = [NSDate date];
    
    // Get the components of this date/time
    components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:now];
    NSInteger nowHour = [components hour];
    NSInteger nowMinute = [components minute];
    NSInteger secondsBeforeNow = 60 * (nowMinute + 60 * (nowHour + 24 * (weekday-1)));    // number of seconds between 12:00 a.m. Sunday and now.
    NSTimeInterval dTime = (NSTimeInterval) (-secondsBeforeNow);
    
    // Get the NSDate object for 12:00 a.m. Sunday
    NSDate* dateSunday = [NSDate dateWithTimeInterval:dTime sinceDate:now];
    
    
    // Initialize the number of week steps.
    // This is the number of times the week has been advanced, looking for an available segment
    int weekStep = 0;   // If weekStep == 0, it's this week, if weekStep == 1, it's next week, etc.

    
    
    // The following block of code checks whether all of the events for the current week have been completed.
    // If so, then the starting day for the calculation is advanced to Sunday of the next week and the number of done events (for next week) is set to 0,
    //          and remaining number of events to do is set to the total number to do in the week.
    // Otherwise, if not all of the events for the current week have been completed,
    //          then the following code block does nothing and calculation continues based on starting with Sunday of the current week.
    int n1 = (int)[self getTotalNumberEvents];
    int n2 = (int)[self getNumberDoneEvents];
    NSInteger Nr = MAX(0, n1 - n2);
    
    
    do
    {
        // Calculate the next time in the selected week.
        
        if (Nr <= 0)
        {
            
            bStartNewWeek = YES;    // flag indicating that new week is started.
            
            
            
            
            // Get the dateSunday starting next week.
            dTime = (NSTimeInterval) (7 * 24 * 60 * 60);    // number of seconds in a week.
            dateSunday = [NSDate dateWithTimeInterval:dTime sinceDate:dateSunday];  // add a week to dateSunday.
            
            
            // Reset the number of done events to zero.
            [self setNumberDoneEvents:0];
            
            n2 = (int)[self getNumberDoneEvents];
            Nr = MAX(0, n1 - n2);               // Get new number of remaining events to do.
        }
        
        
        
        
        
        
        
        
        // There are remaining events for this week, so get the next one.
        // step 1
        int m [minutesPerWeek];
        
        // step 2
        for (int i = 0; i < minutesPerWeek; i++)
        {
            m[i] = i;
        }
        
        
        // step 3.
        // Time interval boundaries obtained from local dictionary member timeIntervals.
        
        
        //=========================================================================================
        // Step 4.
        // How many time intervals are there?
        NSUInteger numberOfTimeIntervals = [timeIntervals count];
        
        
        // For each time interval, set the availability flag (very early morning and night are always unavailable).
        if (numberOfTimeIntervals <= 0)
        {
            NSLog(@"Error in ScheduleManager::getNextRandomEventTime: number of time intervals = %lu", (unsigned long)numberOfTimeIntervals);
            assert(numberOfTimeIntervals > 0);
        }
        else
        {
            // positive number of time intervals.
            // For the morning through evening time intervals, set the available flag to whatever is current for this user.
            
            // Get the most recent schedule data
            Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
            [GlobalData sharedManager].timeOfDayAvailMorning = (int)rec.availableMorning;
            [GlobalData sharedManager].timeOfDayAvailNoon = (int)rec.availableNoon;
            [GlobalData sharedManager].timeOfDayAvailAfternoon = (int)rec.availableAfternoon;
            [GlobalData sharedManager].timeOfDayAvailEvening = (int)rec.availableEvening;
            
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
        for (int idxDay = 0; idxDay < 7; idxDay++)
        {
            //-------------------------
            
            // Set values of very early morning minutes in minute array.
            
            // Starting minute index
            start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Very early morning"]).start_hour * 60 // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Very early morning"]).start_minute;   // number of minutes to get from start of hour to given minute
            assert(start_minute >= 0);
            assert(start_minute < minutesPerWeek);
            
            // Ending minute index
            end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_hour * 60            // number of minutes to get from start of day to start of the hour that starts the next interval
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_minute               // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
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
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_hour * 60            // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Morning"]).start_minute;              // number of minutes to get from start of hour to given minute
            assert(start_minute > end_minute);
            assert(start_minute < minutesPerWeek);
            
            // Ending minute index
            end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_hour * 60               // number of minutes to get from start of day to start of the hour that starts the next interval
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_minute                  // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
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
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_hour * 60               // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).start_minute;                 // number of minutes to get from start of hour to given minute
            assert(start_minute > end_minute);
            assert(start_minute < minutesPerWeek);
            
            // Ending minute index
            end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_hour * 60          // number of minutes to get from start of day to start of the hour that starts the next interval
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_minute             // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
            - 1;                                                                                        // subtract 1 to get the minute index just before the start of the next interval.  This is the end of the current interval.
            assert(end_minute >= start_minute);
            assert(end_minute < minutesPerWeek);
            
            // loop over minute indices, setting corresponding array elements according to availability flag.
            if (((DailyTimeIntervals*)[timeIntervals objectForKey:@"Noon"]).bAvailable == NO)
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
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_hour * 60          // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Afternoon"]).start_minute;            // number of minutes to get from start of hour to given minute
            assert(start_minute > end_minute);
            assert(start_minute < minutesPerWeek);
            
            // Ending minute index
            end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_hour * 60            // number of minutes to get from start of day to start of the hour that starts the next interval
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_minute               // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
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
            
            // Set values of evening minutes in minute array.
            
            // Starting minute index
            start_minute = idxDay * numberMinutesPerDay                                                 // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_hour * 60            // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Evening"]).start_minute;              // number of minutes to get from start of hour to given minute
            assert(start_minute > end_minute);
            assert(start_minute < minutesPerWeek);
            
            // Ending minute index
            end_minute = idxDay * numberMinutesPerDay                                                   // number of minutes to get to the start of the given day
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_hour * 60              // number of minutes to get from start of day to start of the hour that starts the next interval
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_minute                 // number of minutes to get from start of hour that starts the next interval to the minute that starts the next interval
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
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_hour * 60              // number of minutes to get from start of day to start of given hour
            + (int)((DailyTimeIntervals*)[timeIntervals objectForKey:@"Night"]).start_minute;                // number of minutes to get from start of hour to given minute
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
        
        if (bStartNewWeek == NO)
        {
            // Events to be done remain for this week, as signified by Nr > 0.  Therefore, zero out minutes up to one hour after the current time.
            // Step 5. set all minute array elements = 0 from the beginning up to 1 hour from now.
            
            // what is the minute index of the current time?
            // Get today's date
            //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            //    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            //    int weekday = (int)[components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
            
            // Get the minimum date/time as components.
            components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            NSInteger minute = [components minute];
            NSInteger hour = [components hour];
            
            int currentMinuteIndex = (weekday - 1)*numberMinutesPerDay
            + (int)hour * 60
            + (int)minute;
            
            // Add one hour's worth of minutes
            end_minute = currentMinuteIndex + 60;
            
            
            // make sure not to go beyond end of week.
            if (end_minute >= minutesPerWeek)
            {
                end_minute = minutesPerWeek - 1;
            }
            
            start_minute = 0;
            
            // Set minutes from now to up to one hour from now (not beyond end of week) to zero.
            for (idxMinute = start_minute; idxMinute <= end_minute; idxMinute++)
            {
                m[idxMinute] = 0;
            }
        }
        else
        {
            // No events remained for this week.  So scheduling will move to next week.  So no need to block off any minutes up to one hour after the current time.
        }
        
        
        
        
        
        
        
        
        
        //=========================================================================================
        // Check for use of Google calendar
        
        //    if ([[GlobalData sharedManager] bUseGoogleCal])
        //    {
        //        // Is using Google calendar.
        //#pragma mark ***** TODO: code this.
        //
        //    }
        //    else
        //    {
        // if not using Google calendar...
        
        
        // Step 7. sort the minute array in ascending order of value
        // Use an exchange sort method with the special knowledge that the array has multiple zero values and that
        // these are the smallest values.
        
        for (int j = 0; j < minutesPerWeek-1; j++)    // loop over index for first element
        {
            if (m[j] > 0)
            {
                // Loops over index of second element, only if first element is greater than zero.
                for (int i = j+1; i < minutesPerWeek; i++)  // loop over index for second element
                {
                    if (m[i] < m[j])
                    {
                        // first element is larger than the second element: must swap them
                        int mtemp = m[i];
                        m[i] = m[j];
                        m[j] = mtemp;
                    }
                }
            }
            else
            {
                // On the other hand, if the first element is zero, it is not larger than any possible second
                // element, so the first element can stay where it is.  Go to the next first element.
            }
        }
        
        
        
        
        // Step 8.  find the index of the lowest non-zero element
        int indexFirstNonzeroElement = minutesPerWeek;  // this will become the index for the first non-zero element in the sorted array.
        // if no element is non-zero, this index will remain at minutesPerWeek, in which
        // case, this will signal that there are no non-zero elements in the array.
        
        for (int j = 0; j < minutesPerWeek && (indexFirstNonzeroElement == minutesPerWeek); j++)    // loop only until the first non-zero element is found.
        {
            if (m[j] > 0)
            {
                indexFirstNonzeroElement = j;
                break;  // leave the for-loop, having found the lowest non-zero element.
            }
        }
        
        
        
        
        
        
        // Does a non-zero element exist?
        // Step 9. If a non-zero element does not exist: there are no more events to do this week.
        
        if (indexFirstNonzeroElement < minutesPerWeek)
        {
            // there is at least one nonzero element.
            // Step 10. Otherwise, pick Nr random number from [n1 to 10080-1]
            // Step 11. Keep the smallest one.
            // Nr is the remaining number of events for this week.
            // n1 is the index of the first non-zero element in the minute array.
            
            // Random number generator provides an integer in the range of [0,ULim-1].
            int ULim = 10080 - indexFirstNonzeroElement;
            int smallestRandomNumber = 10080;
            for (int i = 0; i < Nr; i++)
            {
                int R = 0.0;
                R = [GlobalData RandomIntUpTo:(ULim-1)];
                R = R + indexFirstNonzeroElement;   // put random number in the range of [n1, 10080-1].
                // if this is the smallest one so far, keep it.
                if (R < smallestRandomNumber)
                {
                    smallestRandomNumber = R;
                }
            }
            
            
            // Step 12. Register the next notification.
            
            // the value of smallestRandomNumber is the minute index for the selected time for the next notification.
            // translate this into a NSDate object, then set a local notification for this date.
            
            // Set the notification for this date/time.
            
            //            // Get today's date
            //            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            //            NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            //            int weekday = (int)[components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
            //
            //            // Get the NSDate object for now
            //            NSDate* now = [NSDate date];
            //
            //            // Get the components of this date/time
            //            components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:now];
            //            NSInteger nowHour = [components hour];
            //            NSInteger nowMinute = [components minute];
            //            NSInteger secondsBeforeNow = 60 * (nowMinute + 60 * (nowHour + 24 * (weekday-1)));    // number of seconds between 12:00 a.m. Sunday and now.
            //            NSTimeInterval dTime = (NSTimeInterval) (-secondsBeforeNow);
            //            
            //            // Get the NSDate object for 12:00 a.m. Sunday
            //            NSDate* dateSunday = [NSDate dateWithTimeInterval:dTime sinceDate:now];
            
            // Get the NSDate object for the randomly selected time, which is an offset from 12:00 a.m. Sunday.
            // The NSDate object for 12:00 a.m. Sunday was determined near the start of this routine.
            dTime = (NSTimeInterval) (60 * m[smallestRandomNumber]);
            NSDate* fireDate = [NSDate dateWithTimeInterval:dTime sinceDate:dateSunday];
            
            retval = fireDate;  // return this date object.
            
            
        }
        else
        {
            // There are no more events to do this week.
            NSLog(@"No more events this week");
            
            // Set the number of remaining events this week to zero.
            Nr = 0;
            
            
            // Incrment the number of week steps.
            weekStep++;
        }
        //    }   // Not using Google calendar.
    } while (nil == retval && weekStep < 2);    // go around again a maximum of one more time, if didn't get a time in the current week
    
    
    return retval;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSInteger) getTotalNumberEvents
{
    // Get the number of remaining recommendation events for this week.
    NSInteger retval = [[CDatabaseInterface sharedManager] getTotalNumberEvents];
    return retval;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) setTotalNumberEvents:(int)n
{
    // Set the total number of recommendation events for this week.
    //NSLog(@"Going to set total number of events: %d", n);
    [[CDatabaseInterface sharedManager] saveTotalNumberEvents:n];  // set the total number of events into the database.
    //NSLog(@"Total number of events just set: %d", [[CDatabaseInterface sharedManager] getTotalNumberEvents]);
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSInteger) getNumberDoneEvents
{
    // Get the number of completed recommendation events for this week.
    NSInteger retval = [[CDatabaseInterface sharedManager] getNumberDoneEvents];
    return retval;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) setNumberDoneEvents:(int)n
{
    // Set the number of completed recommendation events for this week.
    //[GlobalData  setAppInfoIntegerValue:n ForKey:@"NumberDoneEvents"];
    [[CDatabaseInterface sharedManager] saveNumberDoneEvents:n];  // set the number of done events into the database.
}



//---------------------------------------------------------------------------------------------------------------------------------






-(void)showAllLocalNotifications
{
    // Examine the scheduled local notifications and display their data in the log window (for debugging)
    
    NSArray* arrNotifications = nil;
    arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];    // Get the array of all scheduled local notifications
    
    // Are there any?
    if ([arrNotifications count] > 0)
    {
        // YES:
        for (int idx = 0; idx < [arrNotifications count]; idx++)
        {
            UILocalNotification* n = (UILocalNotification*)[arrNotifications objectAtIndex:idx];
            
            
            // ----------------- additional code for displaying notification characteristics -----------------------
            NSDate* fD = n.fireDate;    // for examining the firing date of the notification
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd 'at' HH:mm"];
            
            NSLog(@"Local notification #%d,type: %@ fire date: %@", idx, [n.userInfo valueForKey:@"Notification_Type"], [formatter stringFromDate:fD]);
            // ------------------------------------------------------------------------------------------------------
        }
    }
    else
    {
        NSLog(@"No scheduled local notifications found.");
    }
    
}



//---------------------------------------------------------------------------------------------------------------------------------



//-(BOOL) createRecommendationNotificationOnDate:(NSDate*)fireDate
//{
//    BOOL retSuccess = YES;  // return value indicating creation success
//    
//    //-------------------
//    
//    // Allocate a working UILocalNotification object.
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    
//    // Return if it was not properly allocated and initialized.
//    if (localNotif == nil)
//    {
//        retSuccess = NO;
//    }
//    else
//    {
//        
//        localNotif.fireDate = fireDate;
//        localNotif.timeZone = [NSTimeZone defaultTimeZone];
//        
//        
//        // Specify the notification characteristics
//        localNotif.alertBody = @"This is a suggestion to run the TinyShifts app.";    // This is what is displayed at the top of the screen when the notification fires and the app is suspended.
//        
//        localNotif.alertAction = @"View";           // Show "View" on the slider to unlock when event fires.
//        localNotif.soundName = UILocalNotificationDefaultSoundName; // Specifies using the default sound.
//        localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;  // Display this as the icon's badge.
//        
//        //        // Specify custom data for the notification.
//        //        NSString* s1 = [NSString stringWithFormat:@"%d", datum.idRecord];
//        //        NSString* s2 = [NSString stringWithFormat:@"%d", datum.idWeek];
//        //        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"PROD", @"Notification_Type", s1, @"Record_Number", s2, @"Week_Number", nil];
//        //        localNotif.userInfo = infoDict;
//        
//        
//        //------------------------------  Schedule the local notification  --------------------------
//        NSLog(@"Prior to scheduling a suggestion notification:");
//        [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        
//        NSLog(@"After to scheduling a suggestion notification:");
//        [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications
//    }
//    //-------------------
//    
//    return retSuccess;
//}



//---------------------------------------------------------------------------------------------------------------------------------



//-(BOOL) createProdNotificationOnDate:(NSDate*)fireDate
//{
//    BOOL retSuccess = YES;  // return value indicating creation success
//    
//    //-------------------
//    
//    // Allocate a working UILocalNotification object.
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    
//    // Return if it was not properly allocated and initialized.
//    if (localNotif == nil)
//    {
//        retSuccess = NO;
//    }
//    else
//    {
//        
//        localNotif.fireDate = fireDate;
//        localNotif.timeZone = [NSTimeZone defaultTimeZone];
//        
//        
//        // Specify the notification characteristics
//        localNotif.alertBody = @"Consider setting automatic recommendations in the TinyShifts app.";    // This is what is displayed at the top of the screen when the notification fires and the app is suspended.
//        
//        localNotif.alertAction = @"View";           // Show "View" on the slider to unlock when event fires.
//        localNotif.soundName = UILocalNotificationDefaultSoundName; // Specifies using the default sound.
//        localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;  // Display this as the icon's badge.
//        
//        //        // Specify custom data for the notification.
//        //        NSString* s1 = [NSString stringWithFormat:@"%d", datum.idRecord];
//        //        NSString* s2 = [NSString stringWithFormat:@"%d", datum.idWeek];
//        //        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"PROD", @"Notification_Type", s1, @"Record_Number", s2, @"Week_Number", nil];
//        //        localNotif.userInfo = infoDict;
//        
//        
//        //------------------------------  Schedule the local notification  --------------------------
//        NSLog(@"Prior to scheduling a suggestion notification:");
//        [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        
//        NSLog(@"After to scheduling a suggestion notification:");
//        [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications
//    }
//    //-------------------
//    
//    return retSuccess;
//}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) updateSchedule
{
    // Record part of the database record for Schedule.
    
    // The current schedule data is assumed to be in the GlobalData singleton object.
    
    
    Schedule_Rec* rec2 = [Schedule_Rec sharedManager];
    
    rec2.idRecord++; // increment the record id
    
    rec2.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
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
    
    rec2.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec2.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    rec2.bUseGoogleCalendar = [GlobalData sharedManager].bUseGoogleCal;
    
    rec2.weeklyFrequency = [GlobalData sharedManager].frequency;
    
    rec2.availableMorning = [GlobalData sharedManager].timeOfDayAvailMorning;
    rec2.availableNoon = [GlobalData sharedManager].timeOfDayAvailNoon;
    rec2.availableAfternoon = [GlobalData sharedManager].timeOfDayAvailAfternoon;
    rec2.availableEvening = [GlobalData sharedManager].timeOfDayAvailEvening;
    
    
    
    // Save the schedule record to the local database.
    [[CDatabaseInterface sharedManager] saveSchedule:rec2];
    
    
    
    
    // Send the schedule to the remote database.
    
    Responder* responder2 = [Responder responder:self
                              selResponseHandler:@selector(responseHandlerSendSchedule:)
                                 selErrorHandler:@selector(errorHandler:)];
    
    RDB_Schedule* record2 = [[RDB_Schedule alloc] init];
    
    id<IDataStore> dataStore2 = [backendless.persistenceService of:[RDB_Schedule class]];
    
    [dataStore2 save:record2 responder:responder2];
    
    
    
    
    
    // *************** test code ***************
    NSInteger b2 = [UIApplication sharedApplication].applicationIconBadgeNumber;
    // *****************************************
    
    NSInteger badgeNum = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    [self setNextLocalNotification:badgeNum];    // start the timer for the next local notification.
    
    
    
}
//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendSchedule:(id)response
{
    NSLog(@"Response Handler for send Schedule: Response = %@", response);
    
    [[[UIAlertView alloc] initWithTitle:@"Baseline Data Set 2 Received" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------




//---------------------------------------------------------------------------------------------------------------------------------
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


//---------------------------------------------------------------------------------------------------------------------------------



-(void) clearAllLocalNotifications
{
    // Look over all of the local notifications.
    // Stop any found.
    
    NSArray* arrNotifications = nil;
    arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];    // Get the array of all scheduled local notifications
    
    // Are there any?
    if ([arrNotifications count] > 0)
    {
        // YES:
        // Cancel them.
        for (int idx = 0; idx < [arrNotifications count]; idx++)
        {
            UILocalNotification* n = (UILocalNotification*)[arrNotifications objectAtIndex:idx];
            
            [[UIApplication sharedApplication] cancelLocalNotification:n];
        }
    }
    
    // Check that there are no notificiations left.
    arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];    // Get the array of all scheduled local notifications
    // Are there any?
    if ([arrNotifications count] > 0)
    {
        // YES:
        NSLog(@"*** Warning: the method ScheduleManager::clearAllLocalNotifications did not clear all local notifications.");
    }
}



//---------------------------------------------------------------------------------------------------------------------------------



-(int) getNumberAvailTimeSegments
{
    // Return the number of available time segments per day.
    int retval = 0;
    
    Schedule_Rec* rec = [[CDatabaseInterface sharedManager] getLatestSchedule];
    [GlobalData sharedManager].timeOfDayAvailMorning = (int)rec.availableMorning;
    [GlobalData sharedManager].timeOfDayAvailNoon = (int)rec.availableNoon;
    [GlobalData sharedManager].timeOfDayAvailAfternoon = (int)rec.availableAfternoon;
    [GlobalData sharedManager].timeOfDayAvailEvening = (int)rec.availableEvening;
    
    if ([GlobalData sharedManager].timeOfDayAvailMorning > 0)
    {
        retval++;
    }
    if ([GlobalData sharedManager].timeOfDayAvailNoon > 0)
    {
        retval++;
    }
    if ([GlobalData sharedManager].timeOfDayAvailAfternoon > 0)
    {
        retval++;
    }
    if ([GlobalData sharedManager].timeOfDayAvailEvening > 0)
    {
        retval++;
    }
    return retval;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) setNextLocalNotification:(NSInteger) badgeNumber
{
    // There is some kind of change in the schedule.
    
    // The badge number for the app is passed in as a parameter.  This is used to determine whether this routine is being called in response to handling a local notifiication.
    // If the badge number is > 0, then this is being run in response to a notification.  Otherwise, the app is just starting up.
    
    
    
    // Cancel any currently registered local notifications.
    [self clearAllLocalNotifications];
    
    
    
    Notifications_Rec* rec = [[Notifications_Rec alloc]init];   // new record that will be written to the Notifications table, describing the next local notification that will be registered here.
    
    
    
    // Calculate a potential suggestion fire date here.
    // If this comes back nil, this means that there are no more available minutes this week, nor next week.
    // In such a case, do a PROD type notification to urge the user to open up some times.
    
    // Calculate the possible next notification time.
    NSDate* fireDatePossible = [self getNextRandomEventTime];
    
    

    
    
    // Are there zero available time segments in the new schedule?
    if (([self getNumberAvailTimeSegments] <= 0)    // there are zero available time segments in the schedule
        || (fireDatePossible == nil))               // none of the available time segments remain this (or next) week
    {
        // there are no available time segments in the current schedule
        
        // Create a PROD notification.
        rec.type = @"PROD";
        
        
        
        //---------------------------------------------------------------------------------------------
        // Set the fire date/time to the next Friday at 6:00 p.m.
        // If the current day is Sunday-Thursday, set it for Friday of this week.
        // On the other hand, if the current day is Friday or Saturday, set it for Friday of next week.
        
        // Get the NSDate object for now
        NSDate* now = [NSDate date];
        
        // Get the current day of the week.
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:now];
        int weekday = (int)[components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
        
        // Get the components of this date/time
        components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:now];
        NSInteger nowHour = [components hour];
        NSInteger nowMinute = [components minute];
        NSInteger secondsBeforeNow = 60 * (nowMinute + 60 * (nowHour + 24 * (weekday-1)));    // number of seconds between 12:00 a.m. Sunday and now.
        NSTimeInterval dTime = (NSTimeInterval) (-secondsBeforeNow);
        
        // Get the NSDate object for 12:00 a.m. Sunday of this week
        NSDate* dateSunday = [NSDate dateWithTimeInterval:dTime sinceDate:now];
        
        // Get the number of seconds from 12:00 a.m. Sunday of this week to 6:00 p.m. Friday of this week.
        dTime = (NSTimeInterval) (((5 * 24) + 18) * 60 * 60);
        
        // If today is Friday or Saturday, add another week to the above value.
        if (weekday == 6 || weekday == 7)
        {
            dTime = dTime + (NSTimeInterval) (7 * 24 * 60 * 60);
        }
        
        // Get the NSDate object for the PROD reminder, which is an offset from 12:00 a.m. Sunday.
        NSDate* fireDate = [NSDate dateWithTimeInterval:dTime sinceDate:dateSunday];
        
        // Get the components of this date/time
        components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:fireDate];
        rec.fireYear = [components year];
        rec.fireMonth = [components month];
        rec.fireDay = [components day];
        rec.fireHour = [components hour];
        rec.fireMinute = [components minute];
        
        // Clear generated flag.
        rec.alertWasGenerated = 0;
        
    }
    else
    {
        // There is at least one available time segment.
        
        // Create a SUGG notification.
        rec.type = @"SUGG";
        
        
        
        
        
        // If the last time that this function was called was before Sunday 12:00 a.m. of this week,
        // and if the app has a badge number > 0 (user has been notified),
        // then set then number of completed events this week to 1 (the current one).
        if (badgeNumber > 0)
        {
            // This routine is being run in response to a notification.
            NSLog(@"Setting next local notification in response to an earlier notification.  Badge number was %d", (int)badgeNumber);
            
            NSDate* dateSunday = [self getDateSunday];
            
            if ([dateSunday compare:dateMostRecentNotificationResponse] == NSOrderedDescending)
            {
                // dateSunday is later than dateMostRecentNotificationResponse, which means that the most recent notification response
                // occurred in some week prior to the current one.
                // This is the condition in which the number of completed events needs to be reset to 1, this being a new week, compared to the one where a response occurred last.
                [self setNumberDoneEvents:1];
            }
            
            
            // update the date at which this routine was last run in response to a notificiation.
            dateMostRecentNotificationResponse = [NSDate date];
        }
        else
        {
            NSLog(@"Setting a local notification where there has not been one before");
        }
        
        
        
        
        
        
        
        // Calculate the next notification time.
       // moved to an above location NSDate* fireDate = [self getNextRandomEventTime];
        
        
        
        // Update the record in the Notifications table.
        
        // Get the components of this date/time
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:fireDatePossible];
        rec.fireYear = [components year];
        rec.fireMonth = [components month];
        rec.fireDay = [components day];
        rec.fireHour = [components hour];
        rec.fireMinute = [components minute];
        
        // Clear generated flag.
        rec.alertWasGenerated = 0;
        
    }
    
    
    // Save this record in the Notifications table.
    // The return value is the record id, as written to the Notifications table.
    rec.idRecord = [[CDatabaseInterface sharedManager] saveNotification:rec];
    
    
    // Register a notification.
    [self scheduleNotification:rec];
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) scheduleNotification:(Notifications_Rec*) rec
{
    
    // Get a NSDate object from the components of the notification datum
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:rec.fireMinute];
    [components setHour:rec.fireHour];
    [components setDay:rec.fireDay];
    [components setMonth:rec.fireMonth];
    [components setYear:rec.fireYear];
    NSDate *fireDate = [c dateFromComponents:components];
    
    // Allocate a working UILocalNotification object.
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    // Return if it was not properly allocated and initialized.
    if (localNotif == nil)
    {
        return;
    }
    
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    
    localNotif.alertAction = @"View";           // Show "View" on the slider to unlock when event fires.
    localNotif.soundName = UILocalNotificationDefaultSoundName; // Specifies using the default sound.
    // *************** test code ***************
    NSInteger b2 = [UIApplication sharedApplication].applicationIconBadgeNumber;
    // *****************************************
    
    localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;  // Display this as the icon's badge.
    
    NSDictionary *infoDict = nil;
    
    if ([rec.type isEqualToString:@"PROD"])
    {
        // Specify the notification characteristics
        localNotif.alertBody = @"This is a suggestion to adjust your TinyShifts app schedule settings for next week.";    // This is what is displayed at the top of the screen when the notification fires and the app is suspended.
        
        // Specify custom data for the notification.
        infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"PROD", @"Notification_Type",
                    [NSString stringWithFormat:@"%ld",(long)rec.idRecord], @"Notification_RecordID",
                    nil];
    }
    else if ([rec.type isEqualToString:@"SUGG"])
    {
        // Specify the notification characteristics
        localNotif.alertBody = @"This is a suggestion to play a video in the TinyShifts app.";    // This is what is displayed at the top of the screen when the notification fires and the app is suspended.
        
        // Specify custom data for the notification.
        infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"SUGG", @"Notification_Type",
                    [NSString stringWithFormat:@"%ld",(long)rec.idRecord], @"Notification_RecordID",
                    nil];
    }
    
    
    localNotif.userInfo = infoDict;
    
    
    //------------------------------  Schedule the local notification  --------------------------
    NSLog(@"Prior to scheduling a notification:");
    [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    NSLog(@"After to scheduling a notification:");
    [self showAllLocalNotifications];   // display characteristics of all scheduled local notifications

    
    
//    // Save this record in the Notifications table.
//    [[CDatabaseInterface sharedManager] saveNotification:rec];
    
    
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSDate*) getDateSunday
{
    // Calculate and return a pointer to the NSDate object corresponding to 12:00 a.m. Sunday of the current week.
    
    // Get today's date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = (int)[components weekday];  // today's day of the week: 1=Sunday, 2=Monday, etc.
    
    // Get the NSDate object for now
    NSDate* now = [NSDate date];
    
    // Get the components of this date/time
    components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSInteger nowHour = [components hour];
    NSInteger nowMinute = [components minute];
    NSInteger nowSecond = [components second];
    NSInteger secondsBeforeNow = nowSecond + (60 * (nowMinute + 60 * (nowHour + 24 * (weekday-1))));    // number of seconds between 12:00 a.m. Sunday and now.
    NSTimeInterval dTime = (NSTimeInterval) (-secondsBeforeNow);
    
    // Get the NSDate object for 12:00 a.m. Sunday
    NSDate* dateSunday = [NSDate dateWithTimeInterval:dTime sinceDate:now];
    
    return dateSunday;
    
}



@end
