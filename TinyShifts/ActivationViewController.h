//
//  ActivationViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface ActivationViewController : UIViewController <UITextViewDelegate>
{
    UINavigationController* activeNavigationController;
    UITabBarController* activeTabBarController;
    NSString* testCode;
}

- (IBAction)OKButtonPressed:(CGradientButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *m_LabelActivation;
@property (weak, nonatomic) IBOutlet UITextView *m_TextActivation;


-(void) setActiveNavigationController:(UINavigationController*) nc;
-(void) setActiveTabBarController:(UITabBarController*) tc;

@end
