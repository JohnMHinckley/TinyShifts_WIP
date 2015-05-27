//
//  GenderViewController.h
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGradientButton.h"
#import "ConstGen.h"

static int bItemIsSelected_Gender[maxnumItems] = {maxnumItems*0};    // array of flags indicating whether item on screen is selected.
static CGRect textFieldFrame;   // frame of text field, in normal position
static CGFloat textFieldVertConstraint; // vertical position constraint on text field

@interface GenderViewController : UIViewController <UITextFieldDelegate>
{
    NSInteger numItems;         // actual number of items on the screen (must be <= maxnumItems)
    int State;
}

@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *m_Switch;
@property (weak, nonatomic) IBOutlet UITextField *m_TextField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *m_Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalPositionConstraint;

- (IBAction)switchChanged:(UISwitch *)sender;

@end
