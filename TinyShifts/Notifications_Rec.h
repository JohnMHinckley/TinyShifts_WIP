//
//  Notifications_Rec.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notifications_Rec : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* type;           // type of notification: e.g. @"SUGG" or @"PROD"
@property NSInteger fireYear;                           // year part of firing date/time of a scheduled notification
@property NSInteger fireMonth;                          // month part
@property NSInteger fireDay;                            // day part
@property NSInteger fireHour;                           // hour part
@property NSInteger fireMinute;                         // minute part
@property NSInteger alertWasGenerated;                  // logical flag, 1 when corresponding alert message has been generated

+(Notifications_Rec*) sharedManager;
-(void)clearData;

@end
