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

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navigationControllerMain;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GlobalData sharedManager].activated = ACTIVATED_NO;
    [GlobalData sharedManager].initialPass = INITIAL_PASS_YES;
    [GlobalData sharedManager].frequency = 7;
    
    
    
    
    
    // Setup backendless
    [backendless initApp:BackendlessApplicationID secret:BackendlessIOSSecretKey version:BackendlessApplicationVer];
    
    
    
    
    
    // Set up the database in the sandbox, if it is not already there.
    [[DatabaseController sharedManager] createDatabase];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
