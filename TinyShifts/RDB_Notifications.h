//
//  RDB_Notifications.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDB_Notifications : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* dateGenerated;  // date that scheduled notification fired
@property (nonatomic, strong) NSString* timeGenerated;  // time that scheduled notification fired
@property NSInteger fireYear;                           // year part of firing date/time of a scheduled notification
@property NSInteger fireMonth;                          // month part
@property NSInteger fireDay;                            // day part
@property NSInteger fireHour;                           // hour part
@property NSInteger fireMinute;                         // minute part
@property NSInteger wasGenerated;                       // logical flag, 1 when this prompt has been generated
@property NSInteger responseWasStartApp;                // participant started app in response to prompt
@property NSInteger responseWasPostpone;                // participant postponed app in response to prompt
@property NSInteger responseWasDismiss;                 // participant dismissed app in response to prompt
@property NSInteger numberRemainingNotifications;       // number of notifications remaining for current week, after this one fires
//@property NSInteger didTransmitThisRecord;              // flag indicating whether this record has been received by the remote DB

@end
