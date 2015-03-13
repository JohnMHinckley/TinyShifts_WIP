//
//  GlobalData.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 3/13/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
@property int selectedVideo;

+(GlobalData*) sharedManager;

+(float) RandomNumberUpTo:(float) upperLimit;
+(int) RandomIntUpTo:(int) upperLimit;

@end
