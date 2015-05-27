//
//  RDB_ContactActivity.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_ContactActivity.h"
#import "ContactActivity_Rec.h"

@implementation RDB_ContactActivity

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;



-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord            = [ContactActivity_Rec sharedManager].idRecord;
    participantId       = [ContactActivity_Rec sharedManager].participantId;
    dateRecord                = [ContactActivity_Rec sharedManager].dateRecord;
    timeRecord                = [ContactActivity_Rec sharedManager].timeRecord;
    
    return self;
    
}


@end
