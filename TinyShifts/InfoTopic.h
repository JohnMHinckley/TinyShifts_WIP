//
//  InfoTopic.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/17/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoTopic : NSObject

@property int topicID;      // database table record id
@property NSString* title;  // name of the info topic
@property NSString* cellBkgndImage; // image file name for background image in table cell
@property NSString* text;   // actual information


@end
