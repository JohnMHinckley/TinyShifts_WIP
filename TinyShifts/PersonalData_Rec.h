//
//  PersonalData_Rec.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalData_Rec : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* date;           // date of record creation
@property (nonatomic, strong) NSString* time;           // time of record creation
@property NSInteger gender;                             // key identifying gender of participant
@property NSInteger age;                                // age of participant (years)
@property NSInteger ethnicity;                          // key identifying ethnicity of participant
@property NSInteger didTransmitThisRecord;              // flag indicating whether this record has been received by the remote DB

+(PersonalData_Rec*) sharedManager;
-(void)clearData;

@end
