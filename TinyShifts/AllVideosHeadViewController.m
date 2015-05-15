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
    
    
//    // Create an instance of the video list view controller.
//    
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    VideoListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoListViewController"];
//    vc.navigationItem.hidesBackButton = YES;
//    
//    // Tell the destination view controller, the mode under which it is being created.
//    [vc setScreenMode:2];   // 2 signifies being created from the tab bar.
//  
//    
//    // Display the new view controller.
//    [self.navigationController pushViewController:vc animated:YES];

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

-(void) viewDidAppear:(BOOL)animated
{
    // Create an instance of the video list view controller.
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoListViewController"];
    vc.navigationItem.hidesBackButton = YES;
    
    // Tell the destination view controller, the mode under which it is being created.
    [vc setScreenMode:2];   // 2 signifies being created from the tab bar.
    
    
    // Display the new view controller.
    [self.navigationController pushViewController:vc animated:YES];
}

@end
