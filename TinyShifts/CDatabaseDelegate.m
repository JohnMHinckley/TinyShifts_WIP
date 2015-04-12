//
//  CDatabaseDelegate.m
//  BeaconTracker1
//
//  Created by ios developer on 8/14/14.
//  Copyright (c) 2014 ios developer. All rights reserved.
//

#import "CDatabaseDelegate.h"
#import "DatabaseController.h"
#import "InfoTopic.h"


@implementation CDatabaseDelegate

-(int) readIntUsingQuery:(NSString*)query
{
    // Read an integer from the database by executing the input query.
    int retval = 0;
    
    [[DatabaseController sharedManager] openDB];
    
    // get the week index of the latest record in AppAction_ScheduleOpen for which done = 1
    NSString *qsql = query;
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            retval = sqlite3_column_int(statement, 0);
        }
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    

    return retval;
}




-(NSString*) readStringUsingQuery:(NSString*)query
{
    // Read a string from the database by executing the input query.
    // The return string is str.
    
    NSString* retval = nil;
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = query;
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char* c = (char *) sqlite3_column_text(statement, 0);
            
            retval = [[NSString alloc] initWithUTF8String:c];
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    [[DatabaseController sharedManager] closeDB];
    
    return retval;
}




-(double) readDoubleUsingQuery:(NSString*)query
{
    // Read a float from the database by executing the input query.
    double retval = 0.0;
    
    [[DatabaseController sharedManager] openDB];
    
    // get the week index of the latest record in AppAction_ScheduleOpen for which done = 1
    NSString *qsql = query;
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            retval = sqlite3_column_double(statement, 0);
        }
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    
    return retval;
}




-(void) writeUsingQuery:(NSString*)query
{
    // Execute the input query on the database.
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = query;
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
}




-(NSUInteger) getNumberOfInfoTopic
{
    NSUInteger retval = 0;
    
    NSString* q = @"SELECT count(*) from InfoList";
    retval = [self readIntUsingQuery:q];
    
    return retval;
}




-(NSMutableArray*) getAllInfoTopicRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT topicID, topicTitle, contentBkgndImage, topicText FROM InfoList"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        char* c = nil;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            InfoTopic* datum = [[InfoTopic alloc] init];    // allocate a new object, each pass through loop
            datum.topicID  = sqlite3_column_int(statement, 0);  // topicID
            
            c = (char *) sqlite3_column_text(statement, 1);  // topic
            datum.title = [[NSString alloc] initWithUTF8String:c];
            
            c = (char *) sqlite3_column_text(statement, 2);  // background image file for table cell
            datum.cellBkgndImage = [[NSString alloc] initWithUTF8String:c];
            
            c = (char *) sqlite3_column_text(statement, 3);  // information text
            datum.text = [[NSString alloc] initWithUTF8String:c];
            
            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}






@end
