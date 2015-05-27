//
//  DeviceData_Rec.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "DeviceData_Rec.h"

@implementation DeviceData_Rec

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize deviceMfg;
@synthesize deviceModel;
@synthesize osVersion;
@synthesize totalMemory;
@synthesize availMemory;
@synthesize didTransmitThisRecord;



//---------------------------------------------------------------------------------------------------------------------------------



static DeviceData_Rec* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(DeviceData_Rec*) sharedManager
{
    // Returns a pointer to the shared singleton of this class.
    // If the singleton has not yet been allocated and initialized, it will be done here.
    
    if (nil == sharedSingleton)
    {
        // The singleton has not yet been created, so allocate and initialize it here.
        // This is done only once in the program.
        
        sharedSingleton = [[super alloc] init];
        
    }
    else
    {
        // The singleton has already been created, so do nothing more here.
        // Just return the existing non-null pointer.
    }
    return sharedSingleton;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id) init
{
    participantId = [[NSMutableString alloc] initWithString:@""];
    dateRecord = [[NSMutableString alloc] initWithString:@""];
    timeRecord = [[NSMutableString alloc] initWithString:@""];
    deviceMfg = [[NSMutableString alloc] initWithString:@""];
    deviceModel = [[NSMutableString alloc] initWithString:@""];
    osVersion = [[NSMutableString alloc] initWithString:@""];
    totalMemory = [[NSMutableString alloc] initWithString:@""];
    availMemory = [[NSMutableString alloc] initWithString:@""];
    
    [self clearData];
    
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void)clearData
{
    // Clear or initialize all data values
    
    idRecord                = 0;
    participantId           = @"";
    dateRecord                    = @"";
    timeRecord                    = @"";
    deviceMfg               = @"";
    deviceModel             = @"";
    osVersion               = @"";
    totalMemory             = @"";
    availMemory             = @"";
    didTransmitThisRecord   = 0;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
