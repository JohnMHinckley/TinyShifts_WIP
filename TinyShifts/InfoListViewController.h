//
//  InfoListViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoListViewController : UIViewController
{
    UINavigationController* activeNavigationController;
    NSUInteger screenMode;
}

-(void) setActiveNavigationController:(UINavigationController*) nc;
-(void) setScreenMode:(NSUInteger) mode;

@end
