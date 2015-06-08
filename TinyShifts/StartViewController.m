//
//  StartViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "CActivationManager.h"
#import "ActivationViewController.h"
#import "InfoListViewController.h"
#import "MoodMeterViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "Backendless.h"
#import "RDB_Participants.h"
#import "CDatabaseInterface.h"
#import "ScheduleManager.h"




@interface StartViewController ()

@end

@implementation StartViewController



//---------------------------------------------------------------------------------------------------------------------------------



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    // Initialization
    
    UITabBarController* utc = self.tabBarController;
    utc.delegate = self;
    [GlobalData sharedManager].theTabBarController = utc;   // Record the identity of the tab bar controller for global access.
    
    // State = 0: baseline survey not done.
    // State = 1: baseline survey has been done.
    State = [[CDatabaseInterface sharedManager] getBaselineSurveyStatus];
    
    
//    // -------------- Code for creating a RDB_Participants table in the remote database.  Normally, can be commented out.
//    Responder* responder = [Responder responder:self
//                             selResponseHandler:@selector(responseHandlerSendParticipant:)
//                                selErrorHandler:@selector(errorHandler:)];
//    
//    RDB_Participants* record = [[RDB_Participants alloc] init];
//    
//    id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_Participants class]];
//    
//    [dataStore save:record responder:responder];
//    //---------------

    
    
    // Establish the navigation controller for this line of screens.
    ((AppDelegate*)[UIApplication sharedApplication].delegate).navigationControllerMain = self.navigationController;
    
    
    // Test for activation.
    int appIsActivated = [[CActivationManager sharedManager] getActivationStatus];
    
    if (appIsActivated)
    {
        // app is activated
        
        
        
        
        // TODO: develop code for starting timers.
//        [[CScheduleManager sharedManager] startProdTimers]; // Start all non-done timers for prodding.
//        
//        [[CScheduleManager sharedManager] startGEPromptTimers]; // Start all non-done timers for GE prompting.
        
    }
    else
    {
        // app is not activated
        
        // Disable the tab bar items
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        // Create an instance of the activation view controller.
        ActivationViewController* vc = [[ActivationViewController alloc] initWithNibName:@"ActivationViewController"
                                                                                  bundle:nil];
        vc.navigationItem.hidesBackButton = YES;
        
        // Send a pointer to the current navigation controller to the activation view controller
        // so that we can get back to this controller after the activation work is done.
        [vc setActiveNavigationController:self.navigationController];
        
        // Send a pointer to the tab bar controller to the activation view controller,
        // which will enable the tab bar if the app is properly activated.
        [vc setActiveTabBarController:self.tabBarController];
        
        // Display the activation view controller.
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}



-(void) setState:(int)newState
{
    // Update the private State of this view controller with the input value.
    // Generally, this is used after completing the baseline survey to record the fact of its completion.
    
    State = newState;
    State = [[CDatabaseInterface sharedManager] getBaselineSurveyStatus];
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendParticipant:(id)response
{
    NSLog(@"Response Handler for send test participant: Response = %@", response);
    
    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startButtonPressed:(CGradientButton *)sender {
    // The start button has been pressed.
    
    
    
    //BOOL bInitialPass = ([GlobalData sharedManager].initialPass == INITIAL_PASS_YES);    // TODO (001): Add a decision whether to go to this screen or to the MoodMeter screen.
    State = [[CDatabaseInterface sharedManager] getBaselineSurveyStatus];
    BOOL bInitialPass = (State == 0);    // If State is 0, this is the initial pass: baseline survey has not yet been done.  Otherwise, it has been done.
    
    if (bInitialPass)
    {
        // Some initialization, first.
        
        [GlobalData sharedManager].gender = GENDER_UNSPEC;
        [GlobalData sharedManager].age = 0;
        [GlobalData sharedManager].ethnicity = ETHNICITY_UNSPEC;
        [GlobalData sharedManager].bUseGoogleCal = NO;
        [GlobalData sharedManager].frequency = 7;
        [GlobalData sharedManager].timeOfDayAvailMorning = 1;
        [GlobalData sharedManager].timeOfDayAvailNoon = 1;
        [GlobalData sharedManager].timeOfDayAvailAfternoon = 1;
        [GlobalData sharedManager].timeOfDayAvailEvening = 1;
        
        
        
        
        
        // This is the initial pass, so go to the InfoList screen.
        
        // Attempt to use storyboard to instantiate InfoListViewController.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"InfoList" bundle:nil];
        InfoListViewController* vc = [sb instantiateInitialViewController];
        vc.navigationItem.hidesBackButton = NO;
        
        // Send a pointer to the current navigation controller to the activation view controller so that we can get back to this controller after the activation work is done.
        [vc setActiveNavigationController:self.navigationController];
        
        
        // Tell the destination view controller, the mode under which it is being created.
        [vc setScreenMode:1];   // 1 signifies being created in the baseline survey (2 corresponds to coming from the tab bar).
        
        // Display the new view controller.
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
        // Some initialization, first.
        
        [GlobalData sharedManager].bVideoDidPlay = NO;  // initialize video played flag.
        
        
        // This is not the initial pass, so go to the MoodMeter screen.
        
        // Attempt to use storyboard to instantiate MoodMeterViewController.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MoodMeterViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MoodMeterViewController"];
        vc.navigationItem.hidesBackButton = NO;
        
        // Display the new view controller.
        [self.navigationController pushViewController:vc animated:YES];
   }
    
}






-(void) viewWillAppear:(BOOL)animated
{
//    // Control whether the user can interact with the tab bar buttons, based on whether the
//    // baseline survey has been completed yet.
//    // Determine whether baseline survey has been done yet.  If it has, set State = 1, otherwise, set State = 0.
//    
//    State = [[CDatabaseInterface sharedManager] getBaselineSurveyStatus];
//    
//    if (State == 1)
//    {
//        // Baseline survey has been done, so enable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//    }
//    else
//    {
//        // Baseline survey has not been done, so disable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = NO;
//    }
}







-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}

-(void) portraitLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = true;
}

#pragma mark - interface posiiton

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}





-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL retval = YES;
    
    if ([[CDatabaseInterface sharedManager] getBaselineSurveyStatus] == 1)
    {
        // Baseline survey has been done, so enable tab bar buttons.
        retval = YES;
    }
    else
    {
        // Baseline survey has not been done, so disable tab bar buttons.
        retval = NO;
    }
    
    
    return retval;
}

@end
