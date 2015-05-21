//
//  Notifications_Rec.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "Notifications_Rec.h"

@implementation Notifications_Rec

@synthesize idRecord;
@synthesize participantId;
@synthesize type;
@synthesize fireYear;
@synthesize fireMonth;
@synthesize fireDay;
@synthesize fireHour;
@synthesize fireMinute;
@synthesize alertWasGenerated;



//---------------------------------------------------------------------------------------------------------------------------------



static Notifications_Rec* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(Notifications_Rec*) sharedManager
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
    type = [[NSMutableString alloc] initWithString:@""];
    
    [self clearData];
    
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void)clearData
{
    // Clear or initialize all data values

    idRecord = 0;
    participantId = @"";
    type = @"";
    fireYear = 0;
    fireMonth = 0;
    fireDay = 0;
    fireHour = 0;
    fireMinute = 0;
    alertWasGenerated = 0;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
