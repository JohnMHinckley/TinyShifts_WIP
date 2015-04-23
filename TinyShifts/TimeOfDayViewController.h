//
//  TimeOfDayViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"

@interface TimeOfDayViewController : UIViewController
//- (IBAction)buttonPressedAnytime:(CGradientButton *)sender;
//- (IBAction)buttonPressedMorning:(CGradientButton *)sender;
//- (IBAction)buttonPressedNoon:(CGradientButton *)sender;
//- (IBAction)buttonPressedAfternoon:(CGradientButton *)sender;
//- (IBAction)buttonPressedEvening:(CGradientButton *)sender;
- (IBAction)switchChangedMorning:(UISwitch *)sender;
- (IBAction)switchChangedNoon:(UISwitch *)sender;
- (IBAction)switchChangedAfternoon:(UISwitch *)sender;
- (IBAction)switchChangedEvening:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchMorning;
@property (weak, nonatomic) IBOutlet UISwitch *switchNoon;
@property (weak, nonatomic) IBOutlet UISwitch *switchAfternoon;
@property (weak, nonatomic) IBOutlet UISwitch *switchEvening;

@property (nonatomic) NSUInteger screenInstance;    // key for where in storyboard this instance appears: 1 (in main storyboard), or 2 (tab bar)

-(void) setScreenInstance:(NSUInteger)sI;

@end
