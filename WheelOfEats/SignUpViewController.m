//
//  SignUpViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "SignUpViewController.h"
#import "SharingData.h"
#import "AFNetworking.h"
@import Firebase;

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *createEmail;
@property (weak, nonatomic) IBOutlet UITextField *createPassword;
@property (weak, nonatomic) IBOutlet UITextField *createRepeatPassword;

- (BOOL)validateEmail:(NSString *)emailStr;

@end

@implementation SignUpViewController
@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createEmail.delegate = self;
    self.createPassword.delegate = self;
    self.createRepeatPassword.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButtonPressed:(id)sender {
    
    if ([self validateEmail:[self.createEmail text]]) {
        if (![[self.createPassword text] isEqualToString:@""] && [[self.createPassword text] isEqualToString:[self.createRepeatPassword text]]) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            indicator.center = self.view.center;
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            
            [indicator startAnimating];

            [[FIRAuth auth] createUserWithEmail:self.createEmail.text password:self.createPassword.text completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                if (error) {
                    
                    NSLog(@"Sign Up error is occured!!!=====>%@", error);
                    

                    [indicator stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Sign up failed!"
                                                 message:@"Please retry after a moment."
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    //Handle your yes please button action here
                                                }];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else {
                    
                    
                    currentUser = user;
                    
                    //Initializing SharingData fields and Getting Yelp Access Token
                    SharingData *sharingData = [SharingData getInstance];
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSDictionary *params = @{@"grant_type": @"client_credentials",
                                             @"client_id": sharingData.CLIENT_ID,
                                             @"client_secret": sharingData.CLIENT_SECRET};
                    [manager POST:sharingData.YELP_API_AUTH_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        
                        [indicator stopAnimating];
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                        
                        NSDictionary *tokenData = (NSDictionary *)responseObject;
                        sharingData.ACCESS_TOKEN = tokenData[@"access_token"];
                        sharingData.TOKEN_TYPE = tokenData[@"token_type"];
                        NSLog(@"Yelp API Authentication ACCESS_TOKEN===>>%@,  TOKEN_TYPE===>>%@", sharingData.ACCESS_TOKEN, sharingData.TOKEN_TYPE);
                        
                    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        [indicator stopAnimating];
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"Authentication failed!"
                                                     message:@"Cannot connect YELP API!"
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //Handle your yes please button action here
                                                    }];
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }];
                    
                    
                    [self performSegueWithIdentifier:@"signUp" sender:nil];
                 }
                 
             }];
        }
        else {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"password!"
                                         message:@"Please confirm password."
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"e-mail!"
                                     message:@"Please input correct e-mail."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

    }

}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    if (nextTag > 2) {
        [textField resignFirstResponder];
    }
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


@end
