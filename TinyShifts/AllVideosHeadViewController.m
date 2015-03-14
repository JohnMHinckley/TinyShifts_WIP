//
//  AllVideosHeadViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AllVideosHeadViewController.h"
#import "VideoListViewController.h"

@interface AllVideosHeadViewController ()

@end

@implementation AllVideosHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Create an instance of the video list view controller.
// TODO rectify this    VideoListViewController* vc = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
//    
//    // Send a pointer to the current navigation controller to the destination view controller so that we can use it for further navigation in this line.
//    [vc setActiveNavigationController:self.navigationController];
//    
//    // Tell the destination view controller, the mode under which it is being created.
//    [vc setScreenMode:2];   // 2 signifies being created from the tab bar.
//    
//    // Create the activation view controller.
//    [self.navigationController pushViewController:vc animated:NO];
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
