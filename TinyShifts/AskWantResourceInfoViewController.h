//
//  AskWantResourceInfoViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface AskWantResourceInfoViewController : UIViewController

@property (nonatomic) NSUInteger screenInstance;    // key for where in storyboard this instance appears: 1 (earlier in main storyboard), or 2 (later)
- (IBAction)buttonPressedYes:(CGradientButton *)sender;
- (IBAction)buttonPressedNo:(CGradientButton *)sender;
-(void) setScreenInstance:(NSUInteger)sI;
@end
