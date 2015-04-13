//
//  RDB_PersonalData.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_PersonalData.h"
#import "PersonalData_Rec.h"

@implementation RDB_PersonalData

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize gender;
@synthesize age;
@synthesize ethnicity;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord        = [PersonalData_Rec sharedManager].idRecord;
    participantId   = [PersonalData_Rec sharedManager].participantId;
    dateRecord            = [PersonalData_Rec sharedManager].dateRecord;
    timeRecord            = [PersonalData_Rec sharedManager].timeRecord;
    gender          = [PersonalData_Rec sharedManager].gender;
    age             = [PersonalData_Rec sharedManager].age;
    ethnicity       = [PersonalData_Rec sharedManager].ethnicity;
    
    return self;
    
}


@end
