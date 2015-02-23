//
//  CDatabaseController.m
//  BeaconTracker1
//
//  Created by ios developer on 8/13/14.
//  Copyright (c) 2014 ios developer. All rights reserved.
//

#import "CDatabaseController.h"
#import "AppDelegate.h"

@implementation CDatabaseController
static CDatabaseController* sharedSingleton = nil;   // single, static instance of this class



+(CDatabaseController*) sharedManager
{
    // Method returns a pointer to the shared singleton of this class.
    
    if (nil == sharedSingleton)
    {
        // Only if the singleton has not yet been allocated, is it allocated, here.
        // Thus, it is allocated only once in the program, i.e. it's a SINGLETON.
        sharedSingleton = [[super allocWithZone:NULL] init];
    }
    return sharedSingleton;
}


+(id)allocWithZone:(NSZone *)zone
{
    // NSObject method override.
    // Normally, returns a new instance of the receiving class.
    
    return [self sharedManager];
}

-(id)copyWithZone:(NSZone*) zone
{
    // NSObject method override.
    // Normally, returns the receiver.
    
    return self;
}






-(NSString *) getDatabaseFileName
{
    // Read the database file name from the app info property list.
    NSString *pathToAppInfoPList = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    
    // Check that property list file exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToAppInfoPList])
    {
        
        // Load the property list into the dictionary.
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:pathToAppInfoPList];
        
        NSString *fn = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Database filename"]];
        
        // free the memory
        
        return fn;
    }
    else
    {
        return nil;
    }
}






-(NSString *) getContentBundleFileName
{
    // Read the database file name from the app info property list.
    NSString *pathToAppInfoPList = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    
    // Check that property list file exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToAppInfoPList])
    {
        
        // Load the property list into the dictionary.
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:pathToAppInfoPList];
        
        NSString *fn = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Bundle filename"]];
        
        // free the memory
        
        return fn;
    }
    else
    {
        return nil;
    }
}






-(NSString *) filePath
{
    // Get the full filepath of the database file in the sandbox.
    
    NSString* pathToDatabase = nil;
    
    // Read the database file name from the app info property list.
    NSString *fn = [self getDatabaseFileName];
    
    pathToDatabase = [((AppDelegate*) [UIApplication sharedApplication].delegate).documentsPath stringByAppendingPathComponent:fn];
    
    return pathToDatabase;
}





-(NSString *) filePathInBundle
{
    // Get the full filepath of the database file in the distribution bundle.
    
    NSString* pathToDatabase = nil;
    
    NSString* contentBundlePath = [[NSBundle mainBundle] pathForResource:[self getContentBundleFileName] ofType:nil];
    
    if ([contentBundlePath length] > 0)
    {
        NSBundle* contentBundle = [NSBundle bundleWithPath:contentBundlePath];
        
        if (nil != contentBundle)
        {
            pathToDatabase = [contentBundle pathForResource:[self getDatabaseFileName] ofType:nil];
            
            if ([pathToDatabase length] > 0)
            {
                // OK
            }
            else
            {
                NSLog(@"Error in CDatabaseController::filePathInBundle, failed to find database in content bundle.");
            }
        }
        else
        {
            NSLog(@"Error in CDatabaseController::filePathInBundle, failed to load content bundle.");
        }
    }
    else
    {
        NSLog(@"Error in CDatabaseController::filePathInBundle, failed to find content bundle.");
    }
    
    return pathToDatabase;
}








-(BOOL) openDB
{
    //—-create database—-
    if (sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) != SQLITE_OK )
    {
        [self closeDB];
        return NO;
    }
    return YES;
}





-(BOOL) closeDB
{
    // Close the database
    int sqlite_retval = sqlite3_close(db);
    
    if (SQLITE_OK != sqlite_retval)
    {
        return NO;
    }
    return YES;
}




-(BOOL) compileSqlStatement:(sqlite3_stmt**)pStatement fromQuery:(NSString*)qSQL
{
    if (sqlite3_prepare_v2( db, [qSQL UTF8String], -1, pStatement, nil) == SQLITE_OK)
    {
        return YES;
    }
    return NO;
}




-(BOOL) checkDatabase
{
    // Find out whether a database with the name "a.db" exists in the sandbox for this app.
    
    /*
     This is done by trying to open the named database in the sandbox.
     */
    
    BOOL bExists = NO;  // Will be set to YES if file is found.
    
    if (sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY, NULL) == SQLITE_OK )
    {
        // Successfully opened, meaning that the database file exists.
        [self closeDB];
        bExists = YES;
    }
    
    return bExists;
}




-(BOOL) getReadableDatabase
{
    // Create an empty database "a.db" in the sandbox, for later overwriting.
    
    BOOL bSuccess = NO; // Will be set to YES if database file is successfully created.
    
    if ([self openDB])  // Will create the database, which doesn't initially exist.
    {
        [self closeDB];
        bSuccess = YES;
    }
    
    
    return bSuccess;
}





-(void) copyDatabase
{
    // Copy the database file from the distribution bundle to the sandbox, in a byte stream.
    
    /*
     Procedure:
     1. Open the distributed database, as byte stream input.
     2. Open a new file in the sandbox, to be the database, as a byte stream output.
     3. Read a byte buffer from the input stream and write it to the output stream.  Repeat until the end of the input stream.
     4. Flush and close the output stream.
     5. Close the input stream.
     */
    
    
    NSInputStream* iStream = [[NSInputStream alloc] initWithFileAtPath:[self filePathInBundle]];
    [iStream open];
    
    NSOutputStream* oStream = [[NSOutputStream alloc] initToFileAtPath:[self filePath] append:NO];
    [oStream open];
    
    uint8_t buf[1024];
    
    long len = [iStream read:buf maxLength:sizeof(buf)];
    
    while (len > 0)
    {
        [oStream write:buf maxLength:len];
        len = [iStream read:buf maxLength:sizeof(buf)];
    }
    
    [oStream close];
    [iStream close];
    
}




-(void) createDatabase
{
    // Check whether the database already exists in the sandbox.
    // If it does not, create a beginning database, by copying the distributed database from the content bundle.
    
    if ([self checkDatabase] == NO)
    {
        // Database does not exist in the sandbox.
        
        [self getReadableDatabase]; // create an empty db in the sandbox
        
        [self copyDatabase];        // copy the distributed db to the sandbox
    }
}






@end
