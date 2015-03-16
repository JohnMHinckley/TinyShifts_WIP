//
//  SendSurveyViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "SendSurveyViewController.h"

@interface SendSurveyViewController ()

@end

@implementation SendSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)submitButtonPressed:(CGradientButton *)sender {
    // Submit the main survey data and pop the navigation stack to the start screen.
    
    
    
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    //if (screenMode == 1)
    {
        self.navigationItem.hidesBackButton = NO;   // show back button
    }

}
@end
