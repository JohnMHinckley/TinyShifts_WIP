//
//  GlobalData.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalData : NSObject  <UIAlertViewDelegate>
@property (nonatomic, strong) NSString* gender;             // user's gender
@property int genderIdxSelected;                            // key to user's gender
@property int age;                  // user's age
@property int ethnicity;            // user's ethnicity
@property BOOL bUseGoogleCal;        // flag: YES if using Google calendar
@property int frequency;            // number of times per week for recommendation
//@property int timeOfDay;            // preferred time of day for recommendation
@property int timeOfDayAvailMorning;    // user is available in morning for recommendation
@property int timeOfDayAvailNoon;       // user is available in noon period for recommendation
@property int timeOfDayAvailAfternoon;  // user is available in afternoon for recommendation
@property int timeOfDayAvailEvening;    // user is available in evening for recommendation
@property int moodMeterSelection;   // initial mood meter response
@property int moodTableSelection;   // selection from both unpleasant and pleasant mood tables
@property int selectedVideo;        // index of video to be viewed
@property int wantResourceInfo1;    // wants resource info, first time asked.
@property (nonatomic, strong) NSString* dateStartVideoPlay; // date of start video view
@property (nonatomic, strong) NSString* timeStartVideoPlay; // time of start video view
@property (nonatomic, strong) NSString* dateEndVideoPlay;   // date of end video view
@property (nonatomic, strong) NSString* timeEndVideoPlay;   // time of end video view
@property int wantResourceInfo2;    // wants resource info, second time asked.
@property int videoWasHelpful;      // was the video helpful?
@property int videoWatchAgain;      // watch it again?
@property int videoRecommend;       // recommend it?

@property int activated;            // is or is not activated?
@property int initialPass;          // is or is not initial use of app?

@property BOOL bVideoDidPlay;       // flag: YES if video played when play video screen was presented.

@property int remainingNumberRecommendationsThisWeek;   // number of recommendation events remaining to be done this week

@property UITabBarController* theTabBarController;

+(GlobalData*) sharedManager;

+(float) RandomNumberUpTo:(float) upperLimit;
+(int) RandomIntUpTo:(int) upperLimit;
+(NSString*) getAppInfoStringValueForKey:(NSString*) skey;
+(NSInteger) getAppInfoIntegerValueForKey:(NSString*) skey;
//+(BOOL) setAppInfoStringValue:(NSString*) sstr ForKey:(NSString*) skey;
//+(BOOL) setAppInfoIntegerValue:(NSInteger) nvalue ForKey:(NSString*) skey;

@end
