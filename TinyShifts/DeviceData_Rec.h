//
//  DeviceData_Rec.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceData_Rec : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* dateRecord;           // date of record creation
@property (nonatomic, strong) NSString* timeRecord;           // time of record creation
@property (nonatomic, strong) NSString* deviceMfg;      // device manufacturer
@property (nonatomic, strong) NSString* deviceModel;    // device model
@property (nonatomic, strong) NSString* osVersion;      // operating system version
@property (nonatomic, strong) NSString* totalMemory;    // total memory in device
@property (nonatomic, strong) NSString* availMemory;    // available memory in device
@property NSInteger didTransmitThisRecord;              // flag indicating whether this record has been received by the remote DB

+(DeviceData_Rec*) sharedManager;
-(void)clearData;

@end
