//
//  CalendarHeadViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/11/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "CalendarHeadViewController.h"
#import "FrequencyViewController.h"

@interface CalendarHeadViewController ()

@end

@implementation CalendarHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Schedule" bundle:nil];
    FrequencyViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FrequencyViewController"];
    [vc setScreenInstance:2];   // signifies that this is coming from the tab bar
    [[self navigationController] pushViewController:vc animated:YES];
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
