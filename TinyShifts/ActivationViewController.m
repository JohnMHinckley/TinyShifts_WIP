//
//  ActivationViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/9/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ActivationViewController.h"
#import "AppDelegate.h"
#import "ConstGen.h"
#import "GlobalData.h"
#import "CActivationManager.h"

@interface ActivationViewController ()

@end

@implementation ActivationViewController
@synthesize m_TextActivation;
@synthesize m_LabelActivation;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalData sharedManager].displayedViewController = self;
    
    testCode = @"";
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



//---------------------------------------------------------------------------------------------------------------------------------



- (IBAction)OKButtonPressed:(CGradientButton *)sender {
    // The OK button on the activation screen has been pressed.
    
//    // Check if the activation code is valid.
//    BOOL bCodeIsValid = YES;
//    
//    if (bCodeIsValid)   // Check whether code is valid.
//    {
//        [GlobalData sharedManager].activated = ACTIVATED_YES;
//        
//        // Enable the tab bar items
//        activeTabBarController.tabBar.userInteractionEnabled = YES;
//        
//       // Code is valid, so return to the start screen.
//        [activeNavigationController popViewControllerAnimated:NO];
//    }
//    else
//    {
//        // Code is not valid.  Inform user, erase entered code and stay on this screen.
//        [GlobalData sharedManager].activated = ACTIVATED_NO;
//    }
    
    
    
    // Test whether testCode matches any activation code in the database.
    
    [m_TextActivation resignFirstResponder]; // put keyboard away
    
    // If it does match, set the activation flag true in the database and enable the normal controls on the interface.
    
    BOOL bDidActivate = [[CActivationManager sharedManager] attemptActivationWithCode:testCode];
    if (bDidActivate)
    {
        
        // Enable the tab bar items
        activeTabBarController.tabBar.userInteractionEnabled = YES;
        
        // Code is valid, so return to the start screen.
        [activeNavigationController popViewControllerAnimated:NO];

    }
    else
    {
        
        // If it does not, set the activation label to instruct the user to re-enter the activation code.
        //m_LabelActivation.text = @"Activation failed-try again.";
        [[[UIAlertView alloc] initWithTitle:@"Invalid Activation Code" message:@"Your valid activation code must be entered to proceed.  This is the code that you were assigned by the TinyShifts project administrator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    
    
    
    
}



//---------------------------------------------------------------------------------------------------------------------------------



#pragma mark ------------------- UIResponder overrides ---------------------



//---------------------------------------------------------------------------------------------------------------------------------



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // resign the keyboard when user touches the background
    //NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



//---------------------------------------------------------------------------------------------------------------------------------



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return NO;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //NSLog(@"textViewShouldBeginEditing: just before textview becomes active");
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //NSLog(@"textViewDidBeginEditing: text view becomes active and changes to first responder status");
    textView.backgroundColor = [UIColor greenColor];
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //NSLog(@"textViewShouldEndEditing: just before text text view becomes inactive");
    textView.backgroundColor = [UIColor lightGrayColor];
    
    // First, transfer the screen information to the survey data object.
    
    //[[CScheduleData sharedManager].id_pw setString:m_TextView.text];   // save the text from the screen in the schedule data object
    
    testCode = [m_TextActivation.text copy];
    
    //NSLog(@"Schedule Data member id_pw received value %@", [CScheduleData sharedManager].id_pw);
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@"textViewDidEndEditing:  text view has become inactive");
}



//---------------------------------------------------------------------------------------------------------------------------------



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet* doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    
    if (textView.text.length + text.length > 100)
    {
        if (location != NSNotFound)
        {
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



//---------------------------------------------------------------------------------------------------------------------------------



-(void) setActiveNavigationController:(UINavigationController*) nc
{
    // Set the active navigation controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active navigation controller is inherited from the calling view controller and is used to get back
    // to the calling view controller when the work in this view controller is done.
    
    activeNavigationController = nc;
}

-(void) setActiveTabBarController:(UITabBarController*) tc
{
    // Set the tab bar controller.
    // This method is called by the calling view controller, before creating this scene.
    // The active tab bar controller is inherited from the calling view controller and is accessed
    // in order to control its being enabled or not.
    activeTabBarController = tc;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self portraitLock];
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

@end
