//
//  InfoViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/22/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController <UIScrollViewDelegate>
{
    UINavigationController* activeNavigationController;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableString* informationText;
@property (strong, nonatomic) NSMutableString* navigationTitleText;

-(void) setActiveNavigationController:(UINavigationController*) nc;

@end
