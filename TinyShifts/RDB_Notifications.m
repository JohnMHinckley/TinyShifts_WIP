//
//  RDB_Notifications.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "RDB_Notifications.h"
#import "Notifications_Rec.h"

@implementation RDB_Notifications

@synthesize idRecord;
@synthesize participantId;
@synthesize dateGenerated;
@synthesize timeGenerated;
@synthesize fireYear;
@synthesize fireMonth;
@synthesize fireDay;
@synthesize fireHour;
@synthesize fireMinute;
@synthesize wasGenerated;
@synthesize responseWasStartApp;
@synthesize responseWasPostpone;
@synthesize responseWasDismiss;
@synthesize numberRemainingNotifications;
//@synthesize didTransmitThisRecord;


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    idRecord                        = [Notifications_Rec sharedManager].idRecord;
    participantId                   = [Notifications_Rec sharedManager].participantId;
    dateGenerated                   = [Notifications_Rec sharedManager].dateGenerated;
    timeGenerated                   = [Notifications_Rec sharedManager].timeGenerated;
    fireYear                        = [Notifications_Rec sharedManager].fireYear;
    fireMonth                       = [Notifications_Rec sharedManager].fireMonth;
    fireDay                         = [Notifications_Rec sharedManager].fireDay;
    fireHour                        = [Notifications_Rec sharedManager].fireHour;
    fireMinute                      = [Notifications_Rec sharedManager].fireMinute;
    wasGenerated                    = [Notifications_Rec sharedManager].wasGenerated;
    responseWasStartApp             = [Notifications_Rec sharedManager].responseWasStartApp;
    responseWasPostpone             = [Notifications_Rec sharedManager].responseWasDismiss;
    responseWasDismiss              = [Notifications_Rec sharedManager].responseWasPostpone;
    numberRemainingNotifications    = [Notifications_Rec sharedManager].numberRemainingNotifications;

    return self;
    
}



@end
