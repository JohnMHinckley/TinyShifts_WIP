//
//  GlobalData.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "GlobalData.h"
@import Security;

@implementation GlobalData
@synthesize gender;
@synthesize genderIdxSelected;
@synthesize age;
@synthesize ethnicity;
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




@end
