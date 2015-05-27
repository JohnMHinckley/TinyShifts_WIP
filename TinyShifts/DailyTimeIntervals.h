//
//  DailyTimeIntervals.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/22/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyTimeIntervals : NSObject
@property NSInteger start_hour;                         // hour component of start time interval
@property NSInteger start_minute;                       // minute component of start time interval
@property (nonatomic, strong) NSString* interval_name;  // name of the time interval
@property BOOL bAvailable;                              // flag, YES=can generate notifications during this interval, NO=do not generate them here
@end
