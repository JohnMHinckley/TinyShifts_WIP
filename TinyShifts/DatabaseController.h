//
//  DatabaseController.h
//  DatabaseTutorial1
//
//  Created by Dr. John M. Hinckley on 4/11/15.
//  Copyright (c) 2015 Hinckley Research Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseController : NSObject
{
    sqlite3 *db;    // pointer to an sqlite3 structure
}

+(DatabaseController*) sharedManager;
-(BOOL) openDB;
-(BOOL) closeDB;
-(BOOL) prepareSqlStatement:(sqlite3_stmt**)pStatement fromQuery:(NSString*)qSQL;
-(void) createDatabase;

@end
