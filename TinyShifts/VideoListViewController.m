//
//  VideoListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "VideoListViewController.h"
#import "AskWantResourceInfoViewController.h"
#import "ConstGen.h"
#import "GlobalData.h"

@interface VideoListViewController ()
{
    UIImageView* subImage;
}

@end

@implementation VideoListViewController
@synthesize scrollView;
@synthesize imageView2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (screenMode == 2)
    {
        // This is being created from the tab bar.
        // Hide the Back button.
        self.navigationItem.hidesBackButton = YES;
    }
    
    
    // Add an image subview to the scroll view controller.
    UIImage* image = [UIImage imageNamed:@"TreeDesign.png"];
    imageView2.image = image;
    
    //[imageView2 sizeToFit];  not needed
    //scrollView.contentSize = imageView2.image.size;    not effective if this is executed here.
    
    
    
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
    return imageView2;
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


- (IBAction)PlayVideoButtonPushed:(UIButton *)sender {
    // Button is pushed to play a video.
    
    // Go to the video player screen.
    
    
}

- (IBAction)buttonPressedFireflies:(UIButton *)sender {
//    NSLog(@"Content offset before setContetOffset: = (%f, %f)", scrollView.contentOffset.x, scrollView.contentOffset.y);
//    [scrollView setContentOffset:CGPointMake(50, 50)];  // shifts tree view up and to left 50 points
//    NSLog(@"Content offset after setContetOffset: = (%f, %f)\n", scrollView.contentOffset.x, scrollView.contentOffset.y);
//    
//    NSLog(@"Initial content size (w, h) = (%f, %f)", scrollView.contentSize.width, scrollView.contentSize.height);
//    scrollView.contentSize = CGSizeMake(406, 525);
//    NSLog(@"Final content size (w, h) = (%f, %f)", scrollView.contentSize.width, scrollView.contentSize.height);
//
//    NSLog(@"Initial content inset (b, t, L, r) = (%f, %f, %f, %f)", scrollView.contentInset.bottom, scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.right);
    
    [GlobalData sharedManager].selectedVideo = VIDEO_FIREFLIES; // save index to selected video in global data

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedSloppyjoe:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_SLOPPYJOE; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressed711:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_711; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedTreadingwater:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TREADINGWATER; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedTrapped:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TRAPPED; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedPotatohead:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_POTATOHEAD; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedTreadmill:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TREADMILL; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedDaury:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_DAURY; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressedBalloon:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_BALLOON; // save index to selected video in global data
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
    [vc setScreenInstance:1];
    [self.navigationController pushViewController:vc animated:YES];
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


-(void) viewDidAppear:(BOOL)animated
{
    scrollView.contentSize = imageView2.image.size;  // For some damned reason, the size of the scroll view content must be set at this late point in the game.  Otherwise the statement has no effect.
}

@end
