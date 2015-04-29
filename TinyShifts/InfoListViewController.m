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
    
    [infoText2 appendString:@"APPNAME Mobile Application\n"];
    
    [infoText2 appendString:@"Privacy Policy\n"];
    
    [infoText2 appendString:@"This privacy policy governs your use of the AppName software application (ìApplicationî) on a mobile device that was created by The University of Michigan. The Application includes [BASIC DESCRIPTION OF APP features, functionality and content such as: games, news, messages, and more].\n\n"];
    
    [infoText2 appendString:@"What information does the Application obtain and how is it used?\n"];
    
    [infoText2 appendString:@"This section is designed to inform Users of the types of data that the app obtains and how that information is used. The App Developer should make a reasonable attempt to ensure to provide Users with a clear, illustrative list of the most important data points obtained by each app. Moreover, the model policy attempts to draw a distinction between data that is provided directly by a User (ìUser Provided Informationî) and data that is collected automatically by the Application (ìAutomatically Collected Informationî).\n\n"];
    
    [infoText2 appendString:@"User Provided Information ñ The Application obtains the information you provide when you download and register the Application. [IS THIS APPLICABLE?] Registration with us is optional. However, please keep in mind that you may not be able to use some of the features offered by the Application unless you register with us. Registration with us is mandatory in order to be able to use the basic features of the Application. When you register with us and use the Application, you generally provide [INSERT A REPRESENTATIVE LIST HERE ñ A FEW TYPICAL EXAMPLES ARE PROVIDED FOR REFERENCE]: (a) your name, email address, age, user name, password and other registration information; (b) transaction-related information, such as when you make purchases, respond to any offers, or download or use applications from us; (c) information you provide us when you contact us for help; (d) credit card information for purchase and use of the Application, and; (e) information you enter into our system when using the Application, such as contact information and project management information. We may also use the information you provided us to contact your from time to time to provide you with important information, required notices and marketing promotions.\n\n"];
    
    [infoText2 appendString:@"Automatically Collected Information - In addition, the Application may collect certain information automatically, such as [INSERT A REPRESENTATIVE LIST HERE ñ a few typical examples are provided for your reference] the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browsers you use, and information about the way you use the Application. [IS THIS APPLICABLE, even locally on the device?]\n\n"];
    
    [infoText2 appendString:@"Does the Application collect precise real time location information of the device?\n"];
    
    [infoText2 appendString:@"This section is only applicable if the Application collects precise, real-time location information. Non-precise location information such as geo-targeting (e.g., zip code or city) data is typically addressed elsewhere in the privacy policy (e.g., the section entitled ìautomatic data collection and advertising.î)\n"];
    
    [infoText2 appendString:@"[IF No] This Application does not collect precise information about the location of your mobile device.\n"];
    
    [infoText2 appendString:@"[IF Yes] This application does collect precise information about the location of your device. [INSERT A GENERAL DESCRIPTION OF HOW THIS IS DONE IN A WAY THAT IS CLEAR TO AN AVERAGE CONSUMER.]\n"];
    
    [infoText2 appendString:@"We use your location information to Provide requested location services, and [INSERT A LIST OF OTHER USES (E.G., TO ALLOW TAGGING, OR TO CHECK-IN) AND IF APPLICABLE, DESCRIBE THE CIRCUMSTANCES WHERE PRECISE LOCATION DATA IS SHARED WITH THIRD PARTIES FOR THEIR INDEPENDENT USE.]\n\n"];
    
    [infoText2 appendString:@"[IF APPLICABLE] You may at any time opt-out from further allowing us to have access to your location data by [state how user can manage their location preferences either from the app or device level]. For more information, please see the section below entitled ìopt-out rights.î\n\n"];
    
    [infoText2 appendString:@"Do third parties see and/or have access to information obtained by the Application? [IS THIS APPLICABLE?]\n"];
    
    [infoText2 appendString:@"Generally, app developers will want to have the right to transfer information collected by the app under certain circumstances. For example, if the app developer sells the app, the developer may want that information collected by the application transferred as part of the sale.\n"];
    [infoText2 appendString:@"Yes. We will share your information with third parties only in the ways that are described in this privacy statement.\n"];
    
    [infoText2 appendString:@"We may disclose User Provided and Automatically Collected Information:  as required by law, such as to comply with a subpoena, or similar legal process; when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request; with our trusted services providers who work on our behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n"];
    
    [infoText2 appendString:@"if [APP COMPANY NAME] is involved in a merger, acquisition, or sale of all or a portion of its assets, you will be notified via email and/or a prominent notice on our Web site of any change in ownership or uses of this information, as well as any choices you may have regarding this information;\n\n"];
    
    [infoText2 appendString:@"Opt-out of all information collection by uninstalling the Application ñ You can stop all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\n"];
    
    [infoText2 appendString:@"Data Retention Policy, Managing Your Information\n"];
    
    [infoText2 appendString:@"We will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If youíd like us to delete User Provided Data that you have provided via the Application, please contact us at [INSERT EMAIL ADDRESS] and we will respond in a reasonable time. Please note that some or all of the User Provided Data may be required in order for the Application to function properly, and we may be required to retain certain information by law.\n\n"];
    
    [infoText2 appendString:@"Children\n"];
    
    [infoText2 appendString:@"We do not use the Application to knowingly solicit data from or market to children under the age of 13. If a parent or guardian becomes aware that his or her child has provided us with information without their consent, he or she should contact us at [INSERT EMAIL ADDRESS]. We will delete such information from our files within a reasonable time.\n\n"];
    
    [infoText2 appendString:@"Security\n"];
    
    [infoText2 appendString:@"We are concerned about safeguarding the confidentiality of your information. We provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve our Application. Please be aware that, although we endeavor to provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.\n\n"];
    
    [infoText2 appendString:@"Changes\n"];
    
    [infoText2 appendString:@"This Privacy Policy may be updated from time to time for any reason. We will notify you of any changes to our Privacy Policy by posting the new Privacy Policy here [INSERT WEBSITE WHERE PRIVACY POLICY CAN BE ACCESSED]. You are advised to consult this Privacy Policy regularly for any changes.\n\n"];
    
    [infoText2 appendString:@"Your Consent\n"];
    
    [infoText2 appendString:@"By using the Services, you are consenting to our processing of User Provided and Automatically Collection information as set forth in this Privacy Policy now and as amended by us. \"Processing,î means using cookies on a computer/hand held device or using or touching information in any way, including, but not limited to, collecting, storing, deleting, using, combining and disclosing information, all of which activities will take place in the United States. If you reside outside the U.S. your information will be transferred to the U.S., and processed and stored there under U.S. privacy standards. By using the Application and providing information to us, you consent to such transfer to, and processing in, the US.\n\n"];
    
    [infoText2 appendString:@"Contact us\n"];
    
    [infoText2 appendString:@"If you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at [INSERT EMAIL ADDRESS]."];
    
    
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
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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




@end
