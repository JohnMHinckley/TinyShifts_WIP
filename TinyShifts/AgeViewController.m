//
//  AgeViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/12/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "AgeViewController.h"
#import "CGradientButton.h"
#import "AppDelegate.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "EthnicityViewController.h"
#import "CDatabaseInterface.h"



@interface AgeViewController ()

@end

@implementation AgeViewController
@synthesize textfieldAge;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize interface state flag: keypad not showing
    State = 1;
   
    // Adjust the navigation item
    // Title
    self.navigationItem.title = @"Age";
    
    
    // Right button
    CGradientButton* rightNavigationButton = [[CGradientButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [rightNavigationButton setTitle:@"Next" forState:UIControlStateNormal];
    [rightNavigationButton setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    rightNavigationButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [rightNavigationButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    if ([GlobalData sharedManager].age > 0)
    {
        textfieldAge.text = [NSString stringWithFormat:@"%d", [GlobalData sharedManager].age];
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
    // Note: a valid age is > 0 and <= 130 years.
    
    [GlobalData sharedManager].age = [textfieldAge.text intValue] ; // save result
    
    
    // Special handling if keypad is present.
    if (State == 2)
    {
        // resign the keyboard
        [self.view endEditing:YES];
        
        State = 1;
    }
    
    
    // is the input age a valid positive integer?
    if ([GlobalData sharedManager].age > 0 && [GlobalData sharedManager].age < 131)
    {
        // The entered age is a valid positive integer
        
        NSLog(@"Age value saved: %d", [GlobalData sharedManager].age);
        
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"PersonalCharacteristics" bundle:nil];
        EthnicityViewController* vc = [sb instantiateViewControllerWithIdentifier:@"EthnicityViewController"];
        vc.navigationItem.hidesBackButton = NO;
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else
    {
        // The input value is not valid.
        // Generate an alert message.
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry for Age" message:@"Please enter a valid positive integer for your age in years." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
}



-(void) viewWillAppear:(BOOL)animated
{
    
}

-(void) portraitLock {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.screenIsPortraitOnly = true;
}

#pragma mark - interface posiiton

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}


//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark -------- UITextViewDelegate protocol methods --------



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    State = 2;  // set flag: text field is displayed and keypad appears.
    
    
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    textfieldAge.backgroundColor = [UIColor greenColor];
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [string rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    [GlobalData sharedManager].age = [textfieldAge.text intValue];  // save the input integer value
    
    
    if (location != NSNotFound)
    {
        [textField resignFirstResponder];
        return NO;
    }

    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    textfieldAge.backgroundColor = [UIColor whiteColor];    // change the background color of the input view to gray
    
    //    m_LabelCharLeft.hidden = YES;   // hide the count of the number of characters left
    
    // Selection is "Other:".  Save the entered text.
    [GlobalData sharedManager].age = [textfieldAge.text intValue];  // save the input integer value
    
    NSLog(@"Age = %d", [GlobalData sharedManager].age);
    
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) textFieldDidEndEditing:(UITextField *)textField
{
    
    State = 1;  // set flag: keypad is not displayed
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
