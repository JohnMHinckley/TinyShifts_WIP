//
//  StartViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "ActivationViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Establish the navigation controller for this line of screens.
    ((AppDelegate*)[UIApplication sharedApplication].delegate).navigationControllerMain = self.navigationController;
    
    
    // Test for activation.
    BOOL bActivated = NO;   // test value
    
    if (!bActivated)    // Has user activated app?
    {
        // User has not activated app.
        
        // Create an instance fo the activation view controller.
        ActivationViewController* vc = [[ActivationViewController alloc] initWithNibName:@"ActivationViewController" bundle:nil];
        
        // Send a pointer to the current navigation controller to the activation view controller so that we can get back to this controller after the activation work is done.
        [vc setActiveNavigationController:self.navigationController];
        
        // Create the activation view controller.
        [self.navigationController pushViewController:vc animated:YES];
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

@end
