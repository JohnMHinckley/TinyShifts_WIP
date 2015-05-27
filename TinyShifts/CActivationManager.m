//
//  CActivationManager.m
//  NaturePill
//
//  Created by Dr. John M. Hinckley on 5/26/14.
//  Copyright (c) 2014 Gurmentor Inc. All rights reserved.
//

#import "CActivationManager.h"
#import "CDatabaseInterface.h"

@implementation CActivationManager

static CActivationManager* sharedSingleton = nil;   // single, static instance of this class



+(CActivationManager*) sharedManager
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


-(id) init
{
    if (nil == [super init])
    {
        return nil;
    }
    
    
    return self;
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(int) getActivationStatus
{
    // Get the activation status of the app.
    // This is read from the MyStatus table in the database.
    // If the value corresponding to the key "activated" is 0, the app is not activated: return a value of 0.
    // If the value is not 0, the app is activated: return a value of 1.
    int retVal = 0;
    
    retVal = [[CDatabaseInterface sharedManager] getActivationStatus];
    
    return retVal;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) attemptActivationWithCode:(NSString*)trialCode;
{
    // Test activation using input trialCode
    // return YES, if activation succeeds
    // return NO, if it does not.
    BOOL retVal = NO;
    
    NSString* participantCode = [[CDatabaseInterface sharedManager] getParticipantCodeWithMatchingActivation:trialCode];
    
    if (participantCode != nil)
    {
        // a matching activation code was found
        // the corresponding participant code is pointed to by participantCode.
        retVal = YES;
        
        [[CDatabaseInterface sharedManager] saveMyIdentityAs:participantCode];  // save the participant's id
        
        [[CDatabaseInterface sharedManager] saveAppActivationState:1];  // save flag indicating that app is activated.
    }
    
    return retVal;
}



@end
