//
//  RDB_InfoReadingActivity.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_InfoReadingActivity.h"
#import "InfoReadingActivity_Rec.h"

@implementation RDB_InfoReadingActivity

@synthesize idRecord;
@synthesize participantId;
@synthesize infoPageRead;
@synthesize dateStartReading;
@synthesize timeStartReading;
@synthesize dateEndReading;
@synthesize timeEndReading;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord            = [InfoReadingActivity_Rec sharedManager].idRecord;
    participantId       = [InfoReadingActivity_Rec sharedManager].participantId;
    infoPageRead        = [InfoReadingActivity_Rec sharedManager].infoPageRead;
    dateStartReading    = [InfoReadingActivity_Rec sharedManager].dateStartReading;
    timeStartReading    = [InfoReadingActivity_Rec sharedManager].timeStartReading;
    dateEndReading      = [InfoReadingActivity_Rec sharedManager].dateEndReading;
    timeEndReading      = [InfoReadingActivity_Rec sharedManager].timeEndReading;
    
    return self;
    
}



@end
