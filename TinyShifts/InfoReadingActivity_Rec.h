//
//  InfoReadingActivity_Rec.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoReadingActivity_Rec : NSObject

@property NSInteger idRecord;                               // identifies specific notification
@property (nonatomic, strong) NSString* participantId;      // id of participant
@property NSInteger infoPageRead;                           // identity of information page read
@property (nonatomic, strong) NSString* dateStartReading;   // date that info page started to be read
@property (nonatomic, strong) NSString* timeStartReading;   // time that info page started to be read
@property (nonatomic, strong) NSString* dateEndReading;     // date that ended being read
@property (nonatomic, strong) NSString* timeEndReading;     // time that ended being read
@property NSInteger didTransmitThisRecord;                  // flag indicating whether this record has been received by the remote DB

+(InfoReadingActivity_Rec*) sharedManager;
-(void)clearData;

@end
