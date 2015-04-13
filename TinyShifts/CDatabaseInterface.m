//
//  CDatabaseInterface.m
//  NaturePill
//
//  Created by Dr. John M. Hinckley on 5/26/14.
//  Copyright (c) 2014 Gurmentor Inc. All rights reserved.
//

#import "CDatabaseInterface.h"
#import "DatabaseController.h"
#import "AppDelegate.h"
#import "Backendless.h"
#import "RDB_Participants.h"


@implementation CDatabaseInterface

static CDatabaseInterface* sharedSingleton = nil;   // single, static instance of this class



+(CDatabaseInterface*) sharedManager
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



//---------------------------------------------------------------------------------------------------------------------------------



-(int) getActivationStatus
{
    // Get the activation status of the app.
    // This is read from the MyStatus table in the database.
    // If the value corresponding to the key "activation" is 0, the app is not activated: return a value of 0.
    // If the value is not 0, the app is activated: return a value of 1.
    int retVal = 0;
    
    BOOL bDidFindDatabase = NO; // used to test for presence of database, which may not be on the phone, initially.
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    
    //—-retrieve rows—-
    NSString *qsql = @"SELECT value FROM MyStatus where key = 'activated'";
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            retVal = sqlite3_column_int(statement, 0);  // int value read for key
            
            
            bDidFindDatabase = YES;
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    

    
    
    [[DatabaseController sharedManager] closeDB];
    
    
    if (!bDidFindDatabase)
    {
        // did not find database: issue an alert.
        
        UIAlertView *alertView = nil;
        alertView = [[UIAlertView alloc] initWithTitle:@"Attention:"
                                               message:@"Local TinyShifts database has not \nbeen installed on this device.\nThis must be installed \nprior to activation."
                                              delegate:self cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [alertView show];

    }

    
    return retVal;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(NSString*) getParticipantCodeWithMatchingActivation:(NSString*)activationCode
{
    NSString* retVal = nil;
    
//    [[DatabaseController sharedManager] openDB];
//    
//    
//    NSString *qsql = [NSString stringWithFormat:@"SELECT idParticipantCode FROM Participants where activationCode = '%@'", activationCode];
//    
//    sqlite3_stmt *statement;
//    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
//    {
//        while (sqlite3_step(statement) == SQLITE_ROW)
//        {
//            char *idParticipantCode = (char *) sqlite3_column_text(statement, 0);  // idParticipantCode
//            
//            retVal = [[NSString alloc] initWithUTF8String:idParticipantCode];
//        }
//        
//        
//        sqlite3_reset(statement);
//        
//        //—-deletes the compiled statement from memory—-
//        sqlite3_finalize(statement);
//    }
//    
//    
//    
//    [[DatabaseController sharedManager] closeDB];
    
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    
    query.whereClause = [NSString stringWithFormat:@"activationCode = \'%@\'", activationCode];
    
    
    BackendlessCollection* collection = [backendless.persistenceService find:[RDB_Participants class] dataQuery:query];

    NSMutableArray* data = [[NSMutableArray alloc] initWithArray:[collection data]];
    
    if ([data count] > 0)
    {
        // A participant with the specified activationCode was found.
        
        // Return the corresponding participantID.
        
        retVal = ((RDB_Participants*)[data objectAtIndex:0]).idParticipantCode;
    }

    
    return retVal;
}




//---------------------------------------------------------------------------------------------------------------------------------



- (void)responseHandlerActivationQuery:(id)response
{
    NSLog(@"responseHandler:Schedule Sent; class = %@", [response class]);
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSMutableArray* data = [[NSMutableArray alloc] initWithArray:[(BackendlessCollection *)response data]];
    
    if ([data count] > 0)
    {
        // corresponding record(s) was found in the remote database table
        
        // In the Participants table, for the record with recordID matching the value in data, set the confirmed transmitted bit.
        int recordID = (int)((RDB_Participants*)[data objectAtIndex:0]).idParticipantCode;
        
        [self setTransmitConfirmedBitForSurveyRecordWithID:recordID];
        
    }
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) saveMyIdentityAs:(NSString*)idParticipantCode
{
    // save the value of idParticipantCode in the table MyIdentity
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"INSERT INTO MyIdentity values ('%@')",idParticipantCode];
    
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




-(void) saveAppActivationState:(int)activationValue
{
    // save the value of activationValue in the table MyStatus, under the key "activated"
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString* qsql = @"DELETE FROM MyStatus";
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    qsql = [NSString stringWithFormat:@"INSERT INTO MyStatus values ('activated', %d)",activationValue];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
}





-(void) saveScheduleOpenRecordWithYear:(NSInteger)year
                              andMonth:(NSInteger)month
                                andDay:(NSInteger)day
                               andHour:(NSInteger)hour
                             andMinute:(NSInteger)minute
                             andWeekID:(NSInteger)idWeek
{
    // Save a new record in the AppAction_ScheduleOpen table.
    
    static int idOpen = 0;
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idProd.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idOpen from AppAction_ScheduleOpen order by idOpen desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idOpen = sqlite3_column_int(statement, 0) + 1;  // idOpen: add 1 to get next value for principal key.
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    qsql = [NSString stringWithFormat:@"INSERT INTO AppAction_ScheduleOpen values (%d, %ld, %ld, %ld, %ld, %ld, %d, %ld)", idOpen, (long)year, (long)month, (long)day, (long)hour, (long)minute, 0, (long)idWeek];  // 0 signifies that action is not done
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    //idOpen++;   // increment PK for next cycle
}





-(void) saveScheduleProdRecordWithYear:(NSInteger)year
                              andMonth:(NSInteger)month
                                andDay:(NSInteger)day
                               andHour:(NSInteger)hour
                             andMinute:(NSInteger)minute
                             andWeekID:(NSInteger)idWeek
{
    // Save a new record in the AppAction_ScheduleProd table.
    
    static int idProd = 0;
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idProd.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idProd from AppAction_ScheduleProd order by idProd desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idProd = sqlite3_column_int(statement, 0) + 1;  // idProd: add 1 to get next value for principal key.
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    qsql = [NSString stringWithFormat:@"INSERT INTO AppAction_ScheduleProd values (%d, %ld, %ld, %ld, %ld, %ld, %d, %ld)", idProd, (long)year, (long)month, (long)day, (long)hour, (long)minute, 0, (long)idWeek];  // 0 signifies that action is not done
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    //idProd++;   // increment PK for next cycle
}






-(void) saveMakeScheduleRecordWithWeekID:(NSInteger)idWeek
{
    // Save a new record in the MakeSchedule table.
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"INSERT INTO MakeSchedule values (%ld, %d)", (long)idWeek, 0];  // 0 signifies that action is not done
    
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




-(void) saveScheduleRetransmitRecordWithYear:(NSInteger)year
                                    andMonth:(NSInteger)month
                                      andDay:(NSInteger)day
                                     andHour:(NSInteger)hour
                                   andMinute:(NSInteger)minute
{
    // Save a new record in the AppAction_Retransmit table.
    
    static int idAction = 0;
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"INSERT INTO AppAction_Retransmit values (%d, %ld, %ld, %ld, %ld, %ld, %d)", idAction, (long)year, (long)month, (long)day, (long)hour, (long)minute, 0];  // 0 signifies that action is not done
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    idAction++;   // increment PK for next cycle
}




-(int*) getEarliestRetransmitRecord
{
    // Returns a pointer to an array of date components.
    // index    quantity
    // 0        year
    // 1        month
    // 2        day
    // 3        hour
    // 4        minute
    
    //NSMutableArray* arr = [[NSMutableArray alloc] init];
    int n[5];
    
    int* retVal = &n[0];
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve earliest row—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT year,month,day,hour,minute FROM AppAction_Retransmit where done=0 order by id limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            n[0] = sqlite3_column_int(statement, 0);  // year
            
            n[1] = sqlite3_column_int(statement, 1);  // month
            
            n[2] = sqlite3_column_int(statement, 2);  // day
            
            n[3] = sqlite3_column_int(statement, 3);  // hour
            
            n[4] = sqlite3_column_int(statement, 4);  // minute
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    
    return retVal;
}



-(int*) getEarliestOpenRecord
{
    // Returns a pointer to an array of date components.
    // index    quantity
    // 0        year
    // 1        month
    // 2        day
    // 3        hour
    // 4        minute
    // 5        idOpen
    
    int n[6];
    
    int* retVal = &n[0];
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve earliest row—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT year,month,day,hour,minute,idOpen FROM AppAction_ScheduleOpen where done=0 order by idOpen limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            n[0] = sqlite3_column_int(statement, 0);  // year
            
            n[1] = sqlite3_column_int(statement, 1);  // month
            
            n[2] = sqlite3_column_int(statement, 2);  // day
            
            n[3] = sqlite3_column_int(statement, 3);  // hour
            
            n[4] = sqlite3_column_int(statement, 4);  // minute
            
            n[5] = sqlite3_column_int(statement, 5);  // idOpen
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
   
    
    return retVal;
}




-(void) setOpenRecordDoneForId:(int)idOpen
{
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"UPDATE AppAction_ScheduleOpen set done = replace(done,0,1) where idOpen = %d",idOpen];
    
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





-(NSMutableArray*) getAllUndoneProdRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idProd, year, month, day, hour, minute, done, idWeek FROM AppAction_ScheduleProd where done = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CProdData* datum = [[CProdData alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // idProd
//            datum.year      = sqlite3_column_int(statement, 1);  // year
//            datum.month     = sqlite3_column_int(statement, 2);  // month
//            datum.day       = sqlite3_column_int(statement, 3);  // day
//            datum.hour      = sqlite3_column_int(statement, 4);  // hour
//            datum.minute    = sqlite3_column_int(statement, 5);  // minute
//            datum.done      = sqlite3_column_int(statement, 6);  // done
//            datum.idWeek    = sqlite3_column_int(statement, 7);  // idWeek
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}





-(NSMutableArray*) getAllUndoneGEPromptRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT id, yearPrompt, monthPrompt, dayPrompt, hourPrompt, minutePrompt, dateGE, timeGE, locationGE, phrase, promptPhone, promptEmail, done FROM AppAction_GEPrompt where done = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CGEPromptData* datum = [[CGEPromptData alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // id
//            datum.year      = sqlite3_column_int(statement, 1);  // year
//            datum.month     = sqlite3_column_int(statement, 2);  // month
//            datum.day       = sqlite3_column_int(statement, 3);  // day
//            datum.hour      = sqlite3_column_int(statement, 4);  // hour
//            datum.minute    = sqlite3_column_int(statement, 5);  // minute
//            char* c = (char *) sqlite3_column_text(statement, 6); datum.dateGE = [[NSMutableString alloc] initWithUTF8String:c];  // dateGE
//            c = (char *) sqlite3_column_text(statement, 7); datum.timeGE = [[NSMutableString alloc] initWithUTF8String:c];  // timeGE
//            c = (char *) sqlite3_column_text(statement, 8); datum.locationGE = [[NSMutableString alloc] initWithUTF8String:c];  // locationGE
//            c = (char *) sqlite3_column_text(statement, 9); datum.phrase = [[NSMutableString alloc] initWithUTF8String:c];  // phrase
//            datum.promptPhone = sqlite3_column_int(statement,10);  // promptPhone
//            datum.promptEmail = sqlite3_column_int(statement,11);  // promptEmail
//            datum.done      = sqlite3_column_int(statement,12);  // done
//            
//
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}







-(void) setAllOpenRecordsDoneBeforeYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute
{
    // Examine all records in the AppAction_ScheduleOpen table.
    // For any record whose date/time is earlier than the input date/time, set the done field = 1.
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idOpen, year, month, day, hour, minute FROM AppAction_ScheduleOpen"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CScheduleDatum* datum = [[CScheduleDatum alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // id
//            datum.year      = sqlite3_column_int(statement, 1);  // year
//            datum.month     = sqlite3_column_int(statement, 2);  // month
//            datum.day       = sqlite3_column_int(statement, 3);  // day
//            datum.hour      = sqlite3_column_int(statement, 4);  // hour
//            datum.minute    = sqlite3_column_int(statement, 5);  // minute
//            
//            
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    
    for (int idx = 0; idx < [arr count]; idx++)
    {
        // some records were retrieved.
        // One by one, check whether they are earlier than the input date/time
//        CScheduleDatum* r = (CScheduleDatum*)[arr objectAtIndex:idx];
//        if (r.year > year)
//        {
//            // record is later.
//            // leave it alone
//            continue;   // go to the next record.
//        }
//        else if (r.year == year)
//        {
//            // need to check month
//            if (r.month > month)
//            {
//                // record is later.
//                // leave it alone
//                continue;   // go to the next record.
//            }
//            else if (r.month == month)
//            {
//                // need to check day
//                if (r.day > day)
//                {
//                    // record is later.
//                    // leave it alone
//                    continue;   // go to the next record.
//                }
//                else if (r.day == day)
//                {
//                    // need to check hour
//                    if (r.hour > hour)
//                    {
//                        // record is later.
//                        // leave it alone
//                        continue;   // go to the next record.
//                    }
//                    else if (r.hour == hour)
//                    {
//                        // need to check minute
//                        if (r.minute >= minute)
//                        {
//                            // record is later (or to be more precise, not earlier).
//                            // leave it alone
//                            continue;   // go to the next record.
//                        }
//                        else
//                        {
//                            // record is earlier
//                        }
//                    }
//                    else
//                    {
//                        // record is earlier
//                    }
//               }
//                else
//                {
//                    // record is earlier
//                }
//           }
//            else
//            {
//                // record is earlier
//            }
//        }
//        else
//        {
//            // record is earlier
//        }
//        
//        
//        
//        // if program gets to this point, the record is earlier than the input date/time
//        // update its done = 1.
//        
//        
//        NSString *qsql = [NSString stringWithFormat:@"UPDATE AppAction_ScheduleOpen set done = replace (done, 0, 1) where idOpen = %d",r.idRecord];
//        
//        sqlite3_stmt *statement;
//        if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
//        {
//            sqlite3_step(statement);
//            
//            sqlite3_reset(statement);
//            
//            //—-deletes the compiled statement from memory—-
//            sqlite3_finalize(statement);
//        }
        
        
        
    }
    
    
    
    
    [[DatabaseController sharedManager] closeDB];
}






-(NSString*) getMyIdentity
{
    // Read and return the participant code from MyIdentity table
    
    
    NSString* retVal = nil;
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"SELECT participantId from MyIdentity limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *idParticipantCode = (char *) sqlite3_column_text(statement, 0);  // idParticipantCode
            
            retVal = [[NSString alloc] initWithUTF8String:idParticipantCode];
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    
    return retVal;
}







-(int) saveScheduleDataRecordWithDateScheduleMade:(NSString*)dateScheduleMade
                              andTimeSchedlueMade:(NSString*)timeScheduleMade
                                        andDateGE:(NSString*)dateGE
                                        andTimeGE:(NSString*)timeGE
                                    andLocationGE:(NSString*)locationGE
                                  andPromptPhrase:(NSString*)promptPhrase
                                     andUsedPhone:(NSInteger)usedPhone
                                     andUsedEmail:(NSInteger)usedEmail
                         andDidTransmitThisRecord:(NSInteger)didTransmitThisRecord
{
    static int idGreenExperience = 0;   // principal key for the table
    
    int retVal = -1;
    
    NSString* idParticipantCode = [NSString stringWithString:[self getMyIdentity]]; // read the participant's unique identity.
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idGreenExperience.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idGreenExperience from ScheduleData order by idGreenExperience desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idGreenExperience = sqlite3_column_int(statement, 0) + 1;  // idGreenExperience: add 1 to get next value for principal key.
            retVal = idGreenExperience;
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    // query
    qsql = [NSString stringWithFormat:@"INSERT INTO ScheduleData values (%d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %ld, %ld, %ld)", idGreenExperience, idParticipantCode, dateScheduleMade, timeScheduleMade, dateGE, timeGE, locationGE, promptPhrase, (long)usedPhone, (long)usedEmail, (long)didTransmitThisRecord];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return retVal;
}





-(NSMutableArray*) getAllMyPhrases
{
    // Return an array of all of my motivational phrases.
    
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* idParticipantCode = [NSString stringWithString:[self getMyIdentity]]; // read the participant's unique identity.
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT promptPhrase FROM MotivationalPhrases where (idParticipantCode = '%@')", idParticipantCode];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char* c = (char *) sqlite3_column_text(statement, 0);  // promptPhrase
            
            NSString* s = [[NSString alloc] initWithUTF8String:c];
            
            [arr addObject:s];
           
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}





-(void) setUserDoneForCurrentWeek
{
    // Set the userDone flag = 1 in MakeSchedule table for the latest week that has done = 1 in AppAction_ScheduleOpen table.
    // This should be for the current week.
    
    [[DatabaseController sharedManager] openDB];
    
    // get the week index of the latest record in AppAction_ScheduleOpen for which done = 1
    NSString *qsql = [NSString stringWithFormat:@"SELECT idWeek from AppAction_ScheduleOpen where done = 1 order by idOpen desc limit 1"];
    
    sqlite3_stmt *statement;
    int idWeek;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idWeek = sqlite3_column_int(statement, 0);  // idWeek
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    // set the userDone flag = 1 for the record in MakeSchedule where idWeek matches above value.
    qsql = [NSString stringWithFormat:@"UPDATE MakeSchedule set userDone = replace(userDone, 0, 1) where idWeek = %d", idWeek];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
}






-(void) saveGEPromptRecordWithYear:(NSInteger)year
                          andMonth:(NSInteger)month
                            andDay:(NSInteger)day
                           andHour:(NSInteger)hour
                         andMinute:(NSInteger)minute
                         andDateGE:(NSString*)dateGE
                         andTimeGE:(NSString*)timeGE
                     andLocationGE:(NSString*)locationGE
                         andPhrase:(NSString*)phrase
                    andPromptPhone:(NSInteger)promptPhone
                    andPromptEmail:(NSInteger)promptEmail
                           andDone:(NSInteger)done
{
    static int idGreenExperience = 0;   // principal key for the table
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idGreenExperience.
    NSString *qsql = [NSString stringWithFormat:@"SELECT id from AppAction_GEPrompt order by id desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idGreenExperience = sqlite3_column_int(statement, 0) + 1;  // idGreenExperience: add 1 to get next value for principal key.
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    // query
    qsql = [NSString stringWithFormat:@"INSERT INTO AppAction_GEPrompt values (%d, %ld, %ld, %ld, %ld, %ld, '%@', '%@', '%@', '%@', %ld, %ld, %ld)", idGreenExperience, (long)year, (long)month, (long)day, (long)hour, (long)minute, dateGE, timeGE, locationGE, phrase, (long)promptPhone, (long)promptEmail, (long)done];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    //idGreenExperience++;    // increment in preparation for next record storage
   
}





-(int) getLatestDoneOpenWeek
{
    // Find the idWeek for the latest record having done = 1
    
    int idWeek = -1;
    
    [[DatabaseController sharedManager] openDB];
    
    // get the week index of the latest record in AppAction_ScheduleOpen for which done = 1
    NSString *qsql = [NSString stringWithFormat:@"SELECT idWeek from AppAction_ScheduleOpen where done = 1 order by idWeek desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idWeek = sqlite3_column_int(statement, 0);  // idWeek
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
  
    return idWeek;
}





-(int) getUserDoneForWeek:(int)idWeek
{
    // Read and return the value of userDone from the record in MakeSchedule, having input value of idWeek.
    
    int userDone = -1;
    
    [[DatabaseController sharedManager] openDB];
    
    // get the week index of the latest record in AppAction_ScheduleOpen for which done = 1
    NSString *qsql = [NSString stringWithFormat:@"SELECT userDone from MakeSchedule where idWeek = %d",idWeek];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            userDone = sqlite3_column_int(statement, 0);  // userDone
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    [[DatabaseController sharedManager] closeDB];
    
    return userDone;
}




-(void) setProdRecordDoneForWeek:(int)idWeek
{
    // Set done = 1 for record in AppAction_ScheduleProd table with input value of idWeek.
    
    [[DatabaseController sharedManager] openDB];
    
    
        NSString *qsql = [NSString stringWithFormat:@"UPDATE AppAction_ScheduleProd set done = replace (done, 0, 1) where idWeek = %d",idWeek];
        
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




-(void) setGEPromptRecordDoneForRecord:(int)idRecord
{
    // Set done = 1 for record in AppAction_GEPrompt table with input value of idRecord.
    
    [[DatabaseController sharedManager] openDB];
    
    
    NSString *qsql = [NSString stringWithFormat:@"UPDATE AppAction_GEPrompt set done = replace (done, 0, 1) where id = %d",idRecord];
    
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





-(int) saveScheduleProddingsDataRecordWithDateProd:(NSString*)dateSent
                         andDidTransmitThisRecord:(NSInteger)didTransmitThisRecord
{
    static int idProd = 0;   // principal key for the table
    
    int retVal = -1;
    
    NSString* idParticipantCode = [NSString stringWithString:[self getMyIdentity]]; // read the participant's unique identity.
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idProd.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idProd from ScheduleProddingsData order by idProd desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idProd = sqlite3_column_int(statement, 0) + 1;  // idProd: add 1 to get next value for principal key.
            retVal = idProd;
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    // query
    qsql = [NSString stringWithFormat:@"INSERT INTO ScheduleProddingsData values (%d, '%@', '%@', %ld)", idProd, idParticipantCode, dateSent, (long)didTransmitThisRecord];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    [[DatabaseController sharedManager] closeDB];
    
    return retVal;
}



-(int) saveSurveyDataRecordWithStartSurveyDate:(NSString*)startSurveyDate
                             andStartSurveyTime:(NSString*)startSurveyTime
                                    andLocation:(NSString*)location
                                   andPreStress:(int)preStress
                            andPreAttentiveness:(int)preAttentiveness
                                     andPreMood:(int)preMood
                                   andPreEnergy:(int)preEnergy
                                   andPreGEDate:(NSString*)preGEDate
                                   andPreGETime:(NSString*)preGETime
                               andPreGELatitude:(double)preGELatitude
                              andPreGELongitude:(double)preGELongitude
                                  andPostGEDate:(NSString*)postGEDate
                                  andPostGETime:(NSString*)postGETime
                              andPostGELatitude:(double)postGELatitude
                             andPostGELongitude:(double)postGELongitude
                                  andPostStress:(int)postStress
                           andPostAttentiveness:(int)postAttentiveness
                                    andPostMood:(int)postMood
                                  andPostEnergy:(int)postEnergy
                                       andLight:(NSString*)light
                                    andMoisture:(NSString*)moisture
                                    andActivity:(NSString*)activity
                                     andFeeling:(NSString*)feeling
                                  andConnection:(int)connection
                                  andStrategies:(NSString*)strategies
                                      andSocial:(NSString*)social
                               andPhotoFileName:(NSString*)photoFileName
                                andPhotoFeeling:(NSString*)photoFeeling
                               andFinalComments:(NSString*)finalComments
                              andSendSurveyDate:(NSString*)sendSurveyDate
                              andSendSurveyTime:(NSString*)sendSurveyTime
                       andDidTransmitThisRecord:(int)didTransmitThisRecord
{
    // Save survey data to a record of the local database table SurveyData.
    
    
    static int idSurvey = 0;   // principal key for the table
    
    int retVal = -1;
    
    NSString* idParticipantCode = [NSString stringWithString:[self getMyIdentity]]; // read the participant's unique identity.
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idSurvey.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idSurvey from SurveyData order by idSurvey desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idSurvey = sqlite3_column_int(statement, 0) + 1;  // idSurvey: add 1 to get next value for principal key.
            retVal = idSurvey;
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    // query
    qsql = [NSString stringWithFormat:@"INSERT INTO SurveyData values (%d, '%@', '%@', '%@', '%@', %d, %d, %d, %d, '%@', '%@', %f, %f, '%@', '%@', %f, %f, %d, %d, %d, %d, '%@', '%@', '%@', '%@', %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d)",
            idSurvey,           // int
            idParticipantCode,  // string
            startSurveyDate,    // string
            startSurveyTime,    // string
            location,           // string
            preStress,          // int
            preAttentiveness,   // int
            preMood,            // int
            preEnergy,          // int
            preGEDate,          // string
            preGETime,          // string
            preGELatitude,      // float
            preGELongitude,     // float
            postGEDate,         // string
            postGETime,         // string
            postGELatitude,     // float
            postGELongitude,    // float
            postStress,         // int
            postAttentiveness,  // int
            postMood,           // int
            postEnergy,         // int
            light,              // string
            moisture,           // string
            activity,           // string
            feeling,            // string
            connection,         // int
            strategies,         // string
            social,             // string
            photoFileName,      // string
            photoFeeling,       // string
            finalComments,      // string
            sendSurveyDate,     // string
            sendSurveyTime,     // string
            didTransmitThisRecord]; // int
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return retVal;
}






-(void) checkTransmitConfirmationSurveyRecordWithParticipantCode:(NSString*)pc
                                                     andRecordID:(int)recordID
{
//    BackendlessDataQuery *query = [BackendlessDataQuery query];
//    
//    query.whereClause = [NSString stringWithFormat:@"participantCode = \'%@\' AND recordID = %d", pc, recordID];
//    
//    Responder *responder = [Responder responder:self selResponseHandler:@selector(responseHandler:) selErrorHandler:@selector(errorHandler:)];
//    
//    [[backendless.persistenceService of:[CSurveyDataRDB class]] find:query responder:responder];
}

- (void)responseHandler:(id)response
{
    NSLog(@"responseHandler:Schedule Sent; class = %@", [response class]);
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    NSMutableArray* data = [[NSMutableArray alloc] initWithArray:[(BackendlessCollection *)response data]];
//    
//    if ([data count] > 0)
//    {
//        // corresponding record(s) was found in the remote database table
//        
//        // In the SurveyData table, for the record with recordID matching the value in data, set the confirmed transmitted bit.
//        int recordID = (int)((CSurveyDataRDB*)[data objectAtIndex:0]).recordID;
//        
//        [self setTransmitConfirmedBitForSurveyRecordWithID:recordID];
//        
//    }
    
}




-(void) checkTransmitConfirmationScheduleRecordWithParticipantCode:(NSString*)pc
                                                     andRecordID:(int)recordID
{
//    BackendlessDataQuery *query = [BackendlessDataQuery query];
//    
//    query.whereClause = [NSString stringWithFormat:@"participantCode = \'%@\' AND recordID = %d", pc, recordID];
//    
//    Responder *responder = [Responder responder:self selResponseHandler:@selector(responseHandlerT2:) selErrorHandler:@selector(errorHandler:)];
//    
//    [[backendless.persistenceService of:[CScheduleDataRDB class]] find:query responder:responder];
}

- (void)responseHandlerT2:(id)response
{
    NSLog(@"responseHandler: class = %@", [response class]);
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    NSMutableArray* data = [[NSMutableArray alloc] initWithArray:[(BackendlessCollection *)response data]];
//    
//    if ([data count] > 0)
//    {
//        // corresponding record(s) was found in the remote database table
//        
//        // In the SurveyData table, for the record with recordID matching the value in data, set the confirmed transmitted bit.
//        int recordID = (int)((CScheduleDataRDB*)[data objectAtIndex:0]).recordID;
//        
//        [self setTransmitConfirmedBitForScheduleRecordWithID:recordID];
//        
//    }
}




-(void) checkTransmitConfirmationProddingsRecordWithParticipantCode:(NSString*)pc
                                                     andRecordID:(int)recordID
{
//    BackendlessDataQuery *query = [BackendlessDataQuery query];
//    
//    query.whereClause = [NSString stringWithFormat:@"participantCode = \'%@\' AND recordID = %d", pc, recordID];
//    
//    Responder *responder = [Responder responder:self selResponseHandler:@selector(responseHandlerT3:) selErrorHandler:@selector(errorHandler:)];
//    
//    [[backendless.persistenceService of:[CReminderDataRDB class]] find:query responder:responder];
}

- (void)responseHandlerT3:(id)response
{
    NSLog(@"responseHandler: class = %@", [response class]);
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    NSMutableArray* data = [[NSMutableArray alloc] initWithArray:[(BackendlessCollection *)response data]];
//    
//    if ([data count] > 0)
//    {
//        // corresponding record(s) was found in the remote database table
//        
//        // In the SurveyData table, for the record with recordID matching the value in data, set the confirmed transmitted bit.
//        int recordID = (int)((CReminderDataRDB*)[data objectAtIndex:0]).recordID;
//        
//        [self setTransmitConfirmedBitForProddingsRecordWithID:recordID];
//        
//    }
}






//- (void)errorHandler:(Fault *)fault
//{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    
//    NSLog(@"%@", fault.faultCode);
//    
//}




-(void) setTransmitConfirmedBitForSurveyRecordWithID:(int)recordID
{
    // Set the didTransmitThisRecord flag = 1 in SurveyData table for the record with idSurvey = recordID.
    
    [[DatabaseController sharedManager] openDB];
    
    NSString *qsql = [NSString stringWithFormat:@"UPDATE SurveyData set didTransmitThisRecord = replace(didTransmitThisRecord, 0, 1) where idSurvey = %d", recordID];
    
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







-(void) setTransmitConfirmedBitForScheduleRecordWithID:(int)recordID
{
    // Set the didTransmitThisRecord flag = 1 in ScheduleData table for the record with idGreenExperience = recordID.
    
    [[DatabaseController sharedManager] openDB];
    
    NSString *qsql = [NSString stringWithFormat:@"UPDATE ScheduleData set didTransmitThisRecord = replace(didTransmitThisRecord, 0, 1) where idGreenExperience = %d", recordID];
    
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







-(void) setTransmitConfirmedBitForProddingsRecordWithID:(int)recordID
{
    // Set the didTransmitThisRecord flag = 1 in ScheduleProddingsData table for the record with idProd = recordID.
    
    [[DatabaseController sharedManager] openDB];
    
    NSString *qsql = [NSString stringWithFormat:@"UPDATE ScheduleProddingsData set didTransmitThisRecord = replace(didTransmitThisRecord, 0, 1) where idProd = %d", recordID];
    
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







-(NSMutableArray*) getAllUnconfirmedSurveyRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idSurvey, idParticipantCode FROM SurveyData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CTableRecordIDDatum* datum = [[CTableRecordIDDatum alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // idRecord
//            char* c = (char *) sqlite3_column_text(statement, 1);  // idParticipantCode
//            
//            datum.idParticipantCode = [[NSString alloc] initWithUTF8String:c];
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}




-(NSMutableArray*) getAllUnconfirmedScheduleRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idGreenExperience, idParticipantCode FROM ScheduleData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CTableRecordIDDatum* datum = [[CTableRecordIDDatum alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // idRecord
//            char* c = (char *) sqlite3_column_text(statement, 1);  // idParticipantCode
//            
//            datum.idParticipantCode = [[NSString alloc] initWithUTF8String:c];
//            
//            [arr addObject:datum];
//            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}




-(NSMutableArray*) getAllUnconfirmedProddingsRecords
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idProd, idParticipantCode FROM ScheduleProddingsData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CTableRecordIDDatum* datum = [[CTableRecordIDDatum alloc] init];    // allocate a new object, each pass through loop
//            datum.idRecord  = sqlite3_column_int(statement, 0);  // idRecord
//            char* c = (char *) sqlite3_column_text(statement, 1);  // idParticipantCode
//            
//            datum.idParticipantCode = [[NSString alloc] initWithUTF8String:c];
//            
//            [arr addObject:datum];
//            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}




-(void) transmitAllUnconfirmedSurveyRecords
{
    // Find the records in the local table SurveyData which are unconfirmed.
    // For those records, try to transmit them to the remote database.
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idSurvey, idParticipantCode, startSurveyDate, startSurveyTime, location, preStress, preAttentiveness, preMood, preEnergy, preGEDate, preGETime, preGELatitude, preGELongitude, postGEDate, postGETime, postGELatitude, postGELongitude, postStress, postAttentiveness, postMood, postEnergy, light, moisture, activity, feeling, connection, strategies, social, photoFileName, photoFeeling, finalComments, sendSurveyDate, sendSurveyTime FROM SurveyData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CSurveyDataRDB* datum = [[CSurveyDataRDB alloc] init];    // allocate a new object, each pass through loop
//            
//            datum.recordID  = sqlite3_column_int(statement, 0);  // idSurvey
//            char* c = (char *) sqlite3_column_text(statement, 1); datum.participantCode = [[NSString alloc] initWithUTF8String:c];  // idParticipantCode
//            c = (char *) sqlite3_column_text(statement, 2); datum.startSurveyDate = [[NSString alloc] initWithUTF8String:c];  // startSurveyDate
//            c = (char *) sqlite3_column_text(statement, 3); datum.startSurveyTime = [[NSString alloc] initWithUTF8String:c];  // startSurveyTime
//            c = (char *) sqlite3_column_text(statement, 4); datum.q2 = [[NSString alloc] initWithUTF8String:c];  // q2 (location)
//            datum.q3 = sqlite3_column_int(statement, 5);  // q3 (preStress)
//            datum.q4 = sqlite3_column_int(statement, 6);  // q4 (preAttentiveness)
//            datum.q5 = sqlite3_column_int(statement, 7);  // q5 (preMood)
//            datum.q6 = sqlite3_column_int(statement, 8);  // q6 (preEnergy)
//            c = (char *) sqlite3_column_text(statement, 9); datum.preGEDate = [[NSString alloc] initWithUTF8String:c];  // preGEDate
//            c = (char *) sqlite3_column_text(statement, 10); datum.preGETime = [[NSString alloc] initWithUTF8String:c];  // preGETime
//            datum.preGELatitude = sqlite3_column_double(statement, 11);  // preGELatitude
//            datum.preGELongitude = sqlite3_column_double(statement, 12);  // preGELongitude
//            c = (char *) sqlite3_column_text(statement, 13); datum.postGEDate = [[NSString alloc] initWithUTF8String:c];  // postGEDate
//            c = (char *) sqlite3_column_text(statement, 14); datum.postGETime = [[NSString alloc] initWithUTF8String:c];  // postGETime
//            datum.postGELatitude = sqlite3_column_double(statement, 15);  // postGELatitude
//            datum.postGELongitude = sqlite3_column_double(statement, 16);  // postGELongitude
//            datum.q7 = sqlite3_column_int(statement, 17);  // q7 (postStress)
//            datum.q8 = sqlite3_column_int(statement, 18);  // q8 (postAttentiveness)
//            datum.q9 = sqlite3_column_int(statement, 19);  // q9 (postMood)
//            datum.q10 = sqlite3_column_int(statement, 20);  // q10 (postEnergy)
//            c = (char *) sqlite3_column_text(statement, 21); datum.q11 = [[NSString alloc] initWithUTF8String:c];  // q11 (light)
//            c = (char *) sqlite3_column_text(statement, 22); datum.q12 = [[NSString alloc] initWithUTF8String:c];  // q12 (moisture)
//            c = (char *) sqlite3_column_text(statement, 23); datum.q13 = [[NSString alloc] initWithUTF8String:c];  // q13 (activity)
//            c = (char *) sqlite3_column_text(statement, 24); datum.q14 = [[NSString alloc] initWithUTF8String:c];  // q14 (feeling)
//            datum.q15 = sqlite3_column_int(statement, 25);  // q15 (connection)
//            c = (char *) sqlite3_column_text(statement, 26); datum.q16 = [[NSString alloc] initWithUTF8String:c];  // q16 (strategies)
//            c = (char *) sqlite3_column_text(statement, 27); datum.q17 = [[NSString alloc] initWithUTF8String:c];  // q17 (social)
//            c = (char *) sqlite3_column_text(statement, 28); datum.imageFile = [[NSString alloc] initWithUTF8String:c];  // imageFile (photoFileName)
//            c = (char *) sqlite3_column_text(statement, 29); datum.q18 = [[NSString alloc] initWithUTF8String:c];  // q18 (light)
//            c = (char *) sqlite3_column_text(statement, 30); datum.q19 = [[NSString alloc] initWithUTF8String:c];  // q19 (light)
//            c = (char *) sqlite3_column_text(statement, 31); datum.sendSurveyDate = [[NSString alloc] initWithUTF8String:c];  // sendSurveyDate
//            c = (char *) sqlite3_column_text(statement, 32); datum.sendSurveyTime = [[NSString alloc] initWithUTF8String:c];  // sendSurveyTime
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    
    
    if ([arr count]> 0)
    {
        // Some unconfirmed records were read from the local database table
        
        // For each record, try to resend it.
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            Responder* responder = [Responder responder:self
//                                     selResponseHandler:@selector(responseHandler2:)
//                                        selErrorHandler:@selector(errorHandler:)];
//            
//            CSurveyDataRDB* record = (CSurveyDataRDB*)[arr objectAtIndex:idx];
//            
//            id<IDataStore> dataStore = [backendless.persistenceService of:[CSurveyDataRDB class]];
//            
//            [dataStore save:record responder:responder];
        }
    }
    
}



-(void) transmitAllUnconfirmedScheduleRecords
{
    // Find the records in the local table ScheduleData which are unconfirmed.
    // For those records, try to transmit them to the remote database.
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idGreenExperience, idParticipantCode, dateScheduleMade, timeScheduleMade, dateGE, timeGE, locationGE, promptPhrase, usedPhoneAlertPrompts, usedEmailPrompts FROM ScheduleData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CScheduleDataRDB* datum = [[CScheduleDataRDB alloc] init];    // allocate a new object, each pass through loop
//            
//            datum.recordID  = sqlite3_column_int(statement, 0);  // idGreenExperience
//            char* c = (char *) sqlite3_column_text(statement, 1); datum.participantCode = [[NSString alloc] initWithUTF8String:c];  // idParticipantCode
//            c = (char *) sqlite3_column_text(statement, 2); datum.dateScheduleMade = [[NSString alloc] initWithUTF8String:c];  // dateScheduleMade
//            c = (char *) sqlite3_column_text(statement, 3); datum.timeScheduleMade = [[NSString alloc] initWithUTF8String:c];  // timeScheduleMade
//            c = (char *) sqlite3_column_text(statement, 4); datum.dateGE = [[NSString alloc] initWithUTF8String:c];  // dateGE
//            c = (char *) sqlite3_column_text(statement, 5); datum.timeGE = [[NSString alloc] initWithUTF8String:c];  // timeGE
//            c = (char *) sqlite3_column_text(statement, 6); datum.locationGE = [[NSString alloc] initWithUTF8String:c];  // locationGE
//            c = (char *) sqlite3_column_text(statement, 7); datum.phrase = [[NSString alloc] initWithUTF8String:c];  // phrase
//            datum.notifyByPhone = sqlite3_column_int(statement, 8);  // notifyByPhone
//            datum.notifyByEmail = sqlite3_column_int(statement, 9);  // notifyByEmail
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    
    
    if ([arr count]> 0)
    {
        // Some unconfirmed records were read from the local database table
        
        // For each record, try to resend it.
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            Responder* responder = [Responder responder:self
//                                     selResponseHandler:@selector(responseHandler3:)
//                                        selErrorHandler:@selector(errorHandler:)];
//            
//            CScheduleDataRDB* record = (CScheduleDataRDB*)[arr objectAtIndex:idx];
//            
//            id<IDataStore> dataStore = [backendless.persistenceService of:[CScheduleDataRDB class]];
//            
//            [dataStore save:record responder:responder];
        }
    }
    
}



-(void) transmitAllUnconfirmedProddingsRecords
{
    // Find the records in the local table ScheduleProddingsData which are unconfirmed.
    // For those records, try to transmit them to the remote database.
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT idProd, idParticipantCode, dateSent FROM ScheduleProddingsData where didTransmitThisRecord = 0"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            CReminderDataRDB* datum = [[CReminderDataRDB alloc] init];    // allocate a new object, each pass through loop
//            
//            datum.recordID  = sqlite3_column_int(statement, 0);  // idProd
//            char* c = (char *) sqlite3_column_text(statement, 1); datum.participantCode = [[NSString alloc] initWithUTF8String:c];  // idParticipantCode
//            c = (char *) sqlite3_column_text(statement, 2); datum.dateSent = [[NSString alloc] initWithUTF8String:c];  // dateSent
//            
//            [arr addObject:datum];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    
    
    if ([arr count]> 0)
    {
        // Some unconfirmed records were read from the local database table
        
        // For each record, try to resend it.
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            Responder* responder = [Responder responder:self
//                                     selResponseHandler:@selector(responseHandler4:)
//                                        selErrorHandler:@selector(errorHandler:)];
//            
//            CReminderDataRDB* record = (CReminderDataRDB*)[arr objectAtIndex:idx];
//            
//            id<IDataStore> dataStore = [backendless.persistenceService of:[CReminderDataRDB class]];
//            
//            [dataStore save:record responder:responder];
        }
    }
    
}



-(id)responseHandler2:(id)response
{
    NSLog(@"Response handler for transmitAllUnconfirmedSurveyRecords. Response = %@", response);
    
    return response;
}





-(id)responseHandler3:(id)response
{
    NSLog(@"Response handler for transmitAllUnconfirmedScheduleRecords. Response = %@", response);
    
    return response;
}





-(id)responseHandler4:(id)response
{
    NSLog(@"Response handler for transmitAllUnconfirmedProddingsRecords. Response = %@", response);
    
    return response;
}






-(void) updateLocalTransmissionFlags
{
    // Update the local values of the didTransmitThisRecord flags, based on contents of remote database tables.
    
    
    
    // Loop over records in SurveyData table of the local database and get an array of any which have
    // didTransmitThisRecord = 0.
    
    // For any such records, get the value of idSurvey and idParticipantCode.
    
    // For these values, check in the remote database for corresponding records, and if found set the didTransmitThisRecord = 1 in SurveyData.
    
    NSMutableArray* arr = [self getAllUnconfirmedSurveyRecords];
    
    
    if ([arr count] > 0)
    {
        // There are some unconfirmed records in SurveyData.
        
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            CTableRecordIDDatum* datum = [arr objectAtIndex:idx];
//            
//            // Find the records in the local table which are unconfirmed.  For those records, look for them in the remote database.
//            // If found, confirm them in the local database.
//            [self checkTransmitConfirmationSurveyRecordWithParticipantCode:datum.idParticipantCode
//                                                               andRecordID:datum.idRecord];
        }
    }
    
    
    
    
    ///*
    // Loop over records in ScheduleData table of the local database and get an array of any which have
    // didTransmitThisRecord = 0.
    
    // For any such records, get the value of idGreenExperience and idParticipantCode.
    
    // For these values, check in the remote database for corresponding records, and if found set the didTransmitThisRecord = 1 in ScheduleData.
    
    arr = [self getAllUnconfirmedScheduleRecords];
    
    
    if ([arr count] > 0)
    {
        // There are some unconfirmed records in ScheduleData.
        
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            CTableRecordIDDatum* datum = [arr objectAtIndex:idx];
//            
//            // Find the records in the local table which are unconfirmed.  For those records, look for them in the remote database.
//            // If found, confirm them in the local database.
//            [self checkTransmitConfirmationScheduleRecordWithParticipantCode:datum.idParticipantCode
//                                                                 andRecordID:datum.idRecord];
        }
    }
    
    
    
    
    
    
    // Loop over records in ScheduleProddingsData table of the local database and get an array of any which have
    // didTransmitThisRecord = 0.
    
    // For any such records, get the value of idProd and idParticipantCode.
    
    // For these values, check in the remote database for corresponding records, and if found set the didTransmitThisRecord = 1 in ScheduleProddingsData.
    
    arr = [self getAllUnconfirmedProddingsRecords];
    
    
    if ([arr count] > 0)
    {
        // There are some unconfirmed records in ScheduleProddingsData.
        
        for (int idx = 0; idx < [arr count]; idx++)
        {
//            CTableRecordIDDatum* datum = [arr objectAtIndex:idx];
//            
//            // Find the records in the local table which are unconfirmed.  For those records, look for them in the remote database.
//            // If found, confirm them in the local database.
//            [self checkTransmitConfirmationProddingsRecordWithParticipantCode:datum.idParticipantCode
//                                                                  andRecordID:datum.idRecord];
        }
    }
    
}




-(void) transmitAllUnconfirmedRecords
{
    // Attempt to send records that are not in the remote database.

    NSMutableArray* arr = [self getAllUnconfirmedSurveyRecords];
    if ([arr count] > 0)
    {
        // There are some records in the local database SurveyData table that have not been sent.
        // Try to send them now.
        
        [self transmitAllUnconfirmedSurveyRecords];
    }
    
    
    
    arr = [self getAllUnconfirmedScheduleRecords];
    if ([arr count] > 0)
    {
        // There are some records in the local database ScheduleData table that have not been sent.
        // Try to send them now.
        
        [self transmitAllUnconfirmedScheduleRecords];
    }
    
    
    
    
    arr = [self getAllUnconfirmedProddingsRecords];
    if ([arr count] > 0)
    {
        // There are some records in the local database ScheduleProddingsData table that have not been sent.
        // Try to send them now.
        
        [self transmitAllUnconfirmedProddingsRecords];
    }
}




-(void) sendAllMissingPhotos
{
    // Send any photos which are present in the sandbox, but are not present in the remote file server.
    
    
    // Procedure:
    // Get a list of the photo file names in the sandbox.
    
    // Get a list of the photo file names present on the remote file server.
    
    // Form a list of photo file names which are local but not found remotely.
    
    // If this latter list has anything, transmit the photos with these file names to the remote file server.
    // -------------------------------------------------------------------------------------------------------------
    
    
    
    
    // Get a list of the photo file names in the sandbox.
    NSMutableArray* arrLocalAllFiles = nil;
    NSMutableArray* arrLocalPhotos = nil;
    NSArray *documentArray = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count] > 0)
    {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError *error = nil;
        documentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if(error)
        {
            NSLog(@"Could not get list of documents in directory, error = %@",error);
        }
    }
    
    arrLocalAllFiles = [[NSMutableArray alloc] initWithArray:documentArray];    // This is a list of all file names in the sandbox.
    arrLocalPhotos = [[NSMutableArray alloc] init];
    
    // Copy filenames that end in ".png" to arrLocalPhotos
    for (int idx = 0; idx < [arrLocalAllFiles count]; idx++)
    {
        NSString* fn = (NSString*)[arrLocalAllFiles objectAtIndex:idx];
        
        BOOL bIsPhoto = [fn hasSuffix:@".png"]; // YES if this is a png photo.
        
        if (bIsPhoto)
        {
            // This file is a photo.  Copy its filename.
            [arrLocalPhotos addObject:[arrLocalAllFiles objectAtIndex:idx]];
        }
        
    }
    // arrLocalPhotos now contains the names of all ".png" files in the sandbox.
    
    
    
    
    
    // Get a list of the photo file names present on the remote file server.
    NSMutableArray* arrRemotePhotos = [[NSMutableArray alloc] initWithArray:[self getAllRemotePhotoFileNames]];
    
    NSMutableArray* arrPhotosToSend = [[NSMutableArray alloc] init];
    
    for (int idx = 0; idx < [arrLocalPhotos count]; idx++) // Loop over all local photos.
    {
        NSString* localFN = (NSString*) [arrLocalPhotos objectAtIndex:idx];
        BOOL bLocalPhotoFound = NO; // flag becomes YES if this local photo is found among the remote photos
        for (int remoteIdx = 0; remoteIdx < [arrRemotePhotos count]; remoteIdx++)   // for each local photo, loop over remote photos.
        {
            // Check whether the given local photo is found among the remote photos.
            NSString* remoteFN = (NSString*) [arrRemotePhotos objectAtIndex:remoteIdx];
            
            if ([localFN isEqualToString:remoteFN])
            {
                // The local photo is found among the remote photos.
                // set the flag YES, and leave this loop
                bLocalPhotoFound = YES;
                break;
            }
            
        }
        
        if (!bLocalPhotoFound)
        {
            // local photo was not found among the remote photos.
            [arrPhotosToSend addObject:localFN];
        }
        
    }
   
    
    // If this latter list has anything, transmit the photos with these file names to the remote file server.
    if ([arrPhotosToSend count] > 0)
    {
        for (int idx = 0; idx < [arrPhotosToSend count]; idx++)
        {
//            NSString* fn = [arrPhotosToSend objectAtIndex:idx];
//        NSString* pathToFile = [((CAppDelegate*) [UIApplication sharedApplication].delegate).documentsPath stringByAppendingPathComponent:fn];
//        
//        
//            NSData* pngData = [NSData dataWithContentsOfFile:pathToFile];
//            
//        
//        
//        // Send the photo to backendless file service.
//        Responder* responderPhoto = [Responder responder:self
//                                      selResponseHandler:@selector(responseHandlerPhoto:)
//                                         selErrorHandler:@selector(errorHandler:)];
//        
//        [backendless.fileService upload:fn content:pngData responder:responderPhoto];
       
        }
        
        
        
    }
    
}




-(id)responseHandlerPhoto:(id)response
{
    NSLog(@"Response handler for sendAllMissingPhotos photo save.  Response = %@", response);
    
//    BackendlessFile* f = (BackendlessFile*)response;
//    
//    NSString* url = [NSString stringWithString:f.fileURL];
//    NSLog(@"File URL = %@", url);
//    
//    NSString* fn = [url lastPathComponent];
//    NSLog(@"File name = %@", fn);
//    
//    [self saveToRemotePhotoFileNamesWithURL:url andFileName:fn ];
    
    return response;
}






-(int) saveToRemotePhotoFileNamesWithURL:(NSString*)url
                              andFileName:(NSString*)fn
{
    static int idPhoto = 0;   // principal key for the table
    
    int retVal = 0;
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    // query: find the highest existing value of idPhoto.
    NSString *qsql = [NSString stringWithFormat:@"SELECT idPhoto from RemotePhotoFileNames order by idPhoto desc limit 1"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            idPhoto = sqlite3_column_int(statement, 0) + 1;  // idPhoto: add 1 to get next value for principal key.
            retVal = idPhoto;
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    
    // query
    qsql = [NSString stringWithFormat:@"INSERT INTO RemotePhotoFileNames values (%d, '%@', '%@')", idPhoto, url, fn];
    
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        sqlite3_step(statement);
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    
    
    [[DatabaseController sharedManager] closeDB];
    
    return retVal;
    
}





-(NSMutableArray*) getAllRemotePhotoFileNames
{
    // Return an array of all of the ".png" filenames present in the RemotePhotoFileNames table.
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    
    [[DatabaseController sharedManager] openDB];
    
    
    //—-retrieve rows—-
    NSString *qsql = [NSString stringWithFormat:@"SELECT photoFileName FROM RemotePhotoFileNames"];
    
    sqlite3_stmt *statement;
    if ([[DatabaseController sharedManager] prepareSqlStatement:&statement fromQuery:qsql])
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char* c = (char *) sqlite3_column_text(statement, 0);  // file name
            
            NSString* fn = [[NSString alloc] initWithUTF8String:c];
            
            [arr addObject:fn];
            
        }
        
        
        sqlite3_reset(statement);
        
        //—-deletes the compiled statement from memory—-
        sqlite3_finalize(statement);
    }
    [[DatabaseController sharedManager] closeDB];
    
    return arr;
}










@end
