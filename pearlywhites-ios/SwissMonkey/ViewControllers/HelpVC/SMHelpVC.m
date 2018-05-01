//
//  SMHelpVC.m
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 08/03/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMHelpVC.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SMHelpVC ()<MFMailComposeViewControllerDelegate>

@end

@implementation SMHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *text = [_txtView text];
//    
//    /// Make a copy of the default paragraph style
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    /// Set line break mode
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    /// Set text alignment
//    paragraphStyle.alignment = NSTextAlignmentRight;
//    
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont ave_book_12],
//                                  NSParagraphStyleAttributeName: paragraphStyle };
//    
//    [text drawInRect:_txtView.frame withAttributes:attributes];
    
    [self loadNavViewOnMain];
    [_bgImageView setUserInteractionEnabled:NO];
}



- (void) loadNavViewOnMain{
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Support" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
}

- (void) viewWillAppear:(BOOL)animated{
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

- (IBAction)emailAction:(UIButton *)sender {
    [self showComposer:nil];
}

- (IBAction)callAction:(UIButton *)sender {
    NSString *phone = [_callButton.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneNumber = [SMValidation  formatePhoneNumberTxtFieldString:phone];
    phoneNumber = [[NSString alloc] initWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneUrl = [NSURL URLWithString:phoneNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        RBACustomAlert *calert = [[RBACustomAlert alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

#pragma mark - EMail composer  when tapping on Email button
-(void) showComposer:(NSString *)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet:sender];
        }else{
            [self launchMailAppOnDevice:sender];
        }
    }else{
        [self launchMailAppOnDevice:sender];
    }
    
}


// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void) displayComposerSheet:(NSString *)body {
    
    MFMailComposeViewController *tempMailCompose = [[MFMailComposeViewController alloc] init];
    tempMailCompose.mailComposeDelegate = self;
    
    body = @"";
    [tempMailCompose setSubject:@"Feedback"];
    [tempMailCompose setToRecipients: [NSArray arrayWithObjects:_emailButton.titleLabel.text, nil] ];
    [tempMailCompose setMessageBody:body isHTML:NO];
    [self presentViewController:tempMailCompose animated:YES completion:nil];
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", @"", @"SwissMonkey"];
    NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
@end
