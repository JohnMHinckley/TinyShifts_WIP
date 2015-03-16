//
//  GenderViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface GenderViewController : UIViewController
- (IBAction)buttonPressedFemale:(CGradientButton *)sender;
- (IBAction)buttonPressedMale:(CGradientButton *)sender;
- (IBAction)buttonPressedNotSure:(CGradientButton *)sender;

@end
