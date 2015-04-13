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
@synthesize age;
@synthesize ethnicity;
@synthesize frequency;
@synthesize timeOfDay;
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



@end
