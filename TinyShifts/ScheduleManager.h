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
}

+(ScheduleManager*) sharedManager;

-(NSDate*) getNextRandomEventTime;
-(void) updateSchedule;
-(void)showAllLocalNotifications;

-(NSInteger) getTotalNumberEvents;
-(void) setTotalNumberEvents:(int)n;

-(NSInteger) getNumberDoneEvents;
-(void) setNumberDoneEvents:(int)n;

-(void) setNextLocalNotification;


@end
