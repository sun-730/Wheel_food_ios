//
//  SignInViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "SignInViewController.h"
#import "SharingData.h"
#import "AFNetworking.h"
#import "KeychainWrapper.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookSignInButton;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end



@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.signInButton addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.facebookSignInButton addTarget:self
                                 action:@selector(facebookSignInButtonPressed)
                       forControlEvents:UIControlEventTouchUpInside];
    
    //Saved data load
    self.emailField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_email"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_pass"];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)facebookIsSetup
{
    NSString *facebookAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
    NSString *facebookDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookDisplayName"];
    BOOL canOpenFacebook =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb%@://", facebookAppId]]];
    
    if ([@"<YOUR FACEBOOK APP ID>" isEqualToString:facebookAppId] ||
        [@"<YOUR FACEBOOK APP DISPLAY NAME>" isEqualToString:facebookDisplayName] || !canOpenFacebook) {
        return NO;
    } else {
        return YES;
    }
}

- (void)signInButtonPressed {
    
    if ([self validateEmail:[self.emailField text]]) {
        if ([self.passwordField text] != nil && ![[self.passwordField text] isEqualToString:@""]) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            indicator.center = self.view.center;
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            
            [indicator startAnimating];
            
            [[FIRAuth auth] signInWithEmail:_emailField.text password:_passwordField.text completion:^(FIRUser *user, NSError *error) {
                if (error) {
                    
                    [indicator stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Sign in failed!"
                                                 message:@"Please try again with correct information."
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
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.emailField.text forKey:@"user_email"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"user_pass"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //Initializing SharingData fields and Getting Yelp Access Token
                    
//                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//                    NSDictionary *params = @{@"grant_type": @"client_credentials",
//                                          @"client_id": sharingData.CLIENT_ID,
//                                          @"client_secret": sharingData.CLIENT_SECRET};
//                    [manager POST:sharingData.YELP_API_AUTH_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                        
//                        [indicator stopAnimating];
//                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                        
//                        NSDictionary *tokenData = (NSDictionary *)responseObject;
//                        sharingData.ACCESS_TOKEN = tokenData[@"access_token"];
//                        sharingData.TOKEN_TYPE = tokenData[@"token_type"];
//                        NSLog(@"Yelp API Authentication ACCESS_TOKEN===>>%@,  TOKEN_TYPE===>>%@", sharingData.ACCESS_TOKEN, sharingData.TOKEN_TYPE);
//                        
//                     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                         
//                         [indicator stopAnimating];
//                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                         
//                         UIAlertController * alert = [UIAlertController
//                                                      alertControllerWithTitle:@"Authentication failed!"
//                                                      message:@"Cannot connect YELP API!"
//                                                      preferredStyle:UIAlertControllerStyleAlert];
//                         UIAlertAction* yesButton = [UIAlertAction
//                                                     actionWithTitle:@"OK"
//                                                     style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * action) {
//                                                         //Handle your yes please button action here
//                                                     }];
//                         [alert addAction:yesButton];
//                         [self presentViewController:alert animated:YES completion:nil];
//                         
//                         
//                     }];

//                    NSString *tutoFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"tuto_view"];
//                    if (tutoFlag == nil)
//                        [self performSegueWithIdentifier:@"withTuto" sender:nil];
//                    else
//                        [self performSegueWithIdentifier:@"withoutTuto" sender:nil];
                    [self performSegueWithIdentifier:@"myWheelLogin" sender:nil];
                }
                
                
            }];
            
        }
        else {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"password!"
                                         message:@"Please input password."
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
                                     message:@"Please enter a valid email address"
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

- (void)facebookSignInButtonPressed
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Facebook login failed. Error: %@", error);
        } else if (result.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else if ([FBSDKAccessToken currentAccessToken]) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            indicator.center = self.view.center;
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            
            [indicator startAnimating];

            
            FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                            credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                            .tokenString];
            [[FIRAuth auth] signInWithCredential:credential
                                      completion:^(FIRUser *user, NSError *error) {
                                          // ...
                                          if (error) {
                                              NSLog(@"Loggin Error");
                                              return;
                                          }
                                          else {
                                              
                                              
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
                                              
//                                              NSString *tutoFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"tuto_view"];
//                                              if (tutoFlag == nil)
//                                                  [self performSegueWithIdentifier:@"withTuto" sender:nil];
//                                              else
//                                                  [self performSegueWithIdentifier:@"withoutTuto" sender:nil];
                                              [[NSUserDefaults standardUserDefaults] setObject:@"facebookLogin" forKey:@"user_email"];
                                              [[NSUserDefaults standardUserDefaults] setObject:@"facebookLogin" forKey:@"user_pass"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];

                                                    [self performSegueWithIdentifier:@"myWheelLogin" sender:nil];
                                          
                                          }
                                      }];
            
            
        }
    }];

}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    if (nextTag > 1) {
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
