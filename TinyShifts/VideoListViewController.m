//
//  VideoListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "VideoListViewController.h"
#import "AskWantResourceInfoViewController.h"
#import "VideoPlayerViewController.h"
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
    
    // Add an image subview to the scroll view controller.
    UIImage* image = [UIImage imageNamed:@"TreeDesign.png"];
    imageView2.image = image;
    
    CGSize sz = imageView2.image.size;
//    CGSize sz;
//    sz.height = 525;
//    sz.width = 106;
    scrollView.contentSize = sz;
    NSLog(@"In viewDidLoad: scrollView contentSize size = %f (h) X %f (w)", scrollView.contentSize.height, scrollView.contentSize.width);
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
    [GlobalData sharedManager].selectedVideo = VIDEO_FIREFLIES; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedSloppyjoe:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_SLOPPYJOE; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressed711:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_711; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedTreadingwater:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TREADINGWATER; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedTrapped:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TRAPPED; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedPotatohead:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_POTATOHEAD; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedTreadmill:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_TREADMILL; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedDaury:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_DAURY; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)buttonPressedBalloon:(UIButton *)sender {
    [GlobalData sharedManager].selectedVideo = VIDEO_BALLOON; // save index to selected video in global data
    
    if (screenMode == 1)
    {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AskWantResourceInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AskWantResourceInfoViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenInstance:1];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (screenMode == 2)
    {
        // from all videos tab bar item
        // Go directly to video display screen
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoPlayerViewController* vc = [sb instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [vc setScreenMode:screenMode];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
//    CGSize sz = imageView2.image.size;
    //    CGSize sz;
    //    sz.height = 525;
    //    sz.width = 106;
//    scrollView.contentSize = sz;  // For some damned reason, the size of the scroll view content must be set at this late point in the game.  Otherwise the statement has no effect.
    //    NSLog(@"In viewDidAppear: scrollView size = %f (h) X %f (w)", sz.height, sz.width);
}



-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];

}


-(void) setScrollSize:(CGSize) sz
{
//    scrollView.contentSize = sz;
//    NSLog(@"In setScrollSize: scrollView contentSize size = %f (h) X %f (w)", scrollView.contentSize.height, scrollView.contentSize.width);
    
}


@end
