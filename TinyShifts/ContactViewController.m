//
//  ContactViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ContactViewController.h"


@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


-(void) viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    
    
    // email subject
    NSString* emailTitle = @"Message from Affirmations";
    
    // email content
    NSString* messageBody = @"";
    
    // To address
    NSArray* toRecipients = [NSArray arrayWithObject:@"v8vette@gmail.com"];
    
    MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    // present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
   
    
}




@end
