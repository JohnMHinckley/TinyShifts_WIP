//
//  CActivationManager.h
//  NaturePill
//
//  Created by Dr. John M. Hinckley on 5/26/14.
//  Copyright (c) 2014 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CActivationManager : NSObject

+(CActivationManager*) sharedManager;
-(int) getActivationStatus;
-(BOOL) attemptActivationWithCode:(NSString*)trialCode;

@end
