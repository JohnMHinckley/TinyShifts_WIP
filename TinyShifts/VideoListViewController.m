//
//  VideoListViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "VideoListViewController.h"

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
    // First, make up a test box to figure out how big it needs to be to hold the image.
    CGRect testImagebox;
    testImagebox.origin = CGPointMake(10,0);
    testImagebox.size = CGSizeMake(280, 500);
    
    UIImage* image = [UIImage imageNamed:@"TreeDesign.png"];
    
    UIImageView* testImage = [[UIImageView alloc] initWithImage:image];
    
    CGSize testSize = [testImage sizeThatFits:testImagebox.size];
    
    // Now make the real box with the determined size.
    CGRect imagebox;
    imagebox.origin = CGPointMake(10,0);
    imagebox.size = testSize;
    
    
    subImage = [[UIImageView alloc] initWithImage:image];
    imageView2.image = image;
    //[scrollView addSubview:subImage];
    
    
    scrollView.contentSize = imagebox.size;
    
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
    return subImage;
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


- (IBAction)PlayVideoButtonPushed:(UIButton *)sender {
    // Button is pushed to play a video.
    
    // Go to the video player screen.
    
    
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

@end
