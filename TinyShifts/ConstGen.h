//
//  ConstGen.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//


/* Modification log
 
 Date			Author			Action
 --------------------------------------------------------
 04-Apr-2016    J. M. Hinckley  Added mood key MOOD_U_OUT_OF_CONTROL and moved following keys down to make room for it. 
 */

#ifndef TinyShifts_ConstGen_h
#define TinyShifts_ConstGen_h





// --------------------- Code version ----------------
#define CODE_VERSION_DEVELOPMENT    0
#define CODE_VERSION_RELEASE        1
#define CODE_VERSION CODE_VERSION_RELEASE
// ---------------------------------------------------





#define maxnumItems 10      // maximum possible number of items (switches) on the screen





// Keys for "Gender"
#define GENDER_UNSPEC   0
#define GENDER_FEMALE   1
#define GENDER_MALE     2
#define GENDER_OTHER    3

// Keys for "Ethnicity"
#define ETHNICITY_UNSPEC    0
#define ETHNICITY_ASIAN     1
#define ETHNICITY_BLACK     2
#define ETHNICITY_HISPANIC  3
#define ETHNICITY_WHITE     4
#define ETHNICITY_OTHER     5

// Keys for "Time of Day"
#define TOD_UNSPEC      0
#define TOD_ANYTIME     1
#define TOD_MORNING     2
#define TOD_NOON        3
#define TOD_AFTERNOON   4
#define TOD_EVENING     5

// Keys for "Mood meter"
#define MOOD_METER_UNSPEC   0
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
#define MOOD_U_OUT_OF_CONTROL           8
#define MOOD_U_OTHER                    9
// Second, continuing with pleasant moods.
#define MOOD_P_RELATIONSHIPS            10
#define MOOD_P_STRESS                   11
#define MOOD_P_WORRY                    12
#define MOOD_P_INSECURITIES             13
#define MOOD_P_SUPPORTING               14

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
#define VIDEO_CHOOSEONETHING    9

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

#if CODE_VERSION == CODE_VERSION_DEVELOPMENT

#define ContactEMailAddress @"v8vette@gmail.com"

// HRC values
// email = John@HinckleyResearch.com
// pw = wiggleworm55.

#define BackendlessApplicationID    @"B67AC089-B3B9-6FEE-FFD0-9D6432DAC700"
#define BackendlessIOSSecretKey     @"EB5A2BEF-5804-C9EC-FF45-E7EBBF016500"
#define BackendlessApplicationVer   @"v1"


#elif CODE_VERSION == CODE_VERSION_RELEASE

#define ContactEMailAddress @"tinyshifts@umich.edu"

// SPH values:
// app name = "TinyShifts1"
// email = tinyshifts@umich.edu
// pw = TSapp2015

 #define BackendlessApplicationID    @"BEBF8BC3-0234-9634-FF36-8B8861B08100"
 #define BackendlessIOSSecretKey     @"CF06D382-63F5-DA76-FFF9-2935A5C1D400"
 #define BackendlessApplicationVer   @"v1"

#endif

//----------------------------------------------------------------------------------------




#endif
