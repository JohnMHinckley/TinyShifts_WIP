//
//  ContactViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CGradientButton.h"

@interface ContactViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)buttonPressedSendEmail:(CGradientButton *)sender;

@end
