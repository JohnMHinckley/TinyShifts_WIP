//
//  RDB_DeviceData.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_DeviceData.h"
#import "DeviceData_Rec.h"

@implementation RDB_DeviceData

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize deviceMfg;
@synthesize deviceModel;
@synthesize osVersion;
@synthesize totalMemory;
@synthesize availMemory;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord        = [DeviceData_Rec sharedManager].idRecord;
    participantId   = [DeviceData_Rec sharedManager].participantId;
    dateRecord            = [DeviceData_Rec sharedManager].dateRecord;
    timeRecord            = [DeviceData_Rec sharedManager].timeRecord;
    deviceMfg       = [DeviceData_Rec sharedManager].deviceMfg;
    deviceModel     = [DeviceData_Rec sharedManager].deviceModel;
    osVersion       = [DeviceData_Rec sharedManager].osVersion;
    totalMemory     = [DeviceData_Rec sharedManager].totalMemory;
    availMemory     = [DeviceData_Rec sharedManager].availMemory;
    
    return self;
    
}



@end
