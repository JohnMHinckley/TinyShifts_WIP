//
//  RDB_DailyTimeIntervals.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/21/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDB_DailyTimeIntervals : NSObject
@property NSInteger start_hour;                         // hour component of start time interval
@property NSInteger start_minute;                       // minute component of start time interval
@property (nonatomic, strong) NSString* interval_name;  // name of the time interval


@end
