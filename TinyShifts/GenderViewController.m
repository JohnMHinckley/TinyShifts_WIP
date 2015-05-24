//
//  GenderViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "GenderViewController.h"
#import "CGradientButton.h"
#import "AgeViewController.h"
#import "AppDelegate.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "CDatabaseInterface.h"



@interface GenderViewController ()

@end

@implementation GenderViewController
@synthesize m_Switch;
@synthesize m_Label;
@synthesize m_TextField;
@synthesize verticalPositionConstraint;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Gender";

    
    // Right button
    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;




    // Find the number of items on the screen
    
    numItems = [m_Switch count];    // actual number of items on the screen.
    if (numItems > maxnumItems)
    {
        NSLog(@"GenderViewController: Error; actual number of screen items exceeds maximum limit");
        numItems = maxnumItems;     // crash avoidance
    }
    
    
    
    
    
    // Initialze the switches on the screen
    
    for (int i = 0; i < numItems; i++)  // loop over all the switches
    {
        // if (bIsInit == 0)
        if ([GlobalData sharedManager].genderIdxSelected == GENDER_UNSPEC)
        {
            // Set all flags to 0 only the first time through this screen
            bItemIsSelected_Gender[i] = 0; // clear all item flags, indicating none are initially chosen.
        }
        
        UISwitch* sw = [m_Switch objectAtIndex:i];  // Get the corresponding switch
        sw.on = (bItemIsSelected_Gender[i] == 1);          // Set the switch position to match the flag
    }
    
    
    
    
    // Control the visibility of the text input box
    // Will be hidden if the "Other" switch is not on.
    
    if (numItems > 2)
    {
        m_TextField.hidden = (bItemIsSelected_Gender[2] == 0);
        if (bItemIsSelected_Gender[2] == 1)
        {
            // "Other:" is selected.
            // Restore associated text from the survey data object
            m_TextField.text = [NSString stringWithString:[GlobalData sharedManager].gender];
        }
    }
    else
    {
        m_TextField.hidden = YES;
    }
    
    
    
    // Set State corresponding to text field being shown
    if (m_TextField.hidden)
    {
        State = 1;  // text field is not displayed.
    }
    else
    {
        State = 2;  // text field is displayed, but keyboard is not present
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)nextButtonPressed:(CGradientButton *)sender {
    
    
    // Is the view controller in State == 3 (keyboard is present)?
    if (State == 3)
    {
        // Make the keyboard disappear
        // Make text field become white and resume its normal position.
        // Make the switches reappear.
        //[textField resignFirstResponder];
        [self.view endEditing:YES];

        // Set flag to indicate that text field is displayed.
        State = 2;
    }
    
    
    // Check that at least one of the items are selected, before allowing forward navigation.
    // If no item is selected, put up a message box with instructions to make a choice, then remain on this scene.
    
    BOOL bSomethingIsSelected = NO;
    for (int i = 0; i < numItems; i++)
    {
        if (bItemIsSelected_Gender[i] == 1)
        {
            bSomethingIsSelected = YES;
        }
    }
    
    if (bSomethingIsSelected)
    {
        // something is selected, allow forward navigation.
        
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
        AgeViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AgeViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else
    {
        // nothing is selected, prevent forward navigation.
        [[[UIAlertView alloc] initWithTitle:@"No Selection Made" message:@"You must make a selection before proceeding." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}

-(void) portraitLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = true;
}


-(void) viewWillAppear:(BOOL)animated
{
//    // Control whether the user can interact with the tab bar buttons, based on whether the
//    // baseline survey has been completed yet.
//    // Determine whether baseline survey has been done yet.  If it has, set State = 1, otherwise, set State = 0.
//    
//    if ([[CDatabaseInterface sharedManager] getBaselineSurveyStatus] == 1)
//    {
//        // Baseline survey has been done, so enable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//    }
//    else
//    {
//        // Baseline survey has not been done, so disable tab bar buttons.
//        self.tabBarController.tabBar.userInteractionEnabled = NO;
//    }

}

#pragma mark - interface posiiton

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}



//- (IBAction)buttonPressedFemale:(CGradientButton *)sender {
//    
//    State = 1;  // set flag: text field is not displayed.
//
//    [GlobalData sharedManager].gender = @"female" ; // save result
//    NSLog(@"Gender stored: %@", [GlobalData sharedManager].gender);
//    
//    // Go to next screen
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
//    AgeViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AgeViewController"];
//    vc.navigationItem.hidesBackButton = NO;
//    [[self navigationController] pushViewController:vc animated:YES];
//}
//
//- (IBAction)buttonPressedMale:(CGradientButton *)sender {
//    
//    State = 1;  // set flag: text field is not displayed.
//    
//    [GlobalData sharedManager].gender = @"male" ; // save result
//    NSLog(@"Gender stored: %@", [GlobalData sharedManager].gender);
//    
//    // Go to next screen
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
//    AgeViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AgeViewController"];
//    vc.navigationItem.hidesBackButton = NO;
//    [[self navigationController] pushViewController:vc animated:YES];
//}
//
//- (IBAction)buttonPressedNotSure:(CGradientButton *)sender {
//    
//    State = 2;  // set flag: text field is displayed.
//    
//    [GlobalData sharedManager].gender = @"other" ; // save result
//    NSLog(@"Gender key stored: %@", [GlobalData sharedManager].gender);
//    
//    // Go to next screen
//    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
//    AgeViewController* vc = [sb instantiateViewControllerWithIdentifier:@"AgeViewController"];
//    vc.navigationItem.hidesBackButton = NO;
//    [[self navigationController] pushViewController:vc animated:YES];
//}


//---------------------------------------------------------------------------------------------------------------------------------



- (IBAction)switchChanged:(UISwitch *)sender {
    
    // One of the switches on the screen has changed.  Respond to this.
    // The algorithm here implements a radio button, where the user can change the state only by turning it on.
    // The rest of the switches are turned off and the sender is turned on.  If it's already on, it stays on.
    
    
    /*
     Modification log
     When           Who                 What
     
     29-Apr-2014    J. M. Hinckley      Initial development.
     
     */
    
    
    
    int idx = (int)[m_Switch indexOfObject:sender];  // index of selected item
    
    
    
    
    
    // Clear all flags, then set the flag only for the selected item.
    
    for (int i = 0; i < numItems; i++)
    {
        bItemIsSelected_Gender[i] = 0;
    }
    bItemIsSelected_Gender[idx] = 1;
    
    
    
    
    
    // Set all switches off, then just the selected one on.
    
    for (UISwitch* sw in m_Switch)
    {
        sw.on = FALSE;
    }
    
    ((UISwitch*)[m_Switch objectAtIndex:idx]).on = TRUE;
    
    
    
    
    
    
    // Either show or hide the text box, depending on which switch is selected.
    
    if (numItems > 2)
    {
        if (idx == 2 && bItemIsSelected_Gender[idx] == 1)
        {
            // "Other" item is selected.  Make the text box visible
            m_TextField.hidden = NO;
        }
        else
        {
            // Some other item is selected.
            m_TextField.hidden = YES;
        }
    }
    else
    {
        // "Other" item is not present.
        m_TextField.hidden = YES;
    }
    
    
    // Set State flag depending upon whether or not text field is displayed
    if (m_TextField.hidden)
    {
        State = 1;  // text field is hidden
    }
    else
    {
        State = 2;  // text field is displayed, but keyboard is not present
    }
    
    
    
    
    
    
    for (int i = 0; i < numItems; i++)
    {
        if (bItemIsSelected_Gender[i] == 1)
        {
            [GlobalData sharedManager].genderIdxSelected = i;    // save the index of the selected item
            switch (i)
            {
                case 0:
                    [GlobalData sharedManager].gender = @"female";
                    break;
                case 1:
                    [GlobalData sharedManager].gender = @"male";
                    break;
                case 2:
                    // Selection is "Other:".  Save the entered text.
                    [GlobalData sharedManager].gender = [[m_TextField.text lowercaseString] copy];  // save the text string at the selected switch
                    break;
                    
            }
            
            NSLog(@"Gender string = %@", [GlobalData sharedManager].gender);
        }
    }
    
}


//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark -------- UITextViewDelegate protocol methods --------



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    // Hide the switches and labels.
    for (int i = 0; i < numItems; i++)
    {
        ((UISwitch*)[m_Switch objectAtIndex:i]).hidden = YES;
        ((UILabel*)[m_Label objectAtIndex:i]).hidden = YES;
    }
    
    
    State = 3;  // set flag: text field is displayed and keyboard appears.
    
    // Some of the coordinates are OS version-dependent.
    // Get the version of the OS:
    NSString* osVer = [[UIDevice currentDevice] systemVersion];
    NSRange r = [osVer rangeOfString:@"."]; // find the first occurrence of "."
    NSString* osMajVer = [osVer substringToIndex:r.location];
    NSInteger verMajor = [osMajVer integerValue];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    //CGSize iPhone5 = CGSizeMake(640, 1136);
    
    CGSize iPhone4 = CGSizeMake(640, 960);
    
    
    
    if(screenSize.height == iPhone4.height && screenSize.width == iPhone4.width)
    {
        NSLog(@"Device is iPhone4, portrait orientation");
        
        textFieldFrame = m_TextField.frame; // save the frame for later restoration.
        
        textFieldVertConstraint = verticalPositionConstraint.constant;
        
        m_TextField.frame = CGRectMake(textFieldFrame.origin.x,    // x
                                      (verMajor >= 7 ? 200 : 135),   // y
                                      textFieldFrame.size.width,   // w
                                      textFieldFrame.size.height);   // h
        
        verticalPositionConstraint.constant = textFieldVertConstraint - (textFieldFrame.origin.y - m_TextField.frame.origin.y);
    }
    else //if (screenSize.height == iPhone5.height && screenSize.width == iPhone5.width)
    {
        
        textFieldFrame = m_TextField.frame; // save the frame for later restoration.
        
        textFieldVertConstraint = verticalPositionConstraint.constant;
        
        m_TextField.frame = CGRectMake(textFieldFrame.origin.x,    // x
                                      (verMajor >= 7 ? 200 : 200),   // y
                                      textFieldFrame.size.width,   // w
                                      textFieldFrame.size.height);   // h
        
        verticalPositionConstraint.constant = textFieldVertConstraint - (textFieldFrame.origin.y - m_TextField.frame.origin.y);
    }
    
    
    
    
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor greenColor];
//    m_LabelCharLeft.text = [NSString stringWithFormat:@"Characters left: %d",maxnumChars_CSLocation-textView.text.length];
//    m_LabelCharLeft.hidden = NO;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [string rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    
//    if (textView.text.length + text.length > maxnumChars_CSLocation)
//    {
//        if (location != NSNotFound)
//        {
//            [textView resignFirstResponder];
//        }
//        return NO;
//    }
//    else if (location != NSNotFound)
    if (location != NSNotFound)
    {
        [textField resignFirstResponder];
        return NO;
    }
//    int chars_left = maxnumChars_CSLocation-(textView.text.length + text.length);
//    // if this was a character delete, then text.length will equal 0 and the textView will still show the undeleted character.
//    // in this case, add 1 to chars_left to get the value that will be after the deletion.
//    if (text.length == 0) chars_left++;
//    m_LabelCharLeft.text = [NSString stringWithFormat:@"Characters left: %d",chars_left];
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor whiteColor];    // change the background color of the input view to gray
    
//    m_LabelCharLeft.hidden = YES;   // hide the count of the number of characters left
    
    // Selection is "Other:".  Save the entered text.
    [GlobalData sharedManager].gender = [[m_TextField.text lowercaseString] copy];  // save the text string at the selected switch
    
    NSLog(@"Gender string = %@", [GlobalData sharedManager].gender);
    
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) textFieldDidEndEditing:(UITextField *)textField
{
    // Some of the coordinates are OS version-dependent.
    // Get the version of the OS:
//    NSString* osVer = [[UIDevice currentDevice] systemVersion];
//    NSRange r = [osVer rangeOfString:@"."]; // find the first occurrence of "."
//    NSString* osMajVer = [osVer substringToIndex:r.location];
//    NSInteger verMajor = [osMajVer integerValue];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    //CGSize iPhone5 = CGSizeMake(640, 1136);
    
    CGSize iPhone4 = CGSizeMake(640, 960);
    
    if(screenSize.height == iPhone4.height && screenSize.width == iPhone4.width)
    {
        NSLog(@"Device is iPhone4, portrait orientation");
        
        m_TextField.frame = textFieldFrame;     // restore frame
        
        verticalPositionConstraint.constant = textFieldVertConstraint;
    }
    else //if (screenSize.height == iPhone5.height && screenSize.width == iPhone5.width)
    {
        
        m_TextField.frame = textFieldFrame;     // restore frame
        
        verticalPositionConstraint.constant = textFieldVertConstraint;
   }
    
    
    // Show the switches and labels.
    for (int i = 0; i < numItems; i++)
    {
        ((UISwitch*)[m_Switch objectAtIndex:i]).hidden = NO;
        ((UILabel*)[m_Label objectAtIndex:i]).hidden = NO;
    }
    
    
    State = 2;  // set flag: text field is displayed, but keyboard is removed.
    

    
}



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ----------- UIResponder overrides ---------------



//---------------------------------------------------------------------------------------------------------------------------------



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // resign the keyboard when user touches the background
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



//---------------------------------------------------------------------------------------------------------------------------------



@end
