//
//  AboutHeadViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/11/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AboutHeadViewController.h"
#import "InfoListViewController.h"

@interface AboutHeadViewController ()

@end

@implementation AboutHeadViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // Attempt to use storyboard to instantiate InfoListViewController.
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"InfoList" bundle:nil];
    InfoListViewController* vc = [sb instantiateInitialViewController];
    
    // Send a pointer to the current navigation controller to the activation view controller so that we can get back to this controller after the activation work is done.
    [vc setActiveNavigationController:self.navigationController];
    
    
    // Tell the destination view controller, the mode under which it is being created.
    [vc setScreenMode:2];   // 1 signifies being created in the baseline survey (2 corresponds to coming from the tab bar).
    
    self.navigationItem.hidesBackButton = YES;   // do not show back button
  
    // Display the new view controller.
    [self.navigationController pushViewController:vc animated:YES];

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




@end
