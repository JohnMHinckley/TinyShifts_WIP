//
//  VideoPlayerViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CGradientButton.h"


@interface VideoPlayerViewController : UIViewController
{
    MPMoviePlayerController *player;
    NSUInteger screenMode;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
- (IBAction)buttonPressedPlayVideo:(CGradientButton *)sender;
-(void) setScreenMode:(NSUInteger) mode;

@end
