//
//  CDatabaseInterface.h
//  NaturePill
//
//  Created by Dr. John M. Hinckley on 5/26/14.
//  Copyright (c) 2014 Gurmentor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Schedule_Rec.h"
#import "Notifications_Rec.h"

@interface CDatabaseInterface : NSObject
{
    sqlite3 *db;    // pointer to an sqlite3 structure
}



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- singleton ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



+(CDatabaseInterface*) sharedManager;



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- MyStatus ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



// read
-(int) getActivationStatus;
-(int) getBaselineSurveyStatus;

// write
-(void) saveAppActivationState:(int)activationValue;
-(void) saveBaselineSurveyStatus:(int)statusValue;



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- RDB: Participants ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



// read
-(NSString*) getParticipantCodeWithMatchingActivation:(NSString*)activationCode;



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- MyIdentity ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



// read
-(NSString*) getMyIdentity;

// write
-(void) saveMyIdentityAs:(NSString*)idParticipantCode;



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- Schedule ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



// write
-(void) saveSchedule:(Schedule_Rec*) rec;

// read
-(Schedule_Rec*) getLatestSchedule;

// write
-(int) saveNotification:(Notifications_Rec*) rec;   // returns the value of the record id

// read
-(Notifications_Rec*) getNotification;

// read
-(NSMutableArray*) getAllUngeneratedNotificationRecords;

// delete
-(void) deleteNotification:(int)idRecord;

// write
-(void) saveNumberDoneEvents:(int)num;

// read
-(int) getNumberDoneEvents;

// write
-(void) saveTotalNumberEvents:(int)num;

// read
-(int) getTotalNumberEvents;



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------------------- not used ------------------------



//---------------------------------------------------------------------------------------------------------------------------------



// ----------------------------- Table: AppAction_GEPrompt --------------------------------------

// write
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
                           andDone:(NSInteger)done;

-(void) setGEPromptRecordDoneForRecord:(int)idRecord;









// ----------------------------- Table: AppAction_Retransmit --------------------------------------
// read
-(int*) getEarliestRetransmitRecord;

// write
-(void) saveScheduleRetransmitRecordWithYear:(NSInteger)year
                                    andMonth:(NSInteger)month
                                      andDay:(NSInteger)day
                                     andHour:(NSInteger)hour
                                   andMinute:(NSInteger)minute;






// ----------------------------- Table: AppAction_ScheduleOpen --------------------------------------
// read
-(int*) getEarliestOpenRecord;

-(int) getLatestDoneOpenWeek;

// write
-(void) saveScheduleOpenRecordWithYear:(NSInteger)year
                              andMonth:(NSInteger)month
                                andDay:(NSInteger)day
                               andHour:(NSInteger)hour
                             andMinute:(NSInteger)minute
                             andWeekID:(NSInteger)idWeek;

-(void) setOpenRecordDoneForId:(int)idOpen;

-(void) setAllOpenRecordsDoneBeforeYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute;






// ----------------------------- Table: AppAction_ScheduleProd --------------------------------------
// read
-(NSMutableArray*) getAllUndoneProdRecords;

// write
-(void) saveScheduleProdRecordWithYear:(NSInteger)year
                              andMonth:(NSInteger)month
                                andDay:(NSInteger)day
                               andHour:(NSInteger)hour
                             andMinute:(NSInteger)minute
                             andWeekID:(NSInteger)idWeek;

-(void) setProdRecordDoneForWeek:(int)idWeek;






// ----------------------------- Table: MakeSchedule --------------------------------------
// read
-(int) getUserDoneForWeek:(int)idWeek;

// write
-(void) saveMakeScheduleRecordWithWeekID:(NSInteger)idWeek;

-(void) setUserDoneForCurrentWeek;






// ----------------------------- Table: MotivationalPhrases --------------------------------------
// read
-(NSMutableArray*) getAllMyPhrases;












// ----------------------------- Table: ScheduleData --------------------------------------
// write
-(int) saveScheduleDataRecordWithDateScheduleMade:(NSString*)dateScheduleMade
                               andTimeSchedlueMade:(NSString*)timeScheduleMade
                                         andDateGE:(NSString*)dateGE
                                         andTimeGE:(NSString*)timeGE
                                     andLocationGE:(NSString*)locationGE
                                   andPromptPhrase:(NSString*)promptPhrase
                                      andUsedPhone:(NSInteger)usedPhone
                                      andUsedEmail:(NSInteger)usedEmail
                          andDidTransmitThisRecord:(NSInteger)didTransmitThisRecord;

-(NSMutableArray*) getAllUnconfirmedScheduleRecords;






// ----------------------------- Table: ScheduleProddingsData --------------------------------------
// write
-(int) saveScheduleProddingsDataRecordWithDateProd:(NSString*)dateSent
                         andDidTransmitThisRecord:(NSInteger)didTransmitThisRecord;

-(NSMutableArray*) getAllUnconfirmedProddingsRecords;






// ----------------------------- Table: SurveyData --------------------------------------
// write
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
                       andDidTransmitThisRecord:(int)didTransmitThisRecord;

-(NSMutableArray*) getAllUnconfirmedSurveyRecords;






// ============================= Backendless Database ===================================

// ----------------------------- Table: CSurveyDataRDB --------------------------------------
// read
-(void) checkTransmitConfirmationSurveyRecordWithParticipantCode:(NSString*)pc
                                                     andRecordID:(int)recordID;

// write
-(void) transmitAllUnconfirmedSurveyRecords;







// ----------------------------- Table: CScheduleDataRDB --------------------------------------
// read
-(void) checkTransmitConfirmationScheduleRecordWithParticipantCode:(NSString*)pc
                                                     andRecordID:(int)recordID;

// write
-(void) transmitAllUnconfirmedScheduleRecords;







// ----------------------------- Table: CReminderDataRDB --------------------------------------
// read
-(void) checkTransmitConfirmationProddingsRecordWithParticipantCode:(NSString*)pc
                                                        andRecordID:(int)recordID;

// write
-(void) transmitAllUnconfirmedProddingsRecords;




















// ----------------------------- Table: RemotePhotoFileNames --------------------------------------
// read
-(NSMutableArray*) getAllRemotePhotoFileNames;

// write
-(int) saveToRemotePhotoFileNamesWithURL:(NSString*)url
                              andFileName:(NSString*)fn;













// ----------------------------- Multi-table --------------------------------------
// read and write
-(void) updateLocalTransmissionFlags;

-(void) transmitAllUnconfirmedRecords;













// ----------------------------- Photos --------------------------------------
-(void) sendAllMissingPhotos;


@end
