//
//  AgeViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AgeViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"

@interface AgeViewController ()

@end

@implementation AgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self portraitUnLock];
   
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Age";
    
    
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
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
    AgeViewController* vc = [sb instantiateViewControllerWithIdentifier:@"EthnicityViewController"];
    [[self navigationController] pushViewController:vc animated:YES];
}

-(void) portraitUnLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = false;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitUnLock];
}



@end
