//
//  RDB_RandomVideoPlayActivity.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_RandomVideoPlayActivity.h"
#import "RandomVideoPlayActivity_Rec.h"

@implementation RDB_RandomVideoPlayActivity

@synthesize idRecord;
@synthesize participantId;
@synthesize dateRecord;
@synthesize timeRecord;
@synthesize videoShown;
@synthesize dateStartVideoPlay;
@synthesize timeStartVideoPlay;
@synthesize dateEndVideoPlay;
@synthesize timeEndVideoPlay;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord            = [RandomVideoPlayActivity_Rec sharedManager].idRecord;
    participantId       = [RandomVideoPlayActivity_Rec sharedManager].participantId;
    dateRecord                = [RandomVideoPlayActivity_Rec sharedManager].dateRecord;
    timeRecord                = [RandomVideoPlayActivity_Rec sharedManager].timeRecord;
    videoShown          = [RandomVideoPlayActivity_Rec sharedManager].videoShown;
    dateStartVideoPlay  = [RandomVideoPlayActivity_Rec sharedManager].dateStartVideoPlay;
    timeStartVideoPlay  = [RandomVideoPlayActivity_Rec sharedManager].timeStartVideoPlay;
    dateEndVideoPlay    = [RandomVideoPlayActivity_Rec sharedManager].dateEndVideoPlay;
    timeEndVideoPlay    = [RandomVideoPlayActivity_Rec sharedManager].timeEndVideoPlay;
    
    return self;
    
}


@end
