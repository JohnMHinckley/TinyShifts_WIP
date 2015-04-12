//
//  DatabaseController.m
//  DatabaseTutorial1
//
//  Created by Dr. John M. Hinckley on 4/11/15.
//  Copyright (c) 2015 Hinckley Research Corp. All rights reserved.
//

#import "DatabaseController.h"
#import "AppDelegate.h"

@implementation DatabaseController



//---------------------------------------------------------------------------------------------------------------------------------



static DatabaseController* sharedSingleton = nil;   // single, static instance of this class



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Public Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(DatabaseController*) sharedManager
{
    // Returns a pointer to the shared singleton of this class.
    // If the singleton has not yet been allocated and initialized, it will be done here.
    
    if (nil == sharedSingleton)
    {
        // The singleton has not yet been created, so allocate and initialize it here.
        // This is done only once in the program.
        
        sharedSingleton = [[super alloc] init];
    }
    else
    {
        // The singleton has already been created, so do nothing more here.
        // Just return the existing non-null pointer.
    }
    return sharedSingleton;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) openDB
{
    // Opens the database file.
    
    // This will create an empty database file, if the database file does not already exist.
    
    // Returns YES if successful, NO otherwise.
    
    
    BOOL success = NO;   // initialize the return value
    
    
    int sqlite_retval = sqlite3_open_v2(                                // Open the database
                                        [[self filePath] UTF8String],   // full path to the database file, UTF-8 encoding
                                        &db,                            // pointer to SQLite3 data structure for the connection
                                        SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, // access mode flag:
                                                                        //      read from & write to database
                                                                        //      and create the database file, if it does not exist
                                        NULL                            // name of virtual file system (generally use default,
                                                                        //      using NULL here)
                                        );
    
    
    if (SQLITE_OK == sqlite_retval)
    {
        // Database did open successfully.
        success = YES;
    }
    else
    {
        // Database did not open successfully.
        [self closeDB];     // attempt to close database
        success = NO;
        NSLog(@"*** Warning: database not successfully opened in DatabaseController::openDB.  Returning NO.");
    }
    
    return success;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) closeDB
{
    // Closes the database file.
    // Returns YES if successful, NO otherwise.
    
    BOOL success = NO;   // initialize the return value
    
    
    int sqlite_retval = sqlite3_close(db);
    
    
    if (SQLITE_OK == sqlite_retval)
    {
        // Database did close successfully.
        success = YES;
    }
    else
    {
        // Database did not close successfully.
        success = NO;
        NSLog(@"*** Warning: database not successfully closed in DatabaseController::closeDB.  Returning NO.");
    }
    
    return success;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) prepareSqlStatement:(sqlite3_stmt**)pStatement
                  fromQuery:(NSString*)qSQL
{
    // Parse the query and convert it into byte code for execution.
    // Input query refereced by qSQL.
    // Output byte code referenced by pStatement.
    
    BOOL success = NO;   // return value
    
    
    int sqlite_retval = sqlite3_prepare_v2(
                                           db,                  // SQLite3 data structure for the connection
                                           [qSQL UTF8String],   // query, encoded as a UTF-8 string
                                           -1,                  // negative value used to flag the prepare function to determine
                                                                //      the length of the query string
                                           pStatement,          // pointer to the btye code statement
                                           nil                  // pointer to the next command in a compound query.  Not used here.
                                           );
    
    
    if (SQLITE_OK == sqlite_retval)
    {
        // Query was converted successfully.
        success = YES;
    }
    else
    {
        // Query was not converted successfully.
        success = NO;
        NSLog(@"*** Warning: SQL query not successfully prepared in DatabaseController::prepareSqlStatement::.  Returning NO.");
    }
    
    return success;
}



//---------------------------------------------------------------------------------------------------------------------------------



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



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark --------------- Private Methods ------------------



//---------------------------------------------------------------------------------------------------------------------------------



-(NSString*) filePath
{
    // Get the full filepath of the database file in the sandbox.
    
    // If both the database filename and the sandbox path are found, the full path is returned.
    // Otherwise, if either is not found, nil is returned.
    
    
    NSString* fullPathToDatabase = nil;         // Initialze the path string to nil.
    
    
    
    // Read the database file name from the app info property list.
    NSString *fn = [self getAppInfoStringValueForKey:@"Database filename"];
    
    
    
    if (nil != fn)  // was the filename found?
    {
        // yes, filename was found
        
        // Get the documents path in the app's sandbox
        NSString* path = ((AppDelegate*) [UIApplication sharedApplication].delegate).documentsPath;
        
        
        
        if (nil != path)    // was the path found?
        {
            // yes, the path was found
            
            // Append the filename to the directory path to get the full path to the database.
            fullPathToDatabase = [path stringByAppendingPathComponent:fn];
        }
        else
        {
            // path was not found.
            NSLog(@"*** Warning: sandbox path not found in DatabaseController::filePath.  Returning nil.");
        }
    }
    else
    {
        // filename was not found.
        NSLog(@"*** Warning: database filename not found in DatabaseController::filePath.  Returning nil.");
    }
    
    
    return fullPathToDatabase;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSString*) getAppInfoStringValueForKey:(NSString*) skey
{
    // Read the string value from the AppInfo property list corresponding to the input key skey.
    
    // If the path to the AppInfo property list is determined, and
    // if the property list exists, and
    // if the string value corresponding to skey is found in the list,
    // then return the value.
    
    // Otherwise, return nil.
    
    
    
    NSString* value = nil;   // Initialize the value.
    
    
    
    // Get the path for the AppInfo property list.
    NSString* pathToAppInfoPList = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
    
    
    
    if (nil != pathToAppInfoPList)  // was the path for the AppInfo property list found?
    {
        // yes, it was found.
        
        
        // Check that property list file exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathToAppInfoPList])   // was the AppInfo property list found?
        {
            // yes, it was found.
            
            // Load the property list into a dictionary.
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:pathToAppInfoPList];
            
            
            // Get the value from the dictionary,
            // as the value corresponding to the key skey.
            value = [NSString stringWithFormat:@"%@",[dic valueForKey:skey]];
            
            
            if (nil != value)
            {
                // Apparently OK, some kind of string was read.
            }
            else
            {
                // No valid string was read from the property list.
                NSLog(@"*** Warning: value not found in DatabaseController::getAppInfoStringValueForKey.  Returning nil.");
            }
        }
        else
        {
            // AppInfo property list not found.
            NSLog(@"*** Warning: AppInfo property list not found in DatabaseController::getAppInfoStringValueForKey.");
            NSLog(@"Returning nil.");
        }
    }
    else
    {
        // Path for AppInfo property list not found.
        NSLog(@"*** Warning: Path for AppInfo property list not found in DatabaseController::getAppInfoStringValueForKey.");
        NSLog(@"Returning nil.");
    }
    
    
    
    return value;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) checkDatabase
{
    // Find out whether a database with the full path returned by the method filePath,
    // exists (in the Documents directory of the sandbox for this app).
    
   
    
    // This is done by trying to open the named database in the sandbox.

    
    BOOL bExists = NO;  // Will be set to YES if file is found.
    
    if (sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY, NULL) == SQLITE_OK )
    {
        // Successfully opened, meaning that the database file exists.
        [self closeDB];
        bExists = YES;
    }
    
    return bExists;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) getReadableDatabase
{
    // Create an empty database (in the Documents directory of the sandbox for this app), for later overwriting.
    
    BOOL bSuccess = NO; // Will be set to YES if database file is successfully created.
    
    if ([self openDB])  // Will create the database, which doesn't initially exist.
    {
        [self closeDB];
        bSuccess = YES;
    }
    
    
    return bSuccess;
}



//---------------------------------------------------------------------------------------------------------------------------------



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



//---------------------------------------------------------------------------------------------------------------------------------



-(NSString *) filePathInBundle
{
    // Get the full filepath of the database file in the distribution bundle.
    
    
    NSString* pathToDatabase = nil;     // Initialize the value.
    
    
    
    // Get the name of the bundle containing the database
    NSString* bundleName = [self getAppInfoStringValueForKey:@"Database bundle name"];
    
    
    // Form the bundle path
    NSString* dbBundlePath = [[NSBundle mainBundle] pathForResource:bundleName
                                                             ofType:nil];
    
    
    if ([dbBundlePath length] > 0)  // was the database bundle found?
    {
        // yes, DB bundle name was found.
        
        
        NSBundle* dbBundle = [NSBundle bundleWithPath:dbBundlePath];    // load the named bundle
        
        if (nil != dbBundle)    // was the bundle loaded?
        {
            // yes, the bundle was loaded.
            
            
            // Get the name of the database in the distributed bundle
            NSString* DBName = [self getAppInfoStringValueForKey:@"Database filename"];
            
            
            
            // Form the path to the bundled database
            pathToDatabase = [dbBundle pathForResource:DBName
                                                ofType:nil];
            
            
            if ([pathToDatabase length] > 0)    // was the name of the bundled database found?
            {
                // yes, the name of the bundled database was found.
            }
            else
            {
                // Name of the bundled database was not found in AppInfo.plist
                NSLog(@"Error in DatabaseController::filePathInBundle, failed to find database name in DB bundle.");
                NSLog(@"Returning nil.");
            }
        }
        else
        {
            // DB bundle was not loaded.
            NSLog(@"Error in DatabaseController::filePathInBundle, failed to load DB bundle.");
            NSLog(@"Returning nil.");
        }
    }
    else
    {
        // DB bundle name was not found.
        NSLog(@"Error in DatabaseController::filePathInBundle, failed to find DB bundle name in AppInfo plist.");
        NSLog(@"Returning nil.");
    }
    
    return pathToDatabase;
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
