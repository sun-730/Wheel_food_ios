//
//  SettingViewController.m
//  WheelOfEats
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "SettingViewController.h"
@import Firebase;
#import "AppDelegate.h"
#import "Global.h"
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PDKBoard.h"
#import "TMAPIClient.h"
#import <MessageUI/MessageUI.h>
#import <SafariServices/SafariServices.h>
#import <TwitterKit/TwitterKit.h>
#import <TwitterCore/TwitterCore.h>

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitch;

@property (nonatomic, strong) NSArray *PinterestBoards;
@end
Global *globalData;
TMAPIClient *tmapiClient;
NSString *shareStr = @"Check out this iPhone app called Wheel of Eats. It helps you decide what to eat when you're indecisive.";

@implementation SettingViewController{
AppDelegate* appDel ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    globalData = [Global getInstance];
    if(globalData.IS_MUTE){
        [_musicSwitch setOn:NO animated:YES];
    }else{
        [_musicSwitch setOn:YES animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)musicSwitchPressed:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        globalData.IS_MUTE =NO;
        appDel.isMute = NO;
        NSLog(@"ON");
    } else {
        globalData.IS_MUTE = YES;
        appDel.isMute = YES;
        NSLog(@"Off");
    }
}

- (IBAction)privacyPolicyPressed:(id)sender {
}

//Share functions
- (IBAction)facebookShare:(id)sender {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        if ([dialog canShow]) {
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            content.contentURL = [NSURL URLWithString:shareStr];
            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
            dialog.fromViewController = self;
            dialog.delegate = self;
            dialog.shareContent = content;
            dialog.mode = FBSDKShareDialogModeNative; // if you don't set this before canShow call, canShow would always return YES
            if (![dialog canShow]) {
                // fallback presentation when there is no FB app
                dialog.mode = FBSDKShareDialogModeFeedBrowser;
            }
            [dialog show];
        }
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                           @"Facebook login failed!" message:nil delegate:
                                           self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [alertView show];
             }
             else if (result.isCancelled)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                           @"Facebook login cancel!" message:nil delegate:
                                           self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [alertView show];
             }
             else
             {
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
                     if ([dialog canShow]) {
                         FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
                         content.contentURL = [NSURL URLWithString:shareStr];
                         FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
                         dialog.fromViewController = self;
                         dialog.delegate = self;
                         dialog.shareContent = content;
                         dialog.mode = FBSDKShareDialogModeNative; // if you don't set this before canShow call, canShow would always return YES
                         if (![dialog canShow]) {
                             // fallback presentation when there is no FB app
                             dialog.mode = FBSDKShareDialogModeFeedBrowser;
                         }
                         [dialog show];
                     }
                 }else{
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                               @"Permission denied" message:nil delegate:
                                               self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     [alertView show];
                 }
             }
         }];
    }
}
- (IBAction)googleShare:(id)sender {
    // Construct the Google+ share URL
    
    NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                      initWithString:@"https://plus.google.com/share"];
    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"Wheel of Eat"
                                  value:shareStr ]];
    NSURL* url = [urlComponents URL];
    
    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 9+)
        SFSafariViewController* controller = [[SFSafariViewController alloc]
                                              initWithURL:url];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (IBAction)instagramShare:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
//    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
//    {
//        NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.png"];
//        NSData *imageData=UIImagePNGRepresentation(imageToUse);
//        [imageData writeToFile:saveImagePath atomically:YES];
//        NSURL *imageURL=[NSURL fileURLWithPath:saveImagePath];
//        self.documentController=[[UIDocumentInteractionController alloc]init];
//        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:imageURL];
//        self.documentController.delegate = self;
//        self.documentController.annotation = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Testing"], @"InstagramCaption", nil];
//        self.documentController.UTI = @"com.instagram.exclusivegram";
//        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [self.documentController presentOpenInMenuFromRect:CGRectMake(1, 1, 1, 1) inView:vc.view animated:YES];
//    }
//    else {
//        DisplayAlertWithTitle(@"Instagram not found", @"")
//    }
}
- (IBAction)pinterestShare:(id)sender {
    
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                              PDKClientWritePublicPermissions,
                                                              PDKClientReadRelationshipsPermissions,
                                                              PDKClientWriteRelationshipsPermissions]
                                         fromViewController:self
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         [[PDKClient sharedInstance] getAuthenticatedUserBoardsWithFields:[NSSet setWithArray:@[@"id", @"image", @"description", @"name", @"privacy"]]
                                                                  success:^(PDKResponseObject *responseObject) {
                                                                      [self sharePinterest];
                                                                      
                                                                  } andFailure:nil];
         
     } andFailure:^(NSError *error) {
         
     }];
}
-(void)sharePinterest{
}
- (IBAction)twitterShare:(id)sender {
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    
    // Check if current session has users logged in
    if ([store hasLoggedInUsers]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:shareStr];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            if(result == SLComposeViewControllerResultCancelled){
                NSLog(@"Post Canceled");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"Post Canceled" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }else {
                NSLog(@"Post Done!");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"Post Sucessful" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }else{
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                
                SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [mySLComposerSheet setInitialText:shareStr];
                
                [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                    if(result == SLComposeViewControllerResultCancelled){
                        NSLog(@"Post Canceled");
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                                  @"Post Canceled" message:nil delegate:
                                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alertView show];
                    }else {
                        NSLog(@"Post Done!");
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                                  @"Post Sucessful" message:nil delegate:
                                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alertView show];
                        
                    }
                }];
                [self presentViewController:mySLComposerSheet animated:YES completion:nil];
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"No Twitter Accounts Available" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
}
- (IBAction)tumblrShare:(id)sender {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Wheel of Eats",@"title",
                               shareStr,@"body",nil];
    
//    [[TMAPIClient sharedInstance] post:@"blogName" type:@"text" parameters:parameters callback:^(id var, NSError *error){
//        NSLog(@"Error %@",error);
//    }];
    tmapiClient = [TMAPIClient sharedInstance];
    tmapiClient.OAuthConsumerKey = @"5fpsum8xG3hOb6FMu337J9bhDDTqjNzMsaqTD3Sx57QjA4EwFU";
    tmapiClient.OAuthConsumerSecret = @"Fq4OMq0cztvY7f7MfgjLdmslbghwQ7Cd3KRimzrbMGh9CHxjz2";
    tmapiClient.OAuthToken = @"3oI5kSXif80wlULlQzG1GgwU4im7aKduvPt7iuDBsetVTOrhUv";
    tmapiClient.OAuthTokenSecret = @"daOIzI2GCN4AgxY7W7gG6meH0y9x5N6qYVaG8wXACdFhgcLYj4";
    [tmapiClient userInfo:^ (id result, NSError *error) {
        if(error){
            NSLog(@"Tumblr get userinfo : %@", error);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Tweet composition canceled" message:nil delegate:
                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return ;
        }
        
        NSLog(@"Tumblr get info : %@", result[@"user"][@"blogs"]);
        NSArray *tumblrBlogs = result[@"user"][@"blogs"];
        if(tumblrBlogs.count > 0){
            NSDictionary * dic = tumblrBlogs[0];
            
            NSArray *paramsKeys = [[NSArray alloc] initWithObjects:@"title",@"body", nil];
            NSArray *paramsValue = [[NSArray alloc] initWithObjects:@"Wheel of Eat",shareStr, nil];
            NSDictionary *paramsDict = [[NSDictionary alloc] initWithObjects:paramsValue forKeys:paramsKeys];
            
            [tmapiClient text:shareStr parameters:paramsDict callback:^(id response, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Tumblr share failed" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                    NSLog(@"Error %@", error);
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Tumblr share success!" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
            }];
        }
    }];
//    tmapiClient.OAuthConsumerKey = @"5fpsum8xG3hOb6FMu337J9bhDDTqjNzMsaqTD3Sx57QjA4EwFU";
//    tmapiClient.OAuthConsumerSecret = @"Fq4OMq0cztvY7f7MfgjLdmslbghwQ7Cd3KRimzrbMGh9CHxjz2";
//    tmapiClient.OAuthToken = @"3oI5kSXif80wlULlQzG1GgwU4im7aKduvPt7iuDBsetVTOrhUv";
//    tmapiClient.OAuthTokenSecret = @"daOIzI2GCN4AgxY7W7gG6meH0y9x5N6qYVaG8wXACdFhgcLYj4";
//    [tmapiClient userInfo:^ (id result, NSError *error) {
//        if(error){
//            NSLog(@"Tumblr get userinfo : %@", error);
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
//                                      @"Tweet composition canceled" message:nil delegate:
//                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alertView show];
//            return ;
//        }
//
//        NSLog(@"Tumblr get info : %@", result[@"user"][@"blogs"]);
//        NSArray *tumblrBlogs = result[@"user"][@"blogs"];
//        if(tumblrBlogs.count > 0){
//            NSDictionary * dic = tumblrBlogs[0];
//            NSString *TumblrBlogName = dic[@"name"];
//            [tmapiClient post:@"Wheel of Eats" type:@"text" parameters:parameters callback:^(id var, NSError *error) {
//                NSLog(@"Error %@", error);
//            }];
//        }
//    }];
}
- (IBAction)emailShare:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setSubject:@"Wheel Of Eats"];
         [mailController setMessageBody:shareStr isHTML:NO];
         [self presentViewController:mailController animated:YES completion:nil];
         }
         
}
 // Then implement the delegate method
 - (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
     [self dismissViewControllerAnimated:YES completion:nil];
 }
//FollowUs function
- (IBAction)facebookFollow:(id)sender {
    NSURL *fbURL = [[NSURL alloc] initWithString:@"https://www.facebook.com/wheelsofeats/"];
    [[UIApplication sharedApplication] openURL:fbURL];
}
- (IBAction)twitterFollow:(id)sender {
    NSURL *fbURL = [[NSURL alloc] initWithString:@"https://twitter.com/DesignRoxLLC"];
    [[UIApplication sharedApplication] openURL:fbURL];
}
- (IBAction)instagramFollow:(id)sender {
    NSURL *fbURL = [[NSURL alloc] initWithString:@"https://www.instagram.com/wheelofeats/"];
    [[UIApplication sharedApplication] openURL:fbURL];
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
}





@end
