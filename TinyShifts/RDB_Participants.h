//
//  RDB_Participants.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDB_Participants : NSObject

@property (nonatomic, strong) NSString* idParticipantCode;
@property (nonatomic, strong) NSString* activationCode;
@property (nonatomic, strong) NSString* participantName;
@property (nonatomic, strong) NSString* eMailAddress;

@end
