//
//  AppDelegate.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 1/29/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "DatabaseController.h"
#import "Backendless.h"
#import "ScheduleManager.h"
#import "CDatabaseInterface.h"
#import "CActivationManager.h"
#import "StartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navigationControllerMain;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Get the version of the OS:
    NSString* osVer = [[UIDevice currentDevice] systemVersion];
    NSRange r = [osVer rangeOfString:@"."]; // find the first occurrence of "."
    NSString* osMajVer = [osVer substringToIndex:r.location];
    NSInteger verMajor = [osMajVer integerValue];
    
    if (verMajor > 7)
    {
        //registering for sending user various kinds of notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    
    
    
    
    
    
    
    
    [GlobalData sharedManager].activated = ACTIVATED_NO;
    [GlobalData sharedManager].initialPass = INITIAL_PASS_YES;
    [GlobalData sharedManager].theTabBarController = nil;
    
    
    
    
    
    
    // Setup backendless
    [backendless initApp:BackendlessApplicationID secret:BackendlessIOSSecretKey version:BackendlessApplicationVer];
    
    
    
    
    
    // Set up the database in the sandbox, if it is not already there.
    [[DatabaseController sharedManager] createDatabase];
    
    
    
    
    
    // Figure out total number of events this week.
    int n = (int)[[ScheduleManager sharedManager] getTotalNumberEvents];
    if (n < 3 || n > 15)
    {
        // record was not found in database
        // establish defaults.
        [GlobalData sharedManager].frequency = 7;
    }
    else
    {
        // record was found in database.  use the value read.
        [GlobalData sharedManager].frequency = n;
    }
    [[ScheduleManager sharedManager] setTotalNumberEvents:[GlobalData sharedManager].frequency];
    
    
    
    if ([[CDatabaseInterface sharedManager] getNumberDoneEvents] <= 0)
    {
        // If this function returns zero done events, this could be because actually there are zero done events or because this particular record does not exist in the database.
        
        // if the record was not found, the function will return -1.
        
        // Either way, write zero done events to the database.
        [[ScheduleManager sharedManager] setNumberDoneEvents:0];
    }
    else
    {
        // positive number of done events was read from the database.  leave it alone.
    }
    
    
    
    
    // Handle launching from a notification
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notif)
    {
        application.applicationIconBadgeNumber = 0;
        
        int numDone = [[CDatabaseInterface sharedManager] getNumberDoneEvents]; // get the number of done events
        [[ScheduleManager sharedManager] setNumberDoneEvents:(numDone+1)];    // increment it by 1
    }
    
    
    

    return YES;
}







- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}





- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    
    // This routine is called in the following situation:
    // The phone is on, displaying the "desktop".
    // The TinyShifts app is not in the foreground.
    // A notification fires.
    // User acknowledges it by pressing the message box.
    // In response to pressing the message box, the app is started, displaying the start screen.
    // The the app runs this routine.

    
    application.applicationIconBadgeNumber = 0;
   
    int appIsActivated = [[CActivationManager sharedManager] getActivationStatus];
    if (appIsActivated)
    {
        // app has been activated.
        int State = [[CDatabaseInterface sharedManager] getBaselineSurveyStatus];
        if (State != 0)
        {
            // Initial, baseline survey has been done.
            
            // Schedule next notification, if none are currently scheduled.
            // Are there already any scheduled local notifications?
            NSArray* arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];    // Get the array of scheduled local notifications
            
            // Are there any?
            if ([arrNotifications count] <= 0)
            {
                // No:
                // Schedule one.
                [[ScheduleManager sharedManager] setNextLocalNotification];    // start the timer for the next local notification.
            }
        }
    }
    
    
    
    
   // Examine all records in the Notifications table.
    // If any have a fire time that is earlier than now, generate the corresponding alert messages.
    
    
    
//    // Examine each record in Notifications table where alertWasGenerated = 0.
//    NSMutableArray* arr = [[CDatabaseInterface sharedManager] getAllUngeneratedNotificationRecords];
//    
//    if ([arr count] > 0)
//    {
//        // There are some ungenerated records.
//        
//        NSCalendar *c = [NSCalendar currentCalendar];
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        
//        NSDate* now = [NSDate date];    // The time right now.
//        
//        // For each, are they earlier than now?
//        for (int idx = 0; idx < [arr count]; idx++)
//        {
//            Notifications_Rec* rec = (Notifications_Rec*)[arr objectAtIndex:idx];
//            
//            // Get a NSDate object from the components of the record
//            [components setMinute:rec.fireMinute];
//            [components setHour:rec.fireHour];
//            [components setDay:rec.fireDay];
//            [components setMonth:rec.fireMonth];
//            [components setYear:rec.fireYear];
//            NSDate *fireDate = [c dateFromComponents:components];   // The time that the event should have gone off.
//            
//            if ([now compare:fireDate] == NSOrderedDescending)
//            {
//                // the event should have generated an alert by now.
//                
//                // do it now.
//                [self generateAlertType:rec.type withNotificationRecord:rec.idRecord];
//                
//            }
//        }
//    }
    
    
    if (nil != [GlobalData sharedManager].theTabBarController)  // If the tab bar controller has been identified,...
    {
        // Activate the first tab bar button (survey mode).
        [[GlobalData sharedManager].theTabBarController setSelectedIndex:0];
        
    }
    
    
    
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController* tcl = [sb instantiateViewControllerWithIdentifier:@"tabBarCtlr"];
//    [tcl setSelectedIndex:0];
//    
//    StartViewController* vc = [sb instantiateViewControllerWithIdentifier:@"StartViewController"];
  //  [[vc navigationController] popToRootViewControllerAnimated:YES];
    

    
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}








- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    // This routine is called in the following situations:
    // 1
    // The phone is on, displaying the "desktop".
    // The TinyShifts app is not in the foreground.
    // A notification fires.
    // User acknowledges it by pressing the message box.
    // In response to pressing the message box, the app is started, displaying the start screen.
    // The the app runs this routine.
    // 2
    // The app is running.
    // A notification fires.
    // No message box appears at the top of the screen, nothing about the appearance of the app changes.
    // The app runs this routine.
    
    app.applicationIconBadgeNumber = 0;

    int numDone = [[CDatabaseInterface sharedManager] getNumberDoneEvents]; // get the number of done events
    [[ScheduleManager sharedManager] setNumberDoneEvents:(numDone+1)];    // increment it by 1

    [[ScheduleManager sharedManager] setNextLocalNotification];    // start the timer for the next local notification.
}




-(void) processLocalNotification:(UILocalNotification *)notif
{
    // Get the dictionary value for the "Notificiation_Type" key.
    NSString *notificationType = [NSString stringWithFormat:@"%@",[notif.userInfo valueForKey:@"Notification_Type"]];
    
    // Get the record number
    int idRecord = [[NSString stringWithFormat:@"%@",[notif.userInfo valueForKey:@"Record_Number"]] intValue];
    
    // Generate the corresponding alert.  Also delete the corresponding record in the Notifications table.
    [self generateAlertType:notificationType withNotificationRecord:idRecord];
}



-(void) generateAlertType:(NSString*)type withNotificationRecord:(int)idRecord
{
    UIAlertView *alertView = nil;
    
    
    
    if ([type isEqualToString:@"PROD"])
    {
        // This is an schedule prod-type notification.
        
        [[CDatabaseInterface sharedManager] deleteNotification:idRecord];   // delete the corresponding record from the Notifications table.
        
        
//        // ----------------- additional code for displaying notification characteristics -----------------------
//        NSDate* fD = notif.fireDate;    // for examining the firing date of the notification
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"YYYY-MM-dd 'at' HH:mm"];
//        
//        
//        NSLog(@"Received local notification type: %@, fire date: %@", notificationType, [formatter stringFromDate:fD]);
//        // ------------------------------------------------------------------------------------------------------
        
        
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Reminder Schedule"
                                               message:@"You have no TinyShifts videos scheduled.  This is a suggestion to adjust your Settings in the TinyShifts app."
                                              delegate:self cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
    }
    else if ([type isEqualToString:@"SUGG"])
    {
        // This is a suggestion prompt-type notification.
        
        [[CDatabaseInterface sharedManager] deleteNotification:idRecord];   // delete the corresponding record from the Notifications table.
        
        
//        // ----------------- additional code for displaying notification characteristics -----------------------
//        NSDate* fD = notif.fireDate;    // for examining the firing date of the notification
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"YYYY-MM-dd 'at' HH:mm"];
//        
//        NSLog(@"Received local notification type: %@, fire date: %@", notificationType, [formatter stringFromDate:fD]);
//        // ------------------------------------------------------------------------------------------------------
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Scheduled TinyShifts Event"
                                               message:[NSString stringWithFormat:@"Would you like to see a TinyShifts video now?"]
                                              delegate:self cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    }
    
//    NSLog(@"After receiving a notification:");
//    [[ScheduleManager sharedManager] showAllLocalNotifications];   // display characteristics of all scheduled local notifications
    
    
    [alertView show];
}




-(NSString*) documentsPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDir = [paths objectAtIndex:0];
    
    return documentsDir;
}


#pragma mark - View Orientation

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    if (self.screenIsPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        if(self.window.rootViewController){
            UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
            orientations = [presentedViewController supportedInterfaceOrientations];
        }
        return orientations;
    }
}


@end
