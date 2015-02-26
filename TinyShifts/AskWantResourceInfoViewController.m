//
//  AskWantResourceInfoViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AskWantResourceInfoViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "ResourceListViewController.h"
#import "VideoPlayerViewController.h"
#import "SendSurveyViewController.h"

@interface AskWantResourceInfoViewController ()

@end

@implementation AskWantResourceInfoViewController
@synthesize screenInstance;


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
    
    BOOL firstInstance = YES;   // is this screen being viewed in the first instance on the Main storyboard, or later?
    
    BOOL selectedYES = YES;
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (selectedYES)
    {
        ResourceListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"ResourceListViewController"];
        [vc setScreenInstance:screenInstance];
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else{
        if (firstInstance)
        {
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        [[self navigationController] pushViewController:vc animated:YES];
        }
        else
        {
            SendSurveyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SendSurveyViewController"];
            [[self navigationController] pushViewController:vc animated:YES];
        }
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
