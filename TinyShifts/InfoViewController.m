//
//  InfoViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/22/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "InfoViewController.h"
#import "AppDelegate.h"
#import "InfoReadingActivity_Rec.h"
#import "RDB_InfoReadingActivity.h"
#import "Backendless.h"
#import "CDatabaseInterface.h"
#import "GlobalData.h"

@interface InfoViewController ()
{
    UILabel* label;
}

@end

@implementation InfoViewController

@synthesize scrollView;
@synthesize informationText;
@synthesize navigationTitleText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    // Adjust the navigation item
    self.navigationItem.title = navigationTitleText;
    
    // Size of displayed text
    CGFloat fontSize = 12.0;
    
    
    // Add a label subview to the scroll view controller.
    // First, make up a test box to figure out how big it needs to be to hold the text.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat displayWidth = screenBounds.size.width;
    
    CGRect testTextbox;
    testTextbox.origin = CGPointMake(10,0);
    //testTextbox.size = CGSizeMake(280, 500);    // purpose = 200, how = 250, privacy =
    testTextbox.size = CGSizeMake(displayWidth-30, 500);    // purpose = 200, how = 250, privacy =
    
    UILabel* testLabel= [[UILabel alloc] initWithFrame:testTextbox];
    testLabel.text = informationText;
    [testLabel setFont:[UIFont systemFontOfSize:fontSize]];
    testLabel.numberOfLines = 0;
    CGSize testSize = [testLabel sizeThatFits:testTextbox.size];
   
    // Now make the real box with the determined size.
    CGRect textbox;
    textbox.origin = CGPointMake(10,0);
    textbox.size = testSize;    // purpose = 200, how = 250, privacy =
    
    
    label = [[UILabel alloc] initWithFrame:textbox];
    [scrollView addSubview:label];
    
    label.text = informationText;
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    label.numberOfLines = 0;    // remove any restriction on the number of lines.
    label.backgroundColor = [UIColor whiteColor];
    
    
//    CGSize sz = scrollView.bounds.size;
//    sz.height = textbox.size.height;
//    scrollView.contentSize = sz;
    scrollView.contentSize = textbox.size;
    
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


-(void) setActiveNavigationController:(UINavigationController*) nc
{
    // Set the active navigation controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active navigation controller is inherited from the calling view controller and is used to get back
    // to the calling view controller when the work in this view controller is done.
    
    activeNavigationController = nc;
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return label;
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}



-(void) viewWillAppear:(BOOL)animated
{
//    // Control whether the user can interact with the tab bar buttons, based on whether the
//    // baseline survey has been completed yet.
//    // Determine whether baseline survey has been done yet.  If it has, set State = 1, otherwise, set State = 0.
//    
//    if ([[CDatabaseInterface sharedManager] getBaselineSurveyStatus] == 1)
//    {
//        // Baseline survey has been done, so enable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//    }
//    else
//    {
//        // Baseline survey has not been done, so disable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = NO;
//    }
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) viewWillDisappear:(BOOL)animated
{
    // Finish forming the database record about using this screen and send the data to the remote database.
    
    
    InfoReadingActivity_Rec* rec = [InfoReadingActivity_Rec sharedManager];
    
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
    
    rec.dateEndReading = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec.timeEndReading = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    Responder* responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandlerSendInfoReadingActivity:)
                                selErrorHandler:@selector(errorHandler:)];
    
    RDB_InfoReadingActivity* record = [[RDB_InfoReadingActivity alloc] init];
    
    id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_InfoReadingActivity class]];
    
    [dataStore save:record responder:responder];
    
    
    
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendInfoReadingActivity:(id)response
{
    NSLog(@"Response Handler for send InfoReadingActivity: Response = %@", response);
    
//    [[[UIAlertView alloc] initWithTitle:@"Test Participant Sent" message:@"Proceed, if you wish." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------



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

@end
