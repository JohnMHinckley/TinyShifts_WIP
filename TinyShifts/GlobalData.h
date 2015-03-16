//
//  GlobalData.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
@property int selectedVideo;   // index as defined in ConstGen.h
@property int videoWasHelpful; // values defined in ConstGen.h
@property int videoWatchAgain; // values defined in ConstGen.h
@property int videoRecommend; // values defined in ConstGen.h

+(GlobalData*) sharedManager;

+(float) RandomNumberUpTo:(float) upperLimit;
+(int) RandomIntUpTo:(int) upperLimit;

@end
