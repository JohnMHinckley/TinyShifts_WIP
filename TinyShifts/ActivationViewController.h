//
//  ActivationViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface ActivationViewController : UIViewController
{
    UINavigationController* activeNavigationController;
    UITabBarController* activeTabBarController;
}
- (IBAction)OKButtonPressed:(CGradientButton *)sender;


-(void) setActiveNavigationController:(UINavigationController*) nc;
-(void) setActiveTabBarController:(UITabBarController*) tc;

@end
