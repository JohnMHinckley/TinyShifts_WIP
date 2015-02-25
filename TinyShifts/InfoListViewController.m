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
    
    
    // Set up the array of table data
    arrayTableCellData = [[NSMutableArray alloc] init];
    arrayInfoText = [[NSMutableArray alloc] init];
    
    TableDatum* datum0 = [[TableDatum alloc] init];
    TableDatum* datum1 = [[TableDatum alloc] init];
    TableDatum* datum2 = [[TableDatum alloc] init];
    
    NSString* infoText0 = @"The purpose: the goal of this app is to help you learn about yourself; it includes brief interactive videos that you can watch anytime; The videos are about challenges that we all have to face from time to time; and how to take advantage of these challenges as an opportunity to grow and improve.";
    
    NSString* infoText1 = @"How: You can access the app at any time during the day.  Our goal is to match the videos in the app to your needs; To do the matching, you will be asked to answer a few questions about how you feel when you access the app; the app will then recommend a few videos based on your answers.  You can also select times at which you would like the app to recommend a video.";
    
    NSString* infoText2 = @"Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  Privacy Statement: to be supplied.  ";
    
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
    
}


- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
    GenderViewController* vc = [sb instantiateInitialViewController];
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







@end
