//
//  CalendarViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController <UIAlertViewDelegate>
{
    BOOL bDataChanged_Mode2;    // flag: YES = user changed data on screen.
    UIAlertView*            responseAlert;
}

@property (strong, nonatomic) UIAlertView* responseAlert;

@property (weak, nonatomic) IBOutlet UISwitch *switchUseGoogleCal;

@property (nonatomic) NSUInteger screenInstance;    // key for where in storyboard this instance appears: 1 (in main storyboard), or 2 (tab bar)

- (IBAction)switchChangedUseGoogleCal:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelNextEvent;

-(void) setScreenInstance:(NSUInteger)sI;

@end
