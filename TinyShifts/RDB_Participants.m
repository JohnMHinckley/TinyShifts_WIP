//
//  RDB_Participants.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_Participants.h"

@implementation RDB_Participants
@synthesize idParticipantCode;
@synthesize activationCode;
@synthesize participantName;
@synthesize eMailAddress;

-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    // These data are used for making a test record in the RDB_Participants table
    idParticipantCode = @"_developer1";
    activationCode = @"abc";
    participantName = @"John M. Hinckley";
    eMailAddress = @"ncko@umich.edu";
    
    return self;
    
}


@end
