//
//  ResourceListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ResourceListViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "VideoPlayerViewController.h"
#import "SendSurveyViewController.h"

@interface ResourceListViewController ()
{
    UILabel* label;
}

@end

@implementation ResourceListViewController
@synthesize screenInstance;
@synthesize scrollView;
@synthesize informationText;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Adjust the navigation item
    // Right button
    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    informationText = @"Resources on campus:\n\nCounseling and Psychological Services (CAPS)\nMichigan Union, 3rd Floor\n734-764-8312\nwww.caps.umich.edu\n\nUniversity Health Service (UHS)\n207 Fletcher Street\nww.uhs.umich.edu/edbi\n\nWolverine Wellness\n207 Fletcher Street\nhttp://www.uhs.umich.edu/wolverine-wellness\n\nUniversity of Michigan Psychological Clinic\n500 E. Washington St., Suite 100\nhttp://mari.umich.edu/adult-psychological-clinic\n\nFor more about general mental health resources available to U-M students, visit MiTalk (www.mitalk.umich.edu).\n\nList of available resources in the local community:\n\nFor a list of Ann Arbor providers, you can search the database at: umcpd.umich.edu.";
    
    // Size of displayed text
    CGFloat fontSize = 12.0;
    
    
    // Add a label subview to the scroll view controller.
    // First, make up a test box to figure out how big it needs to be to hold the text.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat displayWidth = screenBounds.size.width;
    
    CGRect testTextbox;
    testTextbox.origin = CGPointMake(10,0);
    testTextbox.size = CGSizeMake(displayWidth-20, 500);    // purpose = 200, how = 250, privacy =
    
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
    
    
    scrollView.contentSize = textbox.size;
}


-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    //if (screenMode == 1)
    {
        self.navigationItem.hidesBackButton = NO;   // show back button
    }
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

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return label;
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}



- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    
    BOOL firstInstance = ((screenInstance == 1) ? YES: NO);   // is this screen being viewed in the first instance on the Main storyboard, or later?
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (firstInstance)
    {
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        [vc setScreenMode:1];
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else{
        SendSurveyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendSurveyViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
    }
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


-(void) setScreenInstance:(NSUInteger)sI
{
    screenInstance = sI;
}



@end
