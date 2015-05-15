//
//  GlobalData.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "GlobalData.h"
#import "Schedule_Rec.h"
#import "RDB_Schedule.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"
@import Security;

@implementation GlobalData
@synthesize gender;
@synthesize genderIdxSelected;
@synthesize age;
@synthesize ethnicity;
@synthesize bUseGoogleCal;
@synthesize frequency;
//@synthesize timeOfDay;
@synthesize timeOfDayAvailMorning;
@synthesize timeOfDayAvailNoon;
@synthesize timeOfDayAvailAfternoon;
@synthesize timeOfDayAvailEvening;
@synthesize moodMeterSelection;
@synthesize moodTableSelection;
@synthesize selectedVideo;
@synthesize wantResourceInfo1;
@synthesize dateStartVideoPlay;
@synthesize timeStartVideoPlay;
@synthesize dateEndVideoPlay;
@synthesize timeEndVideoPlay;
@synthesize wantResourceInfo2;
@synthesize videoWasHelpful;
@synthesize videoWatchAgain;
@synthesize videoRecommend;
@synthesize activated;
@synthesize initialPass;
@synthesize remainingNumberRecommendationsThisWeek;
@synthesize bVideoDidPlay;

static GlobalData* sharedSingleton = nil;   // single, static instance of this class



+(GlobalData*) sharedManager
{
    // Method returns a pointer to the shared singleton of this class.
    
    if (nil == sharedSingleton)
    {
        // Only if the singleton has not yet been allocated, is it allocated, here.
        // Thus, it is allocated only once in the program, i.e. it's a SINGLETON.
        sharedSingleton = [[super allocWithZone:NULL] init];
    }
    return sharedSingleton;
}


+(id)allocWithZone:(NSZone *)zone
{
    // NSObject method override.
    // Normally, returns a new instance of the receiving class.
    
    return [self sharedManager];
}

-(id)copyWithZone:(NSZone*) zone
{
    // NSObject method override.
    // Normally, returns the receiver.
    
    return self;
}


+(float) RandomNumberUpTo:(float) upperLimit
{
    // Return a pseudo-random number in the range [0, upperLimit).
    
    float retval = 0.0; // returned value
    
    uint8_t bytes[4];
    
    SecRandomCopyBytes(kSecRandomDefault, 4, bytes);
    
    // Construct a single 32-bit integer from these four bytes.
    uint32_t nR = (bytes[0]<<24) + (bytes[1]<<16) + (bytes[2]<<8) + bytes[3];
    
    uint32_t max32 = -1;    // 2^32 - 1
    
    // Take the floating point ratio of the pseudo-random integer nR to 2^32 - 1
    float fR = (float) nR / (float) max32;
    
    // Scale this number by the upperLimit
    retval = fR * upperLimit;
    
    return  retval;
}



+(int) RandomIntUpTo:(int) upperLimit
{
    // Return a pseudo-random integer in the range [0, upperLimit-1].
    
    int retval = 0; // returned value
    
    // Cast the upper limit as a float and call for a floating point pseudo-random number.
    float fUpperLimit = (float) upperLimit;
    float fR = [self RandomNumberUpTo:fUpperLimit]; // this is a floating point number in the range [0, upperLimit).
    
    // cast the result as an integer and return.
    retval = (int) fR;
    
    
    return retval;
}



//---------------------------------------------------------------------------------------------------------------------------------



+(NSString*) getAppInfoStringValueForKey:(NSString*) skey
{
    // Read the string value from the AppInfo property list corresponding to the input key skey.
    
    // If the path to the AppInfo property list is determined, and
    // if the property list exists, and
    // if the string value corresponding to skey is found in the list,
    // then return the value.
    
    // Otherwise, return nil.
    
    
    
    NSString* value = nil;   // Initialize the value.
    
    
    
    // Get the path for the AppInfo property list.
    NSString* pathToAppInfoPList = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    
    
    if (nil != pathToAppInfoPList)  // was the path for the AppInfo property list found?
    {
        // yes, it was found.
        
        
        // Check that property list file exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathToAppInfoPList])   // was the AppInfo property list found?
        {
            // yes, it was found.
            
            // Load the property list into a dictionary.
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:pathToAppInfoPList];
            
            
            // Get the value from the dictionary,
            // as the value corresponding to the key skey.
            value = [NSString stringWithFormat:@"%@",[dic valueForKey:skey]];
            
            
            if (nil != value)
            {
                // Apparently OK, some kind of string was read.
            }
            else
            {
                // No valid string was read from the property list.
                NSLog(@"*** Warning: value not found in GlobalData::getAppInfoStringValueForKey.  Returning nil.");
            }
        }
        else
        {
            // AppInfo property list not found.
            NSLog(@"*** Warning: AppInfo property list not found in GlobalData::getAppInfoStringValueForKey.");
            NSLog(@"Returning nil.");
        }
    }
    else
    {
        // Path for AppInfo property list not found.
        NSLog(@"*** Warning: Path for AppInfo property list not found in GlobalData::getAppInfoStringValueForKey.");
        NSLog(@"Returning nil.");
    }
    
    
    
    return value;
}



//---------------------------------------------------------------------------------------------------------------------------------



+(NSInteger) getAppInfoIntegerValueForKey:(NSString*) skey
{
    // Read the NSInteger value from the AppInfo property list corresponding to the input key skey.
    
    // If the path to the AppInfo property list is determined, and
    // if the property list exists, and
    // if the integer value corresponding to skey is found in the list,
    // then return the value.
    
    // Otherwise, return -999999.
    
    
    
    NSInteger value = -999999;   // Initialize the value.
    
    
    
    // Get the path for the AppInfo property list.
    NSString* pathToAppInfoPList = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    
    
    if (nil != pathToAppInfoPList)  // was the path for the AppInfo property list found?
    {
        // yes, it was found.
        
        
        // Check that property list file exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathToAppInfoPList])   // was the AppInfo property list found?
        {
            // yes, it was found.
            
            // Load the property list into a dictionary.
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:pathToAppInfoPList];
            
            
            // Get the value from the dictionary,
            // as the value corresponding to the key skey.
            //value = [NSString stringWithFormat:@"%@",[dic valueForKey:skey]];
            value = [[NSString stringWithFormat:@"%@",[dic valueForKey:skey]] integerValue];
            
            
            if (-999999 != value)
            {
                // Apparently OK, some kind of string was read.
            }
            else
            {
                // No valid string was read from the property list.
                NSLog(@"*** Warning: value not found in GlobalData::getAppInfoIntegerValueForKey.  Returning -999999.");
            }
        }
        else
        {
            // AppInfo property list not found.
            NSLog(@"*** Warning: AppInfo property list not found in GlobalData::getAppInfoIntegerValueForKey.");
            NSLog(@"Returning -999999.");
        }
    }
    else
    {
        // Path for AppInfo property list not found.
        NSLog(@"*** Warning: Path for AppInfo property list not found in GlobalData::getAppInfoIntegerValueForKey.");
        NSLog(@"Returning -999999.");
    }
    
    
    
    return value;
}



//---------------------------------------------------------------------------------------------------------------------------------



- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    //    if (actionSheet == responseAlert)
    {
        
        // the user clicked one of the alert buttons
        
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if ([title isEqualToString:@"Save"])
        {
            NSLog(@"Save schedule changes.");
            [self sendSchedule];
        }
        else if ([title isEqualToString:@"Discard"])
        {
            NSLog(@"Discard schedule changes.");
        }
        
    }
    
    
}








-(void) sendSchedule
{
    // Record part of the database record for Schedule.
    
    Schedule_Rec* rec2 = [Schedule_Rec sharedManager];
    
    rec2.idRecord++; // increment the record id
    
    rec2.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
    // Get the current date and time and save these in the InfoReadingActivity_Rec object.
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    
    //date formatter with just date and no time
    dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    //date formatter with no date and just time
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
    
    rec2.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec2.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    rec2.bUseGoogleCalendar = [GlobalData sharedManager].bUseGoogleCal;
    
    rec2.weeklyFrequency = [GlobalData sharedManager].frequency;
    
    rec2.availableMorning = [GlobalData sharedManager].timeOfDayAvailMorning;
    rec2.availableNoon = [GlobalData sharedManager].timeOfDayAvailNoon;
    rec2.availableAfternoon = [GlobalData sharedManager].timeOfDayAvailAfternoon;
    rec2.availableEvening = [GlobalData sharedManager].timeOfDayAvailEvening;
    
    
    
    // Save the schedule record to the local database.
    [[CDatabaseInterface sharedManager] saveSchedule:rec2];
    
    
    
    
    // Send the schedule to the remote database.
    
    Responder* responder2 = [Responder responder:self
                              selResponseHandler:@selector(responseHandlerSendSchedule:)
                                 selErrorHandler:@selector(errorHandler:)];
    
    RDB_Schedule* record2 = [[RDB_Schedule alloc] init];
    
    id<IDataStore> dataStore2 = [backendless.persistenceService of:[RDB_Schedule class]];
    
    [dataStore2 save:record2 responder:responder2];
    
    
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendSchedule:(id)response
{
    NSLog(@"Response Handler for send Schedule: Response = %@", response);
    
    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------








@end
