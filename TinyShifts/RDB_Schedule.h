//
//  RDB_Schedule.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDB_Schedule : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* date;           // date of record creation
@property (nonatomic, strong) NSString* time;           // time of record creation
@property NSInteger weeklyFrequency;                    // number of times per week for notifications
@property NSInteger availableMorning;                   // flag, 1 = participant is available in the morning for notifications
@property NSInteger availableNoon;                      // flag, 1 = participant is available in the around noon for notifications
@property NSInteger availableAfternoon;                 // flag, 1 = participant is available in the afternoon for notifications
@property NSInteger availableEvening;                   // flag, 1 = participant is available in the evening for notifications

@end
