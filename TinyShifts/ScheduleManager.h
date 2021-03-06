//
//  ScheduleManager.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/21/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleManager : NSObject
{
    NSMutableDictionary* timeIntervals;
    NSDate* dateMostRecentNotificationResponse;     // date/time of most recent user response to a local notification
    
    int previousWeekday;    // value of the weekday at the previous time that app was run (1=Sunday, 2=Monday, ..., 7=Saturday)
}

+(ScheduleManager*) sharedManager;

-(NSDate*) getNextRandomEventTime;
-(void) updateSchedule;
-(void)showAllLocalNotifications;

-(NSInteger) getTotalNumberEvents;
-(void) setTotalNumberEvents:(int)n;

-(NSInteger) getNumberDoneEvents;
-(void) setNumberDoneEvents:(int)n;

-(void) setNextLocalNotification:(NSInteger) badgeNumber;

-(NSDate*) getDateSunday;


@end
