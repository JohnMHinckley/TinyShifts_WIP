//
//  InfoListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "InfoListViewController.h"
#import "InfoListTableViewCell.h"
#import "TableDatum.h"
#import "InfoViewController.h"
#import "GenderViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "InfoReadingActivity_Rec.h"
#import "CDatabaseInterface.h"

@interface InfoListViewController ()
{
    NSInteger selectedCell;
    NSMutableArray* arrayInfoText;
}

@end

@implementation InfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UITabBarController* utc = self.tabBarController;
    
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Information";
    
    if (screenMode == 1)
    {
        // Right button
        CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
        [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
   
    
    
    
    

    // Set up the array of table data
    arrayTableCellData = [[NSMutableArray alloc] init];
    arrayInfoText = [[NSMutableArray alloc] init];
    
    TableDatum* datum0 = [[TableDatum alloc] init];
    TableDatum* datum1 = [[TableDatum alloc] init];
    TableDatum* datum2 = [[TableDatum alloc] init];
    
    NSString* infoText0 = @"The purpose: the goal of this app is to help you learn about yourself; it includes brief interactive videos that you can watch anytime; The videos are about challenges that we all have to face from time to time; and how to take advantage of these challenges as an opportunity to grow and improve.";
    
    NSString* infoText1 = @"How: You can access the app at any time during the day.  Our goal is to match the videos in the app to your needs; To do the matching, you will be asked to answer a few questions about how you feel when you access the app; the app will then recommend a few videos based on your answers.  You can also select times at which you would like the app to recommend a video.";
    
    
    // ------------------------------------------------------
    
    
    NSMutableString* infoText2 = [[NSMutableString alloc] initWithString:@""];
    
    [infoText2 appendString:@"TinyShifts Mobile Application\n"];
    
    [infoText2 appendString:@"Privacy Policy\n"];
    
    [infoText2 appendString:@"This privacy policy governs your use of the TinyShifts software application (ìApplicationî) on a mobile device that was created by The University of Michigan. The Application includes the capability of playing videos and gathering related survey data.\n\n"];
    
    [infoText2 appendString:@"The application collects the following personal data which is provided by the user: gender, age, and ethnicity.  This information is transmitted to the academic study administrators.  Furthermore, the application is capable of collecting the userís response to questions concerning his or her mood and concerning his or her reaction to the videos that are presented. This information is also transmitted to the study administrators.\n\n"];
    
    [infoText2 appendString:@"User Provided Information - The Application obtains the information you provide when you register and download the Application. Registration with this Application is mandatory; it is needed in order to be able to use the basic features of the Application. When you register and use the Application, you generally provide: (a) your name, email address, age, user name, password and other registration information; (b) information you provide us when you contact us for technical or study related support; and; (c) information you enter into our system when using the Application, such as responses to survey questions.\n\n"];
    
    [infoText2 appendString:@"Automatically Collected Information - In addition, the Application may collect certain information automatically, such as the type of mobile device you use, your mobile devices unique device ID, your mobile operating system, and information about the way you use the Application. This Application does not collect precise information about the location of your mobile device.\n\n"];
    
    [infoText2 appendString:@"In general, no third party will have access to information obtained by the Application; however, we may disclose User Provided and Automatically Collected Information as required by law, such as to comply with a subpoena, or similar legal process; when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request; with our trusted services providers who work on our behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\n"];
    
    [infoText2 appendString:@"Opt-out of all information collection by uninstalling the Application - You can stop all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\n"];
    
    [infoText2 appendString:@"Data Retention Policy, Managing Your Information - We will retain User Provided data for as long as you use the Application and for a reasonable time thereafter for study purposes. If youíd like us to delete User Provided Data that you have provided via the Application, please contact us at tinyshifts@umich.edu and we will respond in a reasonable time. Please note that some or all of the User Provided Data may be required in order for the Application to function properly, and we may be required to retain certain information by law.\n\n"];
    
    [infoText2 appendString:@"Children - we do not use the Application to knowingly solicit data from or market to children under the age of 13. If a parent or guardian becomes aware that his or her child has provided us with information without their consent, he or she should contact us at tinyshifts@umich.edu. We will delete such information from our files within a reasonable time.\n\n"];
    
    [infoText2 appendString:@"Security - We are concerned about safeguarding the confidentiality of your information. We provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve our Application. Please be aware that, although we endeavor to provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.\n\n"];
    
    [infoText2 appendString:@"Changes - This Privacy Policy may be updated from time to time for any reason. We will notify you of any changes to our Privacy Policy by posting the new Privacy Policy here http://www.healthymindsnetwork.org/tinyshifts_app. You are advised to consult this Privacy Policy regularly for any changes.\n\n"];
    
    [infoText2 appendString:@"Your Consent - By using the Application, you are consenting to our processing of User Provided and Automatically Collection information as set forth in this Privacy Policy now and as amended by us. \"Processing\", means using cookies on a computer/hand held device or using or touching information in any way, including, but not limited to, collecting, storing, deleting, using, combining and disclosing information, all of which activities will take place in the United States. If you reside outside the U.S. your information will be transferred to the U.S., and processed and stored there under U.S. privacy standards. By using the Application and providing information to us, you consent to such transfer to, and processing in, the US.\n\n"];
    
    [infoText2 appendString:@"Contact us - If you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at tinyshifts@umich.edu."];
    
    
    // ------------------------------------------------------
    
    
    datum0.index = 0;
    datum0.label = @"Purpose";
    datum0.backgroundImageFilename = nil;
    datum0.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum0];
    [arrayInfoText addObject:infoText0];
    
    datum1.index = 1;
    datum1.label = @"How";
    datum1.backgroundImageFilename = nil;
    datum1.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum1];
    [arrayInfoText addObject:infoText1];
    
    datum2.index = 2;
    datum2.label = @"Privacy";
    datum2.backgroundImageFilename = nil;
    datum2.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum2];
    [arrayInfoText addObject:infoText2];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ((InfoViewController*)[segue destinationViewController]).informationText = [arrayInfoText objectAtIndex:((InfoListTableViewCell*)sender).index];
    
    // Pass the table cell label string to also be used as the title at the top of the next screen.
    ((InfoViewController*)[segue destinationViewController]).navigationTitleText = (NSMutableString*)((TableDatum*)[arrayTableCellData objectAtIndex:((InfoListTableViewCell*)sender).index]).label;
    
    
    
    
    // Record part of the database record for this InfoReadingActivity.

    InfoReadingActivity_Rec* rec = [InfoReadingActivity_Rec sharedManager];
    
    rec.idRecord++; // increment the record id
    
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
    
    rec.dateStartReading = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec.timeStartReading = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now

    rec.infoPageRead = ((InfoListTableViewCell*)sender).index;  // identifies which page is being read.
    
    
}


- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
    GenderViewController* vc = [sb instantiateInitialViewController];
    vc.navigationItem.hidesBackButton = NO;
    [[self navigationController] pushViewController:vc animated:YES];
}

-(void) setActiveNavigationController:(UINavigationController*) nc
{
    // Set the active navigation controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active navigation controller is inherited from the calling view controller and is used to get back
    // to the calling view controller when the work in this view controller is done.
    
    activeNavigationController = nc;
}


-(void) setScreenMode:(NSUInteger) mode
{
    // Set the mode for this screen.
    // Depending upon where this screen is created, certain features may exist or not.
    // Determination of which features to include and which to exclude is based on the value of the
    // input parameter <mode>, which is used to represent the location in the code from which this
    // screen is created.
    
    screenMode = mode;
}







#pragma mark ----------- Table Data Source ---------------



// Insert an individual row into the table
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // indexPath.row is the row index in the table
    
    InfoListTableViewCell* cell = nil;
    static NSString* CellIdentifier1 = @"infoListTableCell";
    
    
    
    // Try to get a reusable cell
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    
    
    
    // Set the content for the cell.
    cell.labelInfoListTableCell.text = ((TableDatum*)[arrayTableCellData objectAtIndex:indexPath.row]).label;
    
    // Set the index value for the cell.  This is needed in segueing to the next screen.
    cell.index = indexPath.row;
    
    // This would be the point to set cell-specific images and backgrounds, if this were being done.
    
    return cell;
}






// Get the number of rows in the table.
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // There are three rows in this table.
    NSInteger cnt = 3;
    
    return cnt;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView*) tableView
{
    // return the number of sections
    
    // There is one section in this table.
    return 1;
}






#pragma mark ------Table View Delegate-------




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A given row has been selected in the table.
    // The index of this row is indexPath.row
    
    selectedCell = indexPath.row;   // get the index of the selected cell.  This will be used to pass the correct text to the next screen.
    
    
    /*
     NSString* selection = [NSString stringWithFormat:@"Level %d", [[arrCategories objectAtIndex:indexPath.row] integerValue]];
     
     NSString* msg = [NSString stringWithFormat:@"You have selected %@", selection];
     
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Selection"
     message:msg
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     
     [alert show];
     */
}





-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A given table cell is about to be displayed (such as being scrolled into view).
    
    
    /*
     UIColor* bkgColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0];
     
     switch (indexPath.row%4) {
     case 0:
     bkgColor = [UIColor colorWithRed:(255.0/255.0) green:(175.0/255.0) blue:(128.0/255.0) alpha:1.0];
     break;
     
     case 1:
     bkgColor = [UIColor colorWithRed:(128.0/255.0) green:(255.0/255.0) blue:(159.0/255.0) alpha:1.0];
     break;
     
     case 2:
     bkgColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(159.0/255.0) alpha:1.0];
     break;
     
     case 3:
     bkgColor = [UIColor colorWithRed:(128.0/255.0) green:(159.0/255.0) blue:(255.0/255.0) alpha:1.0];
     break;
     
     default:
     break;
     }
     
     cell.backgroundColor = bkgColor;
     */
}




-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (45);
}





-(void) viewWillAppear:(BOOL)animated
{
//    UITabBarController* utc = self.tabBarController;
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




@end
