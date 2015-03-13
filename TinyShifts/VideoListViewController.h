//
//  VideoListViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListViewController : UIViewController
{
    UINavigationController* activeNavigationController;
    NSUInteger screenMode;
}
- (IBAction)PlayVideoButtonPushed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

-(void) setActiveNavigationController:(UINavigationController*) nc;
-(void) setScreenMode:(NSUInteger) mode;

@end
