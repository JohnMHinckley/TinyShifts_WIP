//
//  ActivationViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationViewController : UIViewController
{
    UINavigationController* activeNavigationController;
}


-(void) setActiveNavigationController:(UINavigationController*) nc;

@end
