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
- (IBAction)buttonPressedFireflies:(UIButton *)sender;
- (IBAction)buttonPressedSloppyjoe:(UIButton *)sender;
- (IBAction)buttonPressed711:(UIButton *)sender;
- (IBAction)buttonPressedTreadingwater:(UIButton *)sender;
- (IBAction)buttonPressedTrapped:(UIButton *)sender;
- (IBAction)buttonPressedPotatohead:(UIButton *)sender;
- (IBAction)buttonPressedTreadmill:(UIButton *)sender;
- (IBAction)buttonPressedDaury:(UIButton *)sender;
- (IBAction)buttonPressedBalloon:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

-(void) setActiveNavigationController:(UINavigationController*) nc;
-(void) setScreenMode:(NSUInteger) mode;
-(void) setScrollSize:(CGSize) sz;

@end
