//
//  CDatabaseDelegate.h
//  BeaconTracker1
//
//  Created by ios developer on 8/14/14.
//  Copyright (c) 2014 ios developer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDatabaseDelegate : NSObject

-(int) readIntUsingQuery:(NSString*)query;
-(NSString*) readStringUsingQuery:(NSString*)query;
-(double) readDoubleUsingQuery:(NSString*)query;
-(void) writeUsingQuery:(NSString*)query;
-(NSUInteger) getNumberOfInfoTopic;
-(NSMutableArray*) getAllInfoTopicRecords;

@end
