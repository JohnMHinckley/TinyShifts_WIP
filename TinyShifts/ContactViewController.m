//
//  ContactViewController.m
//  TinyShifts
//
//  Created by Dr. John M. Hinckley on 2/8/15.
//  Copyright (c) 2015 Gurmentor Inc. All rights reserved.
//

#import "ContactViewController.h"
#import "ConstGen.h"
#import "CDatabaseInterface.h"
#import "Backendless.h"
#import "RDB_ContactActivity.h"
#import "ContactActivity_Rec.h"

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
    
    
    //[self composeEmail];
    
    
    
}




-(void) composeEmail
{
    // email subject
    NSString* emailTitle = @"Message from TinyShifts app user";
    
    // email content
    NSString* messageBody = @"";
    
    // To address
    NSArray* toRecipients = [NSArray arrayWithObject:ContactEMailAddress];
    
    MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            // present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
        else
        {
            //[self launchMailAppOnDevice];
        }
    }
    else
    {
        //  [self launchMailAppOnDevice];
    }
}



-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the mail interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}





- (IBAction)buttonPressedSendEmail:(CGradientButton *)sender {
    
    
    // Submit the contact activity information and then compose an email.
    
    ContactActivity_Rec* rec = [ContactActivity_Rec sharedManager];
    
    rec.idRecord++;
    rec.participantId = [[CDatabaseInterface sharedManager] getMyIdentity];     // participant identity
    
    // Get the current date and time and save these in the ContactActivity_Rec object.
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    
    //date formatter with just date and no time
    dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    //date formatter with no date and just time
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
    
    rec.dateRecord = [NSMutableString stringWithString:[dateFormatter1 stringFromDate:[NSDate date]]]; // the date right now
    rec.timeRecord = [NSMutableString stringWithString:[dateFormatter2 stringFromDate:[NSDate date]]]; // the time right now
    
    
    // Send the survey data to the remote database
    
    Responder* responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandlerSendContactActivity:)
                                selErrorHandler:@selector(errorHandler:)];
    
    RDB_ContactActivity* record = [[RDB_ContactActivity alloc] init];
    
    id<IDataStore> dataStore = [backendless.persistenceService of:[RDB_ContactActivity class]];
    
    [dataStore save:record responder:responder];
    
    
    
    
    [self composeEmail];
}



//---------------------------------------------------------------------------------------------------------------------------------



-(id)responseHandlerSendContactActivity:(id)response
{
    NSLog(@"Response Handler for send ContactActivity: Response = %@", response);
    
    //[[[UIAlertView alloc] initWithTitle:@"E-mail Sent" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return response;
}



//---------------------------------------------------------------------------------------------------------------------------------

-(void)errorHandler:(Fault *)fault
{
    NSLog(@"In error handler.");
}



//---------------------------------------------------------------------------------------------------------------------------------


@end
