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
@property (nonatomic, strong) NSString* dateRecord;     // date of record creation
@property (nonatomic, strong) NSString* timeRecord;     // time of record creation
@property (nonatomic, strong) NSString* gender;         // gender of participant
@property NSInteger genderIdxSelected;                  // key to user's gender
@property NSInteger age;                                // age of participant (years)
@property NSInteger ethnicity;                          // key identifying ethnicity of participant
@property NSInteger didTransmitThisRecord;              // flag indicating whether this record has been received by the remote DB

+(PersonalData_Rec*) sharedManager;
-(void)clearData;

@end
