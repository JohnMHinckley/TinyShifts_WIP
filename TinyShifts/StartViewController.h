//
//  StartViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface StartViewController : UIViewController <UITabBarControllerDelegate>
{
    int State;
}

- (IBAction)startButtonPressed:(CGradientButton *)sender;
-(void) setState:(int)newState;

@end
