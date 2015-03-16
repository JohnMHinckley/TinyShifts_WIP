//
//  EthnicityViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface EthnicityViewController : UIViewController
- (IBAction)buttonPressedAsian:(CGradientButton *)sender;
- (IBAction)buttonPressedBlack:(CGradientButton *)sender;
- (IBAction)buttonPressedHispanic:(CGradientButton *)sender;
- (IBAction)buttonPressedWhite:(CGradientButton *)sender;
- (IBAction)buttonPressedOther:(CGradientButton *)sender;

@end
