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
    BOOL bVideoDidPlayMode2;    // flag used in screen mode 2 (tab bar button activated) to track whether a video was actually played in this screen.
}
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
- (IBAction)buttonPressedPlayVideo:(CGradientButton *)sender;
-(void) setScreenMode:(NSUInteger) mode;

@end
