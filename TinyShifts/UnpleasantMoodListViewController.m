//
//  UnpleasantMoodListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "UnpleasantMoodListViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "VideoListViewController.h"
#import "AskWantResourceInfoViewController.h"
#import "VideoListViewController.h"
#import "UnpleasantMoodTableViewCell.h"
#import "VideoPlayerViewController.h"
#import "TableDatum.h"
#import "GlobalData.h"
#import "ConstGen.h"

@interface UnpleasantMoodListViewController ()
{
    NSInteger selectedCell;

}

@end

@implementation UnpleasantMoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    // Adjust the navigation item
//    // Right button
//    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
//    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
//    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    
    
    
    // Set up the array of table data
    arrayTableCellData = [[NSMutableArray alloc] init];
    
    TableDatum* datum0 = [[TableDatum alloc] init];
    TableDatum* datum1 = [[TableDatum alloc] init];
    TableDatum* datum2 = [[TableDatum alloc] init];
    TableDatum* datum3 = [[TableDatum alloc] init];
    TableDatum* datum4 = [[TableDatum alloc] init];
    TableDatum* datum5 = [[TableDatum alloc] init];
    TableDatum* datum6 = [[TableDatum alloc] init];
    TableDatum* datum7 = [[TableDatum alloc] init];
    
    datum0.index = 0;
    datum0.label = @"I'm experiencing problems in my relationships with friends/family";
    datum0.backgroundImageFilename = nil;
    datum0.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum0];
    
    datum1.index = 1;
    datum1.label = @"I feel generally down";
    datum1.backgroundImageFilename = nil;
    datum1.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum1];
    
    datum2.index = 2;
    datum2.label = @"There is too much pressure and responsibilities";
    datum2.backgroundImageFilename = nil;
    datum2.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum2];
    
    datum3.index = 3;
    datum3.label = @"I feel lonely";
    datum3.backgroundImageFilename = nil;
    datum3.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum3];
    
    datum4.index = 4;
    datum4.label = @"I don't think I'm good enough";
    datum4.backgroundImageFilename = nil;
    datum4.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum4];
    
    datum5.index = 5;
    datum5.label = @"I don't like the way I look";
    datum5.backgroundImageFilename = nil;
    datum5.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum5];
    
    datum6.index = 6;
    datum6.label = @"I worry all the time";
    datum6.backgroundImageFilename = nil;
    datum6.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum6];
    
    datum7.index = 7;
    datum7.label = @"Other";
    datum7.backgroundImageFilename = nil;
    datum7.supplementaryImageFilename = nil;
    [arrayTableCellData addObject:datum7];
    
    
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







#pragma mark ----------- Table Data Source ---------------



// Insert an individual row into the table
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // indexPath.row is the row index in the table
    
    UnpleasantMoodTableViewCell* cell = nil;
    static NSString* CellIdentifier1 = @"tableCell";
    
    
    
    // Try to get a reusable cell
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    
    
    
    // Set the content for the cell.
    cell.labelUnpleasantMoodTableCell.text = ((TableDatum*)[arrayTableCellData objectAtIndex:indexPath.row]).label;
    
    // Set the index value for the cell.  This is needed in segueing to the next screen.
    cell.index = indexPath.row;
    
    // This would be the point to set cell-specific images and backgrounds, if this were being done.
    
    return cell;
}






// Get the number of rows in the table.
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // There are 8 rows in this table.
    NSInteger cnt = 8;
    
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
    
    
    /* Modification log
     
     Date			Author			Action
     --------------------------------------------------------
     21-May-2015	J. M. Hinckley	Changed next screen from AskWantResourceViewController to VideoPlayerViewController, at the request on 18-May-2015, by D. Eisenberg.
     
     */
    
    
    selectedCell = indexPath.row;   // get the index of the selected cell.  This will be used to pass the correct text to the next screen.
    
    
    
    
    // Determine the next video to play.  Generally, randomly pick from among a few, depending on which input the user gives.
    int R = 0.0;

    switch (selectedCell) {
        case 0:
            // "I'm experiencing problems in my relationships with friends/family" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_RELATIONSHIP_PROBLEMS; // save result
            
            R = [GlobalData RandomIntUpTo:3];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_SLOPPYJOE;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_POTATOHEAD;
                    break;
                    
                case 2:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TREADINGWATER;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            // "I feel generally down" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_FEEL_DOWN; // save result
            
            R = [GlobalData RandomIntUpTo:2];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TRAPPED;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_DAURY;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            // "There is too much pressure and responsibilities" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_PRESSURE; // save result
            
            R = [GlobalData RandomIntUpTo:4];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TREADMILL;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TREADINGWATER;
                    break;
                    
                case 2:
                    [GlobalData sharedManager].selectedVideo = VIDEO_BALLOON;
                    break;
                    
                case 3:
                    [GlobalData sharedManager].selectedVideo = VIDEO_711;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            // "I feel lonely" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_LONELY; // save result
            
            R = [GlobalData RandomIntUpTo:1];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_DAURY;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 4:
            // "I don't think I'm good enough" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_NOT_GOOD_ENOUGH; // save result
            
            R = [GlobalData RandomIntUpTo:2];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_BALLOON;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TREADMILL;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 5:
            // "I don't like the way I look" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_NOT_LIKE_LOOKS; // save result
            
            R = [GlobalData RandomIntUpTo:2];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_BALLOON;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_TREADMILL;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 6:
            // "I worry all the time" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_WORRY; // save result
            
            R = [GlobalData RandomIntUpTo:2];
            switch (R) {
                case 0:
                    [GlobalData sharedManager].selectedVideo = VIDEO_FIREFLIES;
                    break;
                    
                case 1:
                    [GlobalData sharedManager].selectedVideo = VIDEO_711;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 7:
            // "Other" is chosen
            [GlobalData sharedManager].moodTableSelection = MOOD_U_OTHER; // save result
            
            [GlobalData sharedManager].selectedVideo = VIDEO_UNDEFINED; // Video will actually be selected from the next screen.
            
            break;
            
        default:
            break;
    }
    
    
    // Determine the next view controller.
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (selectedCell == 7)
    {
        // "Other" is chosen
        VideoListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoListViewController"];
        vc.navigationItem.hidesBackButton = NO;
        
        // Tell the destination view controller, the mode under which it is being created.
        [vc setScreenMode:1];   // 1 signifies being created from the main line of storyboard.
        
        CGSize sz;
        sz.height = 525;
        sz.width = 106;
        [vc setScrollSize:sz];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        //[vc setScreenInstance:1];
        [vc setScreenMode:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

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




@end
