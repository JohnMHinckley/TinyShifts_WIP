//
//  RandomVideoPlayActivity_Rec.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RandomVideoPlayActivity_Rec.h"

@implementation RandomVideoPlayActivity_Rec

@synthesize idRecord;
@synthesize participantId;
@synthesize date;
@synthesize time;
@synthesize videoShown;
@synthesize dateStartVideoPlay;
@synthesize timeStartVideoPlay;
@synthesize dateEndVideoPlay;
@synthesize timeEndVideoPlay;
@synthesize didTransmitThisRecord;



//---------------------------------------------------------------------------------------------------------------------------------



static RandomVideoPlayActivity_Rec* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(RandomVideoPlayActivity_Rec*) sharedManager
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
    date = [[NSMutableString alloc] initWithString:@""];
    time = [[NSMutableString alloc] initWithString:@""];
    dateStartVideoPlay = [[NSMutableString alloc] initWithString:@""];
    timeStartVideoPlay = [[NSMutableString alloc] initWithString:@""];
    dateEndVideoPlay = [[NSMutableString alloc] initWithString:@""];
    timeEndVideoPlay = [[NSMutableString alloc] initWithString:@""];
    
    [self clearData];
    
    return self;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void)clearData
{
    // Clear or initialize all data values
    
    idRecord                = 0;
    participantId           = @"";
    date                    = @"";
    time                    = @"";
    videoShown              = 0;
    dateStartVideoPlay      = @"";
    timeStartVideoPlay      = @"";
    dateEndVideoPlay        = @"";
    timeEndVideoPlay        = @"";
    didTransmitThisRecord   = 0;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
