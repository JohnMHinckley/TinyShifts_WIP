//
//  ConstGen.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#ifndef TinyShifts_ConstGen_h
#define TinyShifts_ConstGen_h

// Keys for "Gender"
#define GENDER_FEMALE   1
#define GENDER_MALE     2
#define GENDER_OTHER    3

// Keys for "Ethnicity"
#define ETHNICITY_ASIAN     1
#define ETHNICITY_BLACK     2
#define ETHNICITY_HISPANIC  3
#define ETHNICITY_WHITE     4
#define ETHNICITY_OTHER     5

// Keys for "Time of Day"
#define TOD_ANYTIME     1
#define TOD_MORNING     2
#define TOD_NOON        3
#define TOD_AFTERNOON   4
#define TOD_EVENING     5

// Keys for "Mood meter"
#define MOOD_METER_BLUE     1
#define MOOD_METER_RED      2
#define MOOD_METER_GREEN    3
#define MOOD_METER_YELLOW   4

// Keys for "Mood selection"
// First, unpleasant moods
#define MOOD_U_RELATIONSHIP_PROBLEMS    1
#define MOOD_U_FEEL_DOWN                2
#define MOOD_U_PRESSURE                 3
#define MOOD_U_LONELY                   4
#define MOOD_U_NOT_GOOD_ENOUGH          5
#define MOOD_U_NOT_LIKE_LOOKS           6
#define MOOD_U_WORRY                    7
#define MOOD_U_OTHER                    8
// Second, continuing with pleasant moods.
#define MOOD_P_RELATIONSHIPS            9
#define MOOD_P_STRESS                   10
#define MOOD_P_WORRY                    11
#define MOOD_P_INSECURITIES             12
#define MOOD_P_SUPPORTING               13

// Keys for "Want resource info?" first time asked
#define WANT_RESOURCE_INFO_1_YES   1
#define WANT_RESOURCE_INFO_1_NO    0

// Keys for "Want resource info?" second time asked
#define WANT_RESOURCE_INFO_2_YES   1
#define WANT_RESOURCE_INFO_2_NO    0

// Keys for videos
#define VIDEO_UNDEFINED         -1
#define VIDEO_FIREFLIES         0
#define VIDEO_SLOPPYJOE         1
#define VIDEO_711               2
#define VIDEO_TREADINGWATER     3
#define VIDEO_TRAPPED           4
#define VIDEO_POTATOHEAD        5
#define VIDEO_TREADMILL         6
#define VIDEO_DAURY             7
#define VIDEO_BALLOON           8

// Keys for "Video was helpful?"
#define VIDEO_WAS_HELPFUL_YES   1
#define VIDEO_WAS_HELPFUL_NO    0
#define VIDEO_WAS_HELPFUL_DONTKNOW  -1

// Keys for "Video watch again?"
#define VIDEO_WATCH_AGAIN_YES   1
#define VIDEO_WATCH_AGAIN_NO    0

// Keys for "Video recommend?"
#define VIDEO_RECOMMEND_YES   1
#define VIDEO_RECOMMEND_NO    0


// Keys for Activated
#define ACTIVATED_YES    1
#define ACTIVATED_NO     0


// Keys for Initial Pass
#define INITIAL_PASS_YES    1
#define INITIAL_PASS_NO     0





//----------------------------------------------------------------------------------------
// Backendless parameters

// HRC values
// email = John@HinckleyResearch.com
// pw = wiggleworm55.

#define BackendlessApplicationID    @"B67AC089-B3B9-6FEE-FFD0-9D6432DAC700"
#define BackendlessIOSSecretKey     @"EB5A2BEF-5804-C9EC-FF45-E7EBBF016500"
#define BackendlessApplicationVer   @"v1"


// SPH values:
// email = tinyshifts@umich.edu
// pw = ?
/*
 #define BackendlessApplicationID    @"0AB623A6-8BD0-1333-FF89-FD667FC95F00"
 #define BackendlessIOSSecretKey     @"255693E8-09D7-8734-FFD4-11FE129E2300"
 #define BackendlessApplicationVer   @"v1"
 */

//----------------------------------------------------------------------------------------




#endif
