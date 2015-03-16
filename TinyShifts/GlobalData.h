//
//  GlobalData.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
@property int moodMeterSelection;   // initial mood meter response
@property int moodTableSelection;   // selection from both unpleasant and pleasant mood tables
@property int selectedVideo;        // index of video to be viewed
@property int wantResourceInfo1;    // wants resource info, first time asked.
@property int wantResourceInfo2;    // wants resource info, second time asked.
@property int videoWasHelpful;      // was the video helpful?
@property int videoWatchAgain;      // watch it again?
@property int videoRecommend;       // recommend it?

+(GlobalData*) sharedManager;

+(float) RandomNumberUpTo:(float) upperLimit;
+(int) RandomIntUpTo:(int) upperLimit;

@end
