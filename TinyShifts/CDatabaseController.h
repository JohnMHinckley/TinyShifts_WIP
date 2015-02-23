//
//  CDatabaseController.h
//  BeaconTracker1
//
//  Created by ios developer on 8/13/14.
//  Copyright (c) 2014 ios developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface CDatabaseController : NSObject
{
    sqlite3 *db;    // pointer to an sqlite3 structure
}

+(CDatabaseController*) sharedManager;
-(BOOL) openDB;
-(BOOL) closeDB;
-(BOOL) compileSqlStatement:(sqlite3_stmt**)pStatement fromQuery:(NSString*)qSQL;
-(void) createDatabase;


@end
