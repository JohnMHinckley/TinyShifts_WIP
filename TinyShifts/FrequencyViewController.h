//
//  FrequencyViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequencyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *sliderFrequency;
@property (weak, nonatomic) IBOutlet UILabel *labelSliderValue;
- (IBAction)sliderValueChanged:(UISlider *)sender;

@property (nonatomic) NSUInteger screenInstance;    // key for where in storyboard this instance appears: 1 (in main storyboard), or 2 (tab bar)

-(void) setScreenInstance:(NSUInteger)sI;

@end
