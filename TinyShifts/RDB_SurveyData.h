//
//  RDB_SurveyData.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 4/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDB_SurveyData : NSObject

@property NSInteger idRecord;                           // identifies specific notification
@property (nonatomic, strong) NSString* participantId;  // id of participant
@property (nonatomic, strong) NSString* date;           // date of record creation
@property (nonatomic, strong) NSString* time;           // time of record creation
@property NSInteger moodFeeling;                        // mood ranking from mood-meter
@property NSInteger moodEnergy;                         // energy ranking from mood-meter
@property NSInteger moodCode;                           // code for specific mood situation
@property NSInteger qWantResourceInfo1;                 // flag, 1 = participant wanted resource info at first offer
@property NSInteger videoShown;                         // key identifying which video was viewed
@property (nonatomic, strong) NSString* dateStartVideoPlay; // date of start video view
@property (nonatomic, strong) NSString* timeStartVideoPlay; // time of start video view
@property (nonatomic, strong) NSString* dateEndVideoPlay;   // date of end video view
@property (nonatomic, strong) NSString* timeEndVideoPlay;   // time of end video view
@property NSInteger qVideoHelpful;                      // flag, 1 = participant thinks video is helpful
@property NSInteger qVideoWatchAgain;                   // flag, 1 = participant would watch it again
@property NSInteger qVideoRecommend;                    // flag, 1 = participant would recommend it
@property NSInteger qWantResourceInfo2;                 // flag, 1 = participant wanted resource info at second offer

@end
