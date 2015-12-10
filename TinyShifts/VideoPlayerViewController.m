//
//  VideoPlayerViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "AskIfHelpfulViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ConstGen.h"
#import "GlobalData.h"
#import "RandomVideoPlayActivity_Rec.h"
#import "RDB_RandomVideoPlayActivity.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"

@interface VideoPlayerViewController ()
{
    NSArray* arrVideoFilenames;
}

@end

@implementation VideoPlayerViewController
@synthesize imageViewBackground;
@synthesize displayLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    if (screenMode == 1)
    {
        // Adjust the navigation item
        // Right button
        CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
        [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
  
    /*
     #define VIDEO_FIREFLIES         0
     #define VIDEO_SLOPPYJOE         1
     #define VIDEO_711               2
     #define VIDEO_TREADINGWATER     3
     #define VIDEO_TRAPPED           4
     #define VIDEO_POTATOHEAD        5
     #define VIDEO_TREADMILL         6
     #define VIDEO_DAURY             7
     #define VIDEO_BALLOON           8
     #define VIDEO_CHOOSEONETHING    9
     */
    arrVideoFilenames = [NSArray arrayWithObjects: @"Fireflies.m4v", @"SloppyJoe.m4v", @"SevenEleven.m4v", @"TreadingWater.m4v", @"Trapped.m4v", @"Potatohead.m4v", @"Treadmill.m4v", @"Daury.m4v", @"Balloon.m4v", @"ChooseOneThing.m4v", nil];
    
    
    displayLabel.text = displayMsg;
}

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


- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    // Next button pressed.
    
    // First, check whether video was actually played.
    if ([GlobalData sharedManager].bVideoDidPlay == NO)
    {
        // video was not actually played.  Generate an alert requiring play.
        [[[UIAlertView alloc] initWithTitle:@"No Video Was Viewed" message:@"You should view the video before proceeding." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        // video was played, so go to next screen.
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        AskIfHelpfulViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskIfHelpfulViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitUnLock];
    
    
    
    
    
    
    // Get the current date/time
    // Get the current date and time and save these in the GlobalData object.
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    
    //date formatter with just date and no time
    dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    //date formatter with no date and just time
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
    
    [GlobalData sharedManager].dateStartVideoPlay = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    [GlobalData sharedManager].timeStartVideoPlay = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    
    if (screenMode == 2)
    {
        bVideoDidPlayMode2 = NO;    // initialize and set to YES if and when play button is pressed
    }
}



-(void) viewWillDisappear:(BOOL)animated
{
    
    // Get the current date/time
    // Get the current date and time and save these in the GlobalData object.
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    
    //date formatter with just date and no time
    dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    //date formatter with no date and just time
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
    
    [GlobalData sharedManager].dateEndVideoPlay = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    [GlobalData sharedManager].timeEndVideoPlay = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    
    
    if (screenMode == 2)
    {
        // This is being accessed from the tab bar.
        
        // check whether video was played in mode 2.
        // send a record to the remote database only if the video was played.
        if (bVideoDidPlayMode2)
        {
            
            // Send a record to the remote database.
            
            RandomVideoPlayActivity_Rec* rec = [RandomVideoPlayActivity_Rec sharedManager];
            
            rec.idRecord++;
            rec.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
            
            // Get the current date and time and save these in the InfoReadingActivity_Rec object.
            NSDateFormatter *dateFormatter1;
            NSDateFormatter *dateFormatter2;
            
            //date formatter with just date and no time
            dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
            [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
            
            //date formatter with no date and just time
            dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
            
            rec.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
            rec.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
            
            rec.videoShown = [GlobalData sharedManager].selectedVideo;
            
            rec.dateStartVideoPlay = [GlobalData sharedManager].dateStartVideoPlay;
            rec.timeStartVideoPlay = [GlobalData sharedManager].timeStartVideoPlay;
            rec.dateEndVideoPlay = [GlobalData sharedManager].dateEndVideoPlay;
            rec.timeEndVideoPlay = [GlobalData sharedManager].timeEndVideoPlay;
            
            
            
            // Send the survey data to the remote database
            
            Responder* responder = [Responder responder:self
                                     selResponseHandler:@selector(responseHandlerSendRandomVideoPlayActivity:)
                                        selErrorHandler:@selector(errorHandler:)];
            
            RDB_RandomVideoPlayActivity* record = [[RDB_RandomVideoPlayActivity alloc] init];
            
            id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_RandomVideoPlayActivity class]];
            
            [dataStore save:record responder:responder];
        }
        
      
       
    }
    
}




//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendRandomVideoPlayActivity:(id)response
{
    NSLog(@"Response Handler for send RandomVideoPlayActivity: Response = %@", response);
    
    //    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"In error handler.");
}



//---------------------------------------------------------------------------------------------------------------------------------




-(NSString*) fullPathForFile:(NSString*) filename
{
    // Returns full path to named file, within the Content bundle.
    
    
    NSString* pathToFile = nil;
    
    NSString* contentBundlePath = [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"bundle"];
    
    if ([contentBundlePath length] > 0)
    {
        NSBundle* contentBundle = [NSBundle bundleWithPath:contentBundlePath];
        
        if (nil != contentBundle)
        {
            // Separate file name from file type
            
            pathToFile = [contentBundle pathForResource:filename ofType:nil];
            
            if ([pathToFile length] > 0)
            {
                // OK
            }
            else
            {
                NSLog(@"Error in VideoPlayerViewController::filePath, failed to find database in content bundle.");
            }
        }
        else
        {
            NSLog(@"Error in VideoPlayerViewController::filePath, failed to load content bundle.");
        }
    }
    else
    {
        NSLog(@"Error in VideoPlayerViewController::filePath, failed to find content bundle.");
    }
    
    return pathToFile;
    
}








-(void) portraitUnLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = false;
}
/*
#pragma mark - interface posiiton

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}
*/




-(void) setScreenMode:(NSUInteger) mode
{
    // Set the mode for this screen.
    // Depending upon where this screen is created, certain features may exist or not.
    // Determination of which features to include and which to exclude is based on the value of the
    // input parameter <mode>, which is used to represent the location in the code from which this
    // screen is created.
    
    screenMode = mode;
}




-(void) setDisplayedMessage:(NSString*)msg
{
    // Set the message to display on the screen.
    displayMsg = msg;
}





#pragma mark --------------- Screen Rotation Handling ------------------








-(void) viewWillAppear:(BOOL)animated
{
    
    UIInterfaceOrientation a = [UIApplication sharedApplication].statusBarOrientation;
    [self positionViews:a];
    
}






-(void) viewWillLayoutSubviews
{
    UIInterfaceOrientation a = [UIApplication sharedApplication].statusBarOrientation;
    [self positionViews:a];
    
}






-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self positionViews:toInterfaceOrientation];
}






// Position elements on the view interface, based on the device orientation.
-(void) positionViews:(UIInterfaceOrientation) toInterfaceOrientation
{
    // Some of the coordinates are OS version-dependent.
    // Get the version of the OS:
    NSString* osVer = [[UIDevice currentDevice] systemVersion];
    NSRange r = [osVer rangeOfString:@"."]; // find the first occurrence of "."
    NSString* osMajVer = [osVer substringToIndex:r.location];
    NSInteger verMajor = [osMajVer integerValue];
    
    
    UIInterfaceOrientation destOrientation = toInterfaceOrientation;     // get the upcoming device orientation.
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    CGSize iPhone6plus = CGSizeMake(1242, 2208);
    
    CGSize iPhone6 = CGSizeMake(750, 1334);
    
    CGSize iPhone5 = CGSizeMake(640, 1136);
    
    CGSize iPhone4 = CGSizeMake(640, 960);
    
    
    if (UIInterfaceOrientationPortrait == destOrientation ||
        UIInterfaceOrientationPortraitUpsideDown == destOrientation)
    {
        // The device is in either the portrait orientation or upside down.
        
        // coordinates are for the view in the portrait mode.
        
        // coordinates are for the view in the portrait mode.
        
        // Width of screen as determined from width of image view.
        CGFloat displayWidth = screenBounds.size.width;
        
        
        if(screenSize.height == iPhone4.height && screenSize.width == iPhone4.width)
        {
            
            NSLog(@"Device is iPhone4");
            
            //player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), displayWidth, (17.0/30.0)*displayWidth);
            
        }
        else if (screenSize.height == iPhone5.height && screenSize.width == iPhone5.width)
        {
            
            NSLog(@"Device is iPhone 5");
            
            //player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), displayWidth, (17.0/30.0)*displayWidth);
            
        }
        else if (screenSize.height == iPhone6.height && screenSize.width == iPhone6.width)
        {
            
            NSLog(@"Device is iPhone 6");
            
            //player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), 320*(750.0/640.0), (320*272/480)*(750.0/640.0));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), displayWidth, (17.0/30.0)*displayWidth);
            //a = player.view.frame;
            
        }
        else if (screenSize.height == iPhone6plus.height && screenSize.width == iPhone6plus.width)
        {
            
            NSLog(@"Device is iPhone 6+");
            
            //player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), displayWidth, (17.0/30.0)*displayWidth);
            
        }
        else
        {
            NSLog(@"Device is unknown");
            
            //player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), displayWidth, (17.0/30.0)*displayWidth);
        }
    }
    
    else
    {
        // The device is in either of the landscape orientations (left or right).
        
        // coordinates are for the view in the landscape mode.
        
        // coordinates are for the view in the landscape mode.
        CGFloat marginHeight = 105.0;
        CGFloat displayHeight = screenBounds.size.height - marginHeight;
        
        if(screenSize.height == iPhone4.width && screenSize.width == iPhone4.height)
        {
            
            NSLog(@"Device is iPhone4");
            
            //player.view.frame = CGRectMake(250, (verMajor >= 7 ? 60 : 10), 220, (220*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), (30.0/17.0)*displayHeight, displayHeight);
            
        }
        
        else if (screenSize.height == iPhone5.width && screenSize.width == iPhone5.height)
        {
            
            NSLog(@"Device is iPhone 5");
            
            //player.view.frame = CGRectMake(290, (verMajor >= 7 ? 60 : 0), 280, (280*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), (30.0/17.0)*displayHeight, displayHeight);
            
        }
        else if (screenSize.height == iPhone6.width && screenSize.width == iPhone6.height)
        {
            
            NSLog(@"Device is iPhone 6");
            
            //player.view.frame = CGRectMake(290, (verMajor >= 7 ? 60 : 0), 320*(750.0/640.0), (320*272/480)*(750.0/640.0));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), (30.0/17.0)*displayHeight, displayHeight);
            //a = player.view.frame;
            
        }
        else if (screenSize.height == iPhone6plus.width && screenSize.width == iPhone6plus.height)
        {
            
            NSLog(@"Device is iPhone 6+");
            
            //player.view.frame = CGRectMake(290, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), (30.0/17.0)*displayHeight, displayHeight);
           
        }
        else
        {
            NSLog(@"Device is unknown");
            
            //player.view.frame = CGRectMake(290, (verMajor >= 7 ? 60 : 0), 320, (320*272/480));
            player.view.frame = CGRectMake(0, (verMajor >= 7 ? 60 : 0), (30.0/17.0)*displayHeight, displayHeight);
        }
    }
}







- (IBAction)buttonPressedPlayVideo:(CGradientButton *)sender {
    // Play the selected video
    
    NSString* videoFilename = [arrVideoFilenames objectAtIndex:[GlobalData sharedManager].selectedVideo];
    NSString* fullpath = [self fullPathForFile:videoFilename];
    
    if (nil == player)
    {
        player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:fullpath]];
    }
    else
    {
        player.contentURL = [NSURL fileURLWithPath:fullpath];
    }
    
    UIInterfaceOrientation a = [UIApplication sharedApplication].statusBarOrientation;
    [self positionViews:a];
    
    UIView* v = [self view];
    
    [v addSubview:player.view];
    
    // play movie
    [player setFullscreen:YES animated:YES];    // Make the video run in full screen mode.
    [player play];
    
    
    // Update the played video flag.
    [GlobalData sharedManager].bVideoDidPlay = YES;
    
    if (screenMode == 2)
    {
        bVideoDidPlayMode2 = YES;    // iset to YES to indicate that video was played in mode 2
    }

}
@end
