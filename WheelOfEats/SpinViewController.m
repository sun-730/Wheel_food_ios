//
//  SpinViewController.m
//  WheelOfEats
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "SpinViewController.h"
@import GoogleMobileAds;
#import "SharingData.h"
#import "FRHyperLabel.h"
#import "KILabel.h"
#import "SpinViewController.h"
#import "Global.h"
#import "UnlockViewController.h"
#import "WheelEditViewController.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TMAPIClient.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PDKBoard.h"
#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import <TwitterCore/TwitterCore.h>


#define kBaseURL @"https://instagram.com/"
#define kInstagramAPIBaseURL @"https://api.instagram.com"
#define kAuthenticationURL @"oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=likes+comments+basic"  // comments
#define kClientID @"a57f63c07ff14695a18d0fd01cb7e117"
//#define kRedirectURI @"https://itunes.apple.com/nz/app/wheel-of-eats/id1239987112?mt=8"
#define kRedirectURI @"http://localhost/"
//5890211518.1677ed0.7ebae82984de42b4942b7e863b74f27e
@import Firebase;

@interface SpinViewController ()<
    FBSDKSharingDelegate
>
@property (weak, nonatomic) IBOutlet UIView *wheelView;
@property (weak, nonatomic) IBOutlet UILabel *defaultComment;
@property (weak, nonatomic) IBOutlet FRHyperLabel *sectorComment;
@property (weak, nonatomic) IBOutlet UITextView *sectorComment1;
@property (weak, nonatomic) IBOutlet UILabel *sectorTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sectorIcon;
@property (weak, nonatomic) IBOutlet UIButton *createNewButton;
@property (weak, nonatomic) IBOutlet UIButton *openInYelpButton;
@property (weak, nonatomic) IBOutlet UIButton *spinButton;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton0;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton1;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton2;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton3;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton4;
@property (weak, nonatomic) IBOutlet UIButton *cultureSpinButton5;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *longPressLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *flavor_left_button;
@property (weak, nonatomic) IBOutlet UIButton *flavor_right_button;

//@property (nonatomic) int* Hi;
//FOR SOCIAL
@property (weak, nonatomic) IBOutlet UIView *socialView;
@property (weak, nonatomic) IBOutlet UIButton *bttTumblr;
@property (weak, nonatomic) IBOutlet UIButton *bttFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btt_Pinterest;
@property (weak, nonatomic) IBOutlet UIButton *btt_Twitter;
@property (weak, nonatomic) IBOutlet UIButton *btt_Instagram;
@property (weak, nonatomic) IBOutlet UIButton *bttCancel;

@property (nonatomic, strong) NSArray *PinterestBoards;

//@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
//@property(nonatomic , strong) PHCachingImageManager *imageManager;
@end
Global *globalData;


@implementation SpinViewController{
    AppDelegate* appDel;
}

@synthesize wheelType;
@synthesize Hi;
@synthesize helpLink;

FRHyperLabel *label1;
UIImageView *bg;
NSString *bgImageName, *spinTitle;
NSString *shareType;
TMAPIClient *tmapiClient;
NSString *TumblrBlogName;



- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = [UIApplication sharedApplication].delegate;
    //AdMob view
    [self.bannerView sizeToFit];
    self.bannerView.adUnitID = @"ca-app-pub-1972998462639092/8780093952";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:request];
    [self.webView setHidden:true];
    self.webView.delegate = self;
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView setAlpha:1];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView setHidden:true];
    bgImageName = @"style_wheel_back.png";
    self.createNewButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.createNewButton.titleLabel.numberOfLines = 2;
    spinTitle = @"";
    [self.sectorTitle setHidden:true];
    [self.sectorComment setHidden:true];
    [self.sectorComment1 setHidden:true];
//
//    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.wheelView.bounds.size.height)];
//    bg.image = [UIImage imageNamed:@"style_wheel_back.png"];
//    [self.wheelView addSubview:bg];
    
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//    _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
//    _imageManager = [[PHCachingImageManager alloc] init];
    if(self.wheelType == BAKERY_WHEEL){
        [self.spinButton addTarget:self action:@selector(goToNextSpin) forControlEvents:UIControlEventTouchUpInside];
        bgImageName = @"bakery-bg.png";
    }else if(self.wheelType == VEGETARIAN_WHEEL){
        bgImageName = @"vegetarian-bg.png";
        [self.openInYelpButton setImage:[UIImage imageNamed:@"onlinerecipes.png"] forState:UIControlStateNormal];
        [self.openInYelpButton addTarget:self action:@selector(openInYelpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }else if(self.wheelType == CHEESE_WHEEL){
        [self.spinButton addTarget:self action:@selector(goToNextSpin1) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    appDel = [UIApplication sharedApplication].delegate;
    for(UIView *usview in self.wheelView.subviews){
        [usview removeFromSuperview];
    }
    if(self.wheelView.subviews.count == 0){
        bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.wheelView.bounds.size.height)];
        bg.image = [UIImage imageNamed:bgImageName];
        [self.wheelView addSubview:bg];
        
    }
    [self initUI];
    if(self.wheelType == FLAVORS_WHEEL){
        [self changeFlavor];
    }else if(self.wheelType == BAKERY_WHEEL){
        [self changeBakery];
    }else if(self.wheelType == SEAFOOD_WHEEL){
        [self changeSeafood];
        [self.openInYelpButton setImage:[UIImage imageNamed:@"onlinerecipes.png"] forState:UIControlStateNormal];
        [self.openInYelpButton addTarget:self action:@selector(openInYelpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }else if(self.wheelType == CHEESE_WHEEL){
        [self changeCheese];
    }else if(self.wheelType == VEGETARIAN_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"onlinerecipes.png"] forState:UIControlStateNormal];
    }else if(self.wheelType == WINE_DRINK_WHEEL){
        [self changeforWine];
    }else{
        [self changeBottom];
        [self.openInYelpButton addTarget:self action:@selector(openInYelpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 3 - Set up rotary wheel
    
    NSLog(@"BOOOO: %d, %d",wheelType,Hi);
    
    WOERotaryWheel *wheel = [[WOERotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 250, 250) andDelegate:self inWheel:wheelType];
    wheel.center = CGPointMake(self.view.bounds.size.width / 2, self.wheelView.bounds.size.height / 2);
    NSLog(@"hi: %d",wheel.wheelType);
    // 4 - Add wheel to view
    [self.wheelView addSubview:wheel];
    self.sectorTitle.text = spinTitle;
    
    
    [self checkInAppPurchaged];
    
}
-(void)checkInAppPurchaged {
    if(![appDel loadInAppPuchage:kPuchage_Custom]){
        [self.createNewButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.createNewButton addTarget:self action:@selector(goToWheelEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)goToUnlock:(UIButton *)sender{
    
    if(self.wheelType == BEER_DRINK_WHEEL){
//        [self showWebView:@"itms://itunes.apple.com/us/app/untappd-discover-beer/id449141888?mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/untappd-discover-beer/id449141888?mt=8"]];
        return;
    }
    if([self.sectorTitle.text isEqualToString:@"FOOD TRUCK"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/roaming-hunger-food-truck/id423850578?mt=8"]];
        return;
    }
    if(self.wheelType == BAKERY_WHEEL){
        return;
    }
    [self FacebookShare];
    return;
    UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:unlock];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)goToWheelEdit:(UIButton *)sender{
    if([self.sectorTitle.text isEqualToString:@"FOOD TRUCK"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/roaming-hunger-food-truck/id423850578?mt=8"]];
        return;
    }
    if(self.wheelType == BAKERY_WHEEL){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = TEA_DRINK_WHEEL;
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:spin];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
        return;
    }
    [self FacebookShare];
    return;
    if(![appDel loadInAppPuchage:kPuchage_Custom]){
        UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
        
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:unlock];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    }else{
        WheelEditViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WheelEditViewController"];
        
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:unlock];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    }
    
}

- (void)goToNextSpin{
    SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
    spin.wheelType = FLAVORS_WHEEL;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:spin];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}
- (void)goToNextSpin1{
    SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
    spin.wheelType = WINE_DRINK_WHEEL;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:spin];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

-(void)changeFlavor{
    [self.createNewButton setHidden:true];
    [self.openInYelpButton setHidden:true];
    [self.bannerView setHidden:false];
    [self.flavor_left_button setHidden:false];
    [self.flavor_right_button setHidden:true];
}

-(void)changeBakery{
    [self.openInYelpButton setHidden:true];
    [self.spinButton setHidden:false];
    [self.spinButton setImage:[UIImage imageNamed:@"pickflavor.png"] forState:UIControlStateNormal];
    [self.createNewButton setBackgroundImage:[UIImage imageNamed:@"empty_button.png"]  forState:UIControlStateNormal];
    [self.createNewButton setTitle:@"PICK MY TEA" forState:UIControlStateNormal];
}
-(void)changeSeafood{
    [self.sectorComment1 setHidden:false];
    [self.defaultComment setHidden:true];
    [self.sectorComment1 setText:@"Many if not all seafood are a good source of omega-3 fatty acids. Due to these unsaturated fats, they possess qualities that lower the risk of developing abnormal heartbeats, and reduce cholesterol buildup, thereby reducing the risk of heart disease and heart attack. It is recommended that pregnant women and women who might become pregnant should stay away from sea food as they are contaminated with mercury. However seafood is safe to consume in moderation."];
}
-(void)changeCheese{
    [self.sectorComment1 setHidden:false];
    [self.defaultComment setHidden:true];
    [self.openInYelpButton setHidden:true];
    [self.spinButton setHidden:false];
    [self.spinButton setImage:[UIImage imageNamed:@"wine_button.png"] forState:UIControlStateNormal];
    [self.sectorComment1 setText:@"Need to host a party, or fill a cheeseboard at a restaurant? Spin to help you decide. The following choices are popular cheeses that pair well with wine."];
}
-(void)changeforWine{
    [self.createNewButton setHidden:false];
    [self.openInYelpButton setHidden:false];
    [self.bannerView setHidden:true];
    [self.openInYelpButton setImage:[UIImage imageNamed:@"open_vivino.png"] forState:UIControlStateNormal];
    [self.openInYelpButton addTarget:self action:@selector(openVivinoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void)changeBottom{
    if(wheelType == TEA_DRINK_WHEEL || wheelType == LIQUOR_DRINK_WHEEL){
        [self.createNewButton setHidden:true];
        [self.openInYelpButton setHidden:true];
        [self.bannerView setHidden:false];
    }else if(wheelType == BEER_DRINK_WHEEL){
        
    }
}
- (void)goToFlavor {
    SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
    spin.wheelType = FLAVORS_WHEEL;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:spin];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)openVivinoButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/vivino-wine-scanner/id414461255?mt=8"]];
}
- (void)openInYelpButtonPressed {
    if(self.wheelType == BEER_DRINK_WHEEL){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/untappd-discover-beer/id449141888?mt=8"]];
    }else if(self.wheelType == VEGETARIAN_WHEEL){
        [self showWebView:self.helpLink];
    }else if(self.wheelType == SEAFOOD_WHEEL){
        [self showWebView:self.helpLink];
//    }else if([self.sectorTitle.text isEqualToString:@"SEAFOOD"]){
//        [self showWebView:self.helpLink];
//        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
//        spin.wheelType = SEAFOOD_WHEEL;
//        UINavigationController *navigationController =
//        [[UINavigationController alloc] initWithRootViewController:spin];
//        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }else if(self.wheelType == BAKERY_WHEEL){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = FLAVORS_WHEEL;
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:spin];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    }
    else{
        NSString *myCity = [Global getInstance].myCity;
        
        NSString *query = [NSString stringWithFormat:@"http://yelp.com/search?find_desc=%@&find_loc=%@", _sectorTitle.text, myCity];
        NSLog(@"query = %@", query);
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self showWebView:query];
//        [self maybeDoSomethingWithYelp];
//        [self insertResult];
    }
}

-(void)showWebView:(NSString *)link {
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.webView setHidden:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
        } else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
//Social intergration
-(void)FacebookShare{
    [self.socialView setHidden:false];
}

- (IBAction)backButtonItemPressed:(UIBarButtonItem *)sender {
    NSLog(@"Back: ");
    if(self.webView.isHidden){
        //    [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.webView setHidden:true];
    }
}


- (IBAction)backButtonPressed:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initUI {
//    [self.sectorTitle setHidden:true];
//    [self.sectorComment setHidden:true];
//    [self.sectorComment1 setHidden:true];
    [self.cultureSpinButton0 setHidden:true];
    [self.cultureSpinButton1 setHidden:true];
    [self.cultureSpinButton2 setHidden:true];
    [self.cultureSpinButton3 setHidden:true];
    [self.cultureSpinButton4 setHidden:true];
    [self.cultureSpinButton5 setHidden:true];
    if(self.wheelType == BEER_DRINK_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"download_untappd.png"] forState:UIControlStateNormal];
    }else if(self.wheelType == VEGETARIAN_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"open_yelp_button"] forState:UIControlStateNormal];
    }
    
    
    // Culture
    if (wheelType == CULTURE_FOOD_WHEEL) {
        [self.openInYelpButton setHidden:true];
        [self.spinButton setHidden:false];
    }
    // I'm a Vegetarian
    else if(wheelType == VEGETARIAN_WHEEL) {
        [self.openInYelpButton setHidden:false];
        [self.spinButton setHidden:true];
//        [self.sectorComment setHidden:false];
        [self.sectorComment1 setHidden:false];
        [self.defaultComment setHidden:true];
    }else if(wheelType == FLAVORS_WHEEL){
        [self.openInYelpButton setHidden:true];
        [self.spinButton setHidden:true];
        [self.sectorTitle setHidden:false];
        [self.defaultComment setHidden:true];
    }else if(wheelType == BAKERY_WHEEL){
        [self changeBakery];
    }
    // Food
    else {
        [self.openInYelpButton setHidden:false];
        [self.spinButton setHidden:true];
        [self FoodSelected];
    }
}
//08/09/17 added Cezar
-(void)FoodSelected{
    switch (wheelType) {
        case MEAT_WHEEL:
            [bg setImage: [UIImage imageNamed:@"meats-bg.png"]];
            bgImageName = @"meats-bg.png";
            break;
        case LIQUOR_DRINK_WHEEL:
            [bg setImage: [UIImage imageNamed:@"liquor-bg.png"]];
            bgImageName = @"liquor-bg.png";
            break;
        case BEER_DRINK_WHEEL:
            [bg setImage: [UIImage imageNamed:@"beer-BG.png"]];
            bgImageName = @"beer-BG.png";
            break;
        case TEA_DRINK_WHEEL:
            [bg setImage: [UIImage imageNamed:@"tea-bg.png"]];
            bgImageName = @"tea-bg.png";
            break;
        case WINE_DRINK_WHEEL:
            [bg setImage: [UIImage imageNamed:@"wine-bg.png"]];
            bgImageName = @"wine-bg.png";
            break;
        case SPANISH_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"spanish-homebg.png"]];
            bgImageName = @"spanish-homebg.png";
            break;
        case EUROPEAN_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"european-home-bg.png"]];
            bgImageName = @"european-home-bg.png";
            break;
        case NORTH_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"snorthamerica-homebg.png"]];
            bgImageName = @"snorthamerica-homebg.png";
            break;
        case ASIAN_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"asian-homebg.png"]];
            bgImageName = @"asian-homebg.png";
            break;
        case TROPICAL_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"tropical-caribean-homebg.png"]];
            bgImageName = @"tropical-caribean-homebg.png";
            break;
        case MIDDLE_CULTURE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"african-homebg.png"]];
            bgImageName = @"african-homebg.png";
            break;
        case SEAFOOD_WHEEL:
            [bg setImage: [UIImage imageNamed:@"seafood-bg.png"]];
            bgImageName = @"seafood-bg.png";
            break;
        case BAKERY_WHEEL:
            [bg setImage: [UIImage imageNamed:@"bakery-bg.png"]];
            bgImageName = @"bakery-bg.png";
            break;
        case CHEESE_WHEEL:
            [bg setImage: [UIImage imageNamed:@"cheese-bg.png"]];
            bgImageName = @"cheese-bg.png";
            break;
            
            
        default:
            break;
    }
}

- (void)wheelDidChangeSector:(int)newValue {
    if (wheelType == CULTURE_FOOD_WHEEL) {
        [self.spinButton setHidden:true];
        NSLog(@"culture food: %d",newValue);
        switch (newValue) {
                //Spanish
            case 0:
                [self.cultureSpinButton0 setHidden:false];
                [self.cultureSpinButton1 setHidden:true];
                [self.cultureSpinButton2 setHidden:true];
                [self.cultureSpinButton3 setHidden:true];
                [self.cultureSpinButton4 setHidden:true];
                [self.cultureSpinButton5 setHidden:true];
                break;
                // European
            case 1:
                [self.cultureSpinButton0 setHidden:true];
                [self.cultureSpinButton1 setHidden:false];
                [self.cultureSpinButton2 setHidden:true];
                [self.cultureSpinButton3 setHidden:true];
                [self.cultureSpinButton4 setHidden:true];
                [self.cultureSpinButton5 setHidden:true];
                break;
                // North America & Ocenia
            case 2:
                [self.cultureSpinButton0 setHidden:true];
                [self.cultureSpinButton1 setHidden:true];
                [self.cultureSpinButton2 setHidden:false];
                [self.cultureSpinButton3 setHidden:true];
                [self.cultureSpinButton4 setHidden:true];
                [self.cultureSpinButton5 setHidden:true];
                break;
                // Asian Cusine
            case 3:
                [self.cultureSpinButton0 setHidden:true];
                [self.cultureSpinButton1 setHidden:true];
                [self.cultureSpinButton2 setHidden:true];
                [self.cultureSpinButton3 setHidden:false];
                [self.cultureSpinButton4 setHidden:true];
                [self.cultureSpinButton5 setHidden:true];
                break;
                // Tropical & Carribean
            case 4:
                [self.cultureSpinButton0 setHidden:true];
                [self.cultureSpinButton1 setHidden:true];
                [self.cultureSpinButton2 setHidden:true];
                [self.cultureSpinButton3 setHidden:true];
                [self.cultureSpinButton4 setHidden:false];
                [self.cultureSpinButton5 setHidden:true];
                break;
                // Middle East & Africa
            case 5:
                [self.cultureSpinButton0 setHidden:true];
                [self.cultureSpinButton1 setHidden:true];
                [self.cultureSpinButton2 setHidden:true];
                [self.cultureSpinButton3 setHidden:true];
                [self.cultureSpinButton4 setHidden:true];
                [self.cultureSpinButton5 setHidden:false];
                break;
                
            default:
                break;
        }
    }
}

- (void)wheelDidChangeTitle:(NSString *)newValue {
    [self.defaultComment setHidden:true];
    spinTitle = newValue;
    self.sectorTitle.text = newValue;
    if(wheelType == FLAVORS_WHEEL){
        [self.sectorTitle setHidden:false];
        return;
    }else{
        [self.sectorTitle setHidden:false];
        
    }
    UIFont *currentFont = self.createNewButton.titleLabel.font;
    UIFont *newFont = [UIFont fontWithName:currentFont.fontName size:12];
    self.createNewButton.titleLabel.font = newFont;
    [self.createNewButton setBackgroundImage:[UIImage imageNamed:@"empty_button.png"] forState:UIControlStateNormal];
    [self.createNewButton setTitle:@"SHARE" forState:UIControlStateNormal];
    [self.openInYelpButton setImage: [UIImage imageNamed:@"open_yelp_button.png"] forState:UIControlStateNormal];
    
    if(self.wheelType == BEER_DRINK_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"download_untappd.png"] forState:UIControlStateNormal];
    }else if(self.wheelType == WINE_DRINK_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"open_vivino.png"] forState:UIControlStateNormal];
    }
    if([newValue isEqualToString:@"FOOD TRUCK"]){
        UIFont *newFont = [UIFont fontWithName:currentFont.fontName size:12];
        self.createNewButton.titleLabel.font = newFont;
        [self.createNewButton setBackgroundImage:[UIImage imageNamed:@"empty_button.png"] forState:UIControlStateNormal];
        [self.createNewButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.createNewButton setTitle:@"OPEN ROAMING HUNGER" forState:UIControlStateNormal];
//        [self.createNewButton setImage:[UIImage imageNamed:@"OpenRoaming.png"] forState:UIControlStateNormal];
    }else if(wheelType == BAKERY_WHEEL){
        [self changeBakery];
         
    }else if(wheelType == VEGETARIAN_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"onlinerecipes.png"] forState:UIControlStateNormal];
    }else if(wheelType == SEAFOOD_WHEEL){
        [self.openInYelpButton setImage:[UIImage imageNamed:@"onlinerecipes.png"] forState:UIControlStateNormal];
    }
    // change background
    if ([newValue isEqualToString: @"SEAFOOD"]) {
        if(wheelType != MEAT_WHEEL){
            [bg setImage: [UIImage imageNamed:@"seafood-bg.png"]];
            bgImageName = @"seafood-bg.png";
        }
    } else if ([newValue isEqualToString: @"FINE DINING"]) {
        [bg setImage: [UIImage imageNamed:@"fine-dining-bg.png"]];
        bgImageName = @"fine-dining-bg.png";
    } else if ([newValue isEqualToString: @"CASUAL"]) {
        [bg setImage: [UIImage imageNamed:@"fast-casual.png"]];
        bgImageName = @"fast-casual.png";
    } else if ([newValue isEqualToString: @"DINER"]) {
        [bg setImage: [UIImage imageNamed:@"diner-bg.png"]];
        bgImageName = @"diner-bg.png";
    } else if ([newValue isEqualToString:@"BREAKFAST" ]) {
        [bg setImage: [UIImage imageNamed:@"breakfast-bg.png"]];
        bgImageName = @"breakfast-bg.png";
    } else if ([newValue isEqualToString:@"FAST CASUAL" ]) {
        [bg setImage: [UIImage imageNamed:@"casual-bg.png"]];
        bgImageName = @"casual-bg.png";
    } else if ([newValue isEqualToString:@"WINE BAR"]) {
        [bg setImage: [UIImage imageNamed:@"wine-bg.png"]];
        bgImageName = @"wine-bg.png";
    } else if ([newValue isEqualToString:@"PIZZERIA" ]) {
        [bg setImage: [UIImage imageNamed:@"pizza-bg.png"]];
        bgImageName = @"pizza-bg.png";
    } else if ([newValue isEqualToString:@"FOOD CART" ]) {
        [bg setImage: [UIImage imageNamed:@"foodtruck-bg.png"]];
        bgImageName = @"foodtruck-bg.png";
    } else if ([newValue isEqualToString:@"BREWERY" ]) {
        [bg setImage: [UIImage imageNamed:@"beer-BG.png"]];
        bgImageName = @"beer-BG.png";
    } else if ([newValue isEqualToString: @"VEGETARIAN"]) {
        [bg setImage: [UIImage imageNamed:@"vegetarian-bg.png"]];
        bgImageName = @"vegetarian-bg.png";
    } else if ([newValue isEqualToString: @"GASTRO-PUB"]) {
        [bg setImage: [UIImage imageNamed:@"gastro-pub.png"]];
        bgImageName = @"gastro-pub.png";
    } else if ([newValue isEqualToString:@"SPANISH" ]) {
        [bg setImage: [UIImage imageNamed:@"spanish-homebg.png"]];
        bgImageName = @"spanish-homebg.png";
    } else if ([newValue isEqualToString: @"MIDDLE EAST & AFRICAN"]) {
        [bg setImage: [UIImage imageNamed:@"african-homebg.png"]];
        bgImageName = @"african-homebg.png";
    } else if ([newValue isEqualToString: @"   TROPICAL/CARIBBEAN   "]) {
        [bg setImage: [UIImage imageNamed:@"tropical-caribean-homebg.png"]];
        bgImageName = @"tropical-caribean-homebg.png";
    } else if ([newValue isEqualToString:@"NORTH AMERICA/OCEANIC" ]) {
        [bg setImage: [UIImage imageNamed:@"northamerica-homebg.png"]];
        bgImageName = @"northamerica-homebg.png";
    } else if ([newValue isEqualToString: @"EUROPEAN"]) {
        [bg setImage: [UIImage imageNamed:@"european-home-bg.png"]];
        bgImageName = @"european-home-bg.png";
    } else if ([newValue isEqualToString:@"ASIAN CUISINE"]) {
        [bg setImage: [UIImage imageNamed:@"asian-homebg.png"]];
        bgImageName = @"asian-homebg.png";
    } else if ([newValue isEqualToString:@"PERUVIAN"]) {
        [bg setImage: [UIImage imageNamed:@"peruvian-bg.png"]];
        bgImageName = @"peruvian-bg.png";
    } else if ([newValue isEqualToString:@"ECUADORIAN"]) {
        [bg setImage: [UIImage imageNamed:@"ecuadorian-bg.png"]];
        bgImageName = @"ecuadorian-bg.png";
    } else if ([newValue isEqualToString:@"BRAZILIAN"]) {
        [bg setImage: [UIImage imageNamed:@"brazilian-bg.png"]];
        bgImageName = @"brazilian-bg.png";
    } else if ([newValue isEqualToString:@"MEXICAN"]) {
        [bg setImage: [UIImage imageNamed:@"mexican-bg.png"]];
        bgImageName = @"mexican-bg.png";
    } else if ([newValue isEqualToString:@"COLOMBIAN"]) {
        [bg setImage: [UIImage imageNamed:@"colombian-bg.png"]];
        bgImageName = @"colombian-bg.png";
    } else if ([newValue isEqualToString:@"SPAIN"]) {
        [bg setImage: [UIImage imageNamed:@"spain-bg.png"]];
        bgImageName = @"spain-bg.png";
    } else if ([newValue isEqualToString:@"TURKISH"]) {
        [bg setImage: [UIImage imageNamed:@"turkish-bg.png"]];
        bgImageName = @"turkish-bg.png";
    } else if ([newValue isEqualToString:@"NORTH AFRICAN"]) {
        [bg setImage: [UIImage imageNamed:@"north-african-bg.png"]];
        bgImageName = @"north-african-bg.png";
    } else if ([newValue isEqualToString:@"NIGERIAN"]) {
        [bg setImage: [UIImage imageNamed:@"nigerian-bg.png"]];
        bgImageName = @"nigerian-bg.png";
    } else if ([newValue isEqualToString:@"ETHIOPIAN"]) {
        [bg setImage: [UIImage imageNamed:@"ethiopian-BG.png"]];
        bgImageName = @"ethiopian-BG.png";
    } else if ([newValue isEqualToString:@"SOUTH AFRICAN"]) {
        [bg setImage: [UIImage imageNamed:@"south-african-BG.png"]];
        bgImageName = @"south-african-BG.png";
    } else if ([newValue isEqualToString:@"MOROCCAN"]) {
        [bg setImage: [UIImage imageNamed:@"moroccan-bg.png"]];
        bgImageName = @"moroccan-bg.png";
    } else if ([newValue isEqualToString:@"DOMINICAN"]) {
        [bg setImage: [UIImage imageNamed:@"dominican-bg.png"]];
        bgImageName = @"dominican-bg.png";
    } else if ([newValue isEqualToString:@"BAHAMAS"]) {
        [bg setImage: [UIImage imageNamed:@"Bahamas-bg.png"]];
        bgImageName = @"Bahamas-bg.png";
    } else if ([newValue isEqualToString:@"PUERTO RICAN"]) {
        [bg setImage: [UIImage imageNamed:@"puerto-rican-bg.png"]];
        bgImageName = @"puerto-rican-bg.png";
    } else if ([newValue isEqualToString:@"JAMAICAN"]) {
        [bg setImage: [UIImage imageNamed:@"jamaican-BG.png"]];
        bgImageName = @"jamaican-BG.png";
    } else if ([newValue isEqualToString:@"CUBAN"]) {
        [bg setImage: [UIImage imageNamed:@"cuban-BG.png"]];
        bgImageName = @"cuban-BG.png";
    } else if ([newValue isEqualToString:@"HAITIAN"]) {
        [bg setImage: [UIImage imageNamed:@"haitian-bg.png"]];
        bgImageName = @"haitian-bg.png";
    } else if ([newValue isEqualToString:@"JAPANESE"]) {
        [bg setImage: [UIImage imageNamed:@"japanese-BG.png"]];
        bgImageName = @"japanese-BG.png";
    } else if ([newValue isEqualToString:@"THAI"]) {
        [bg setImage: [UIImage imageNamed:@"thai-bg.png"]];
        bgImageName = @"thai-bg.png";
    } else if ([newValue isEqualToString:@"CHINESE"]) {
        [bg setImage: [UIImage imageNamed:@"chinese_BG.png"]];
        bgImageName = @"chinese_BG.png";
    } else if ([newValue isEqualToString:@"INDIAN"]) {
        [bg setImage: [UIImage imageNamed:@"indian-bg.png"]];
        bgImageName = @"indian-bg.png";
    } else if ([newValue isEqualToString:@"KOREAN"]) {
        [bg setImage: [UIImage imageNamed:@"korean-bg.png"]];
        bgImageName = @"korean-bg.png";
    } else if ([newValue isEqualToString:@"PHILIPPINE"]) {
        [bg setImage: [UIImage imageNamed:@"philipine-bg.png"]];
        bgImageName = @"philipine-bg.png";
    } else if ([newValue isEqualToString:@"VIETNAMESE"]) {
        [bg setImage: [UIImage imageNamed:@"vietnamese-bg.png"]];
        bgImageName = @"vietnamese-bg.png";
    } else if ([newValue isEqualToString:@"MONGOLIAN"]) {
        [bg setImage: [UIImage imageNamed:@"mongolian-bg.png"]];
        bgImageName = @"mongolian-bg.png";
    } else if ([newValue isEqualToString:@"FRENCH"]) {
        [bg setImage: [UIImage imageNamed:@"france-bg.png"]];
        bgImageName = @"france-bg.png";
    } else if ([newValue isEqualToString:@"GERMAN"]) {
        [bg setImage: [UIImage imageNamed:@"german-bg.png"]];
        bgImageName = @"german-bg.png";
    } else if ([newValue isEqualToString:@"ITALIAN"]) {
        [bg setImage: [UIImage imageNamed:@"italian-bg.png"]];
        bgImageName = @"italian-bg.png";
    } else if ([newValue isEqualToString:@"POLISH"]) {
        [bg setImage: [UIImage imageNamed:@"polish-bg.png"]];
        bgImageName = @"polish-bg.png";
    } else if ([newValue isEqualToString:@"GREEK"]) {
        [bg setImage: [UIImage imageNamed:@"greek-BG.png"]];
        bgImageName = @"greek-BG.png";
    } else if ([newValue isEqualToString:@"BELGIAN"]) {
        if(wheelType != BEER_DRINK_WHEEL){
            [bg setImage: [UIImage imageNamed:@"belgian-bg.png"]];
            bgImageName = @"belgian-bg.png";
        }
    } else if ([newValue isEqualToString:@"SWEDISH"]) {
        [bg setImage: [UIImage imageNamed:@"sweden-bg.png"]];
        bgImageName = @"sweden-bg.png";
    } else if ([newValue isEqualToString:@"IRISH"]) {
        [bg setImage: [UIImage imageNamed:@"irish-bg.png"]];
        bgImageName = @"irish-bg.png";
    }else if ([newValue isEqualToString:@"SOUTHERN"]) {
        [bg setImage: [UIImage imageNamed:@"southern-bg.png"]];
        bgImageName = @"southern-bg.png";
    }else if ([newValue isEqualToString:@"HAWIIAN"]) {
        [bg setImage: [UIImage imageNamed:@"hawaii-bg.png"]];
        bgImageName = @"hawaii-bg.png";
    }else if ([newValue isEqualToString:@"CLASSIC"]) {
        [bg setImage: [UIImage imageNamed:@"classic-bg.png"]];
        bgImageName = @"classic-bg.png";
    }else if ([newValue isEqualToString:@"BARBECUE FOOD"]) {
        [bg setImage: [UIImage imageNamed:@"barbeque-bg.png"]];
        bgImageName = @"barbeque-bg.png";
    }else if ([newValue isEqualToString:@"FRENCH CANADIAN"]) {
        [bg setImage: [UIImage imageNamed:@"candian-BG.png"]];
        bgImageName = @"candian-BG.png";
    }else if([newValue isEqualToString:@"TAPAS"]) {
        [bg setImage: [UIImage imageNamed:@"tapas-BG.png"]];
        bgImageName = @"tapas-BG.png";
    }else if([newValue isEqualToString:@"HIBACHI"]) {
        [bg setImage: [UIImage imageNamed:@"hibachi-BG.png"]];
        bgImageName = @"hibachi-BG.png";
    }
    
}
-(void)wheelDidChangeLink:(NSString *)newValue {
    self.helpLink = newValue;
}
- (void)wheelDidChangeComment:(NSString *)newValue {
    
//    // for links
////    FRHyperLabel *sectorComment = self.sectorComment;
//
//    //Step 1: Define a normal attributed string for non-link texts
//    NSLog(@"New Value: %@",newValue);
//    label1 = self.sectorComment;
//    label1.numberOfLines = 0;

    //Step 1: Define a normal attributed string for non-link texts
//    NSString *string1 = newValue;
//    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
//    label1.attributedText = [[NSAttributedString alloc]initWithString:string1 attributes:attributes];
//
////    //Step 2: Define a selection handler block
//    void(^handler1)(FRHyperLabel *label, NSString *substring) = ^(FRHyperLabel *label, NSString *substring){
//        UIAlertController *controller = [UIAlertController alertControllerWithTitle:substring message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:controller animated:YES completion:nil];
//    };
//
    //Step 3: Add link substrings
//    [label1 setLinksForSubstrings:@[@"to", @"and", @"in", @"of", @"are"] withLinkHandler:handler1];

    [self.sectorComment1 setText:newValue];

    [self.sectorComment1 setHidden:false];
}


- (void)wheelDidChangeIconName:(NSString *)newValue {
    self.sectorIcon.image = [UIImage imageNamed:newValue];
}

- (BOOL)isYelpInstalled {
    return [[UIApplication sharedApplication]
            canOpenURL:[NSURL URLWithString:@"yelp4://"]];
}

- (void)maybeDoSomethingWithYelp {
    // Call into the Yelp app
    if ([self isYelpInstalled]) {
        NSString *query = [NSString stringWithFormat:@"yelp:///search?term=%@", _sectorTitle.text];
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self showWebView:query];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query]];
    } else {
        // Use the Yelp touch site
        NSString *query = [NSString stringWithFormat:@"http://yelp.com/search?find_desc=%@", _sectorTitle.text];
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self showWebView:query];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query]];
    }
}
#pragma mark - UIWebView
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //Start the progressbar..
    [activityIndicatorView setHidden:false];
    [activityIndicatorView startAnimating];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Stop or remove progressbar
    [activityIndicatorView setHidden:true];
    [activityIndicatorView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [activityIndicatorView setHidden:true];
//    [activityIndicatorView stopAnimating];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"web loading failed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertView show];
//    [self.webView setHidden:true];
}

#pragma mark - UIGestureRecognizers

- (void)longPressLabel:(UITapGestureRecognizer *)gesture {
    if(![self.helpLink isEqualToString:@""]){
        if(wheelType == SEAFOOD_WHEEL || wheelType == BAKERY_WHEEL) return;
        [self showWebView:self.helpLink];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.helpLink]];        
    }
}
#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([ identifier isEqualToString: @"createNew"]) {
        if(![appDel loadInAppPuchage:kPuchage_Custom]){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SpinViewController *dest = [segue destinationViewController];
    if ([[segue identifier] isEqualToString: @"spanishWheel"]) {
        dest.wheelType = SPANISH_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"europeanWheel"]) {
        dest.wheelType = EUROPEAN_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"northWheel"]) {
        dest.wheelType = NORTH_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"asianWheel"]) {
        dest.wheelType = ASIAN_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"tropicalWheel"]) {
        dest.wheelType = TROPICAL_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"middleWheel"]) {
        dest.wheelType = MIDDLE_CULTURE_WHEEL;
    } else if([[segue identifier] isEqualToString: @"flavorWheel"]) {
        dest.wheelType = TEA_DRINK_WHEEL;
    }
}

- (void)insertResult {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    
    NSString *resultDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", resultDate);

//    FIRDatabaseReference *spinResultRef = [[[[FIRDatabase database] reference] child:[FIRAuth auth].currentUser.uid] child:@"spinResult"];
//    FIRDatabaseReference *resultItemRef = [spinResultRef child:resultDate];
//    [[resultItemRef child:@"title"] setValue:self.sectorTitle.text];
}

#pragma mark Social Integration
- (IBAction)TumblePressed:(id)sender {
    tmapiClient = [TMAPIClient sharedInstance];
    tmapiClient.OAuthConsumerKey = @"5fpsum8xG3hOb6FMu337J9bhDDTqjNzMsaqTD3Sx57QjA4EwFU";
    tmapiClient.OAuthConsumerSecret = @"Fq4OMq0cztvY7f7MfgjLdmslbghwQ7Cd3KRimzrbMGh9CHxjz2";
    tmapiClient.OAuthToken = @"3oI5kSXif80wlULlQzG1GgwU4im7aKduvPt7iuDBsetVTOrhUv";
    tmapiClient.OAuthTokenSecret = @"daOIzI2GCN4AgxY7W7gG6meH0y9x5N6qYVaG8wXACdFhgcLYj4";
    shareType = @"tumble";
    [tmapiClient userInfo:^ (id result, NSError *error) {
        if(error){
            NSLog(@"Tumblr get userinfo : %@", error);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Tweet composition canceled" message:nil delegate:
                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [self stopIndicator];
            return ;
        }
        
        NSLog(@"Tumblr get info : %@", result[@"user"][@"blogs"]);
        NSArray *tumblrBlogs = result[@"user"][@"blogs"];
        if(tumblrBlogs.count > 0){
            NSDictionary * dic = tumblrBlogs[0];
            TumblrBlogName = dic[@"name"];
        }
//        NSString *tmblrname = [tumblrBlogs objectForKey:@"name"];
        UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
        pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerLibrary.delegate = self;
        [self presentModalViewController:pickerLibrary animated:YES];
        [self startIndicator];
    }];
}
- (IBAction)FacebookPressed:(id)sender {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        if ([dialog canShow]) {
            [self _shareFacebookWithPhoto];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Permission denied" message:nil delegate:
                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            
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
                 [self.socialView setHidden:true];
             }
             else if (result.isCancelled)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                           @"Facebook login cancel!" message:nil delegate:
                                           self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [alertView show];
                 [self.socialView setHidden:true];
             }
             else
             {
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
                     if ([dialog canShow]) {
                         [self _shareFacebookWithPhoto];
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
- (IBAction)PinterestPressed:(id)sender {
    [self authenticateButtonTapped];
    
}
- (IBAction)TwitterPressed:(id)sender {
    shareType = @"twitter";
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    
    // Check if current session has users logged in
    if ([store hasLoggedInUsers]) {
        
        UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
        pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerLibrary.delegate = self;
        [self presentModalViewController:pickerLibrary animated:YES];
    } else {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                
                UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
                pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerLibrary.delegate = self;
                [self presentModalViewController:pickerLibrary animated:YES];
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"No Twitter Accounts Available" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
    
//    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
//    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    pickerLibrary.delegate = self;
//    [self presentModalViewController:pickerLibrary animated:YES];
    
    
}
- (IBAction)InstagramPressed:(id)sender {
    
   // UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
   //                           @"Not implemented!" message:nil delegate:
   //                           self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
   // [alertView show];
   // [self.socialView setHidden:true];
   // return;
    shareType = @"instagram";
    NSString* urlString = [kBaseURL stringByAppendingFormat:kAuthenticationURL,kClientID,kRedirectURI];
    NSLog(@"url=%@", urlString);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    [self.webView setHidden:false];
    [self.socialView setHidden:true];
//    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
//    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    pickerLibrary.delegate = self;
//    [self presentModalViewController:pickerLibrary animated:YES];
    
}
- (IBAction)CancelPressed:(id)sender {
    [self.socialView setHidden:true];
}


- (void)_shareFacebookWithPhoto
{
    shareType = @"facebook";
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerLibrary.delegate = self;
    [self presentModalViewController:pickerLibrary animated:YES];
    [self startIndicator];
//    [self.socialView setHidden:true];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage *myImage = image;
    if([bgImageName isEqualToString:@"vegetarian-bg.png"]){
        bgImageName = @"vegetarian-bg-social.png";
    }
    UIImage *backgroundimag = [UIImage imageNamed:bgImageName];
    UIImage *combinedImage = [self imageByCombiningImage:myImage withImage:backgroundimag];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self startIndicator];
    if([shareType isEqualToString:@"facebook"]){
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = combinedImage;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/wheelsofeats/"];
        
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
        [self stopIndicator];
        [self.socialView setHidden:true];
    }else if([shareType isEqualToString:@"tumble"]){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *docs = [paths objectAtIndex:0];
        NSString* path =  [docs stringByAppendingFormat:@"/test.png"];

        NSData* data = UIImagePNGRepresentation(combinedImage);
        if([data writeToFile:path atomically:YES]){
            [tmapiClient photo:TumblrBlogName
              filePathArray:@[path]
              contentTypeArray:@[@"image/png"]
                 fileNameArray:@[@"test.png"]
                    parameters:@{@"caption" : @"Wheel Of Eats"}
                      callback:^(id response, NSError *error) {
                          if (error){
                              NSLog(@"Error posting to Tumblr");
                              [self.socialView setHidden:true];
                              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                                        @"Error posting to Tumblr" message:nil delegate:
                                                        self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                              [alertView show];
                              [self stopIndicator];
                              [self.socialView setHidden:true];
                          }else{
                              NSLog(@"Posted to Tumblr");
                              [self.socialView setHidden:true];
                              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                                        @"Posted to Tumblr" message:nil delegate:
                                                        self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                              [alertView show];
                              [self stopIndicator];
                              [self.socialView setHidden:true];
                          }
                      }];
        }
    }else if([shareType isEqualToString:@"pinterest"]){
        int len = _PinterestBoards.count;
        PDKBoard *pdkBoard;
        if(len > 0) {
            pdkBoard = _PinterestBoards[len-1];
        }else{
            pdkBoard = [pdkBoard init];
        }
        
        [[PDKClient sharedInstance] createPinWithImage:combinedImage
                                                  link:[NSURL URLWithString:@"http://wheelofeats.com/"]
                                               onBoard:pdkBoard.identifier
                                           description:@"WheelOfEats"
                                              progress:^(CGFloat percentComplete) {
            
        } withSuccess:^(PDKResponseObject *responseObject) {
            if ([responseObject isValid]) {
                [self stopIndicator];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"Posted to Pinterest" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [self stopIndicator];
                [self.socialView setHidden:true];
                
            }
        } andFailure:^(NSError *error) {
            [self stopIndicator];
            [self.socialView setHidden:true];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Error posting to Pinterest" message:nil delegate:
                                      self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [self stopIndicator];
            [self.socialView setHidden:true];
            
        }];
    }else if([shareType isEqualToString:@"instagram"]){
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            // See the sample to set the image path and add caption
            // OPEN THE HOOK
//            [self.docFile presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
        }
        else
        {
            // show the message that Instagram is not installed on this device
        }
        [self stopIndicator];
        [self.socialView setHidden:true];
    }else if([shareType isEqualToString:@"twitter"]){
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:@"Wheel Of Eats!"];
        
        [mySLComposerSheet addImage:combinedImage];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            if(result == SLComposeViewControllerResultCancelled){
                NSLog(@"Post Canceled");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"Post Canceled" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [self stopIndicator];
            }else {
                NSLog(@"Post Done!");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                          @"Post Sucessful" message:nil delegate:
                                          self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [self stopIndicator];
                
            }
            [self.socialView setHidden:true];
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];

    }
}
- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    
    UIImage *image = nil;
    UIImage *shareTitle = [UIImage imageNamed:@"sharetitle.png"];
    //    UIFont *font = [UIFont boldSystemFontOfSize:50];GillSans
//    UIFont *font = [UIFont fontWithName:@"Autumn in November" size:30];//AutumninNovember
    UIFont *font = [UIFont fontWithName:@"GillSans" size:34];//AutumninNovember
    NSString *imbedTXT = [NSString stringWithFormat:@"When You Landed on %@", spinTitle];
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width/2, secondImage.size.width), MAX(firstImage.size.height/2, secondImage.size.height));
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
        UIGraphicsBeginImageContext(newImageSize);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    [firstImage drawInRect:CGRectMake(0,0,newImageSize.width,newImageSize.height)];
    
    // Apply supplied opacity if applicable
    [secondImage drawInRect:CGRectMake(0,0,newImageSize.width,newImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [shareTitle drawInRect:CGRectMake(20,20, shareTitle.size.width, shareTitle.size.height)];
    
    CGRect rect = CGRectMake(newImageSize.width-10 - (imbedTXT.length * 20), newImageSize.height-80, newImageSize.width, newImageSize.height);
    [[UIColor whiteColor] set];
    [imbedTXT drawInRect:CGRectIntegral(rect) withFont:font];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)authenticateButtonTapped
{
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                          PDKClientWritePublicPermissions,
                                                          PDKClientReadRelationshipsPermissions,
                                                          PDKClientWriteRelationshipsPermissions]
                                     fromViewController:self
                                            withSuccess:^(PDKResponseObject *responseObject)
     {
         [[PDKClient sharedInstance] getAuthenticatedUserBoardsWithFields:[NSSet setWithArray:@[@"id", @"image", @"description", @"name", @"privacy"]]
                                                                  success:^(PDKResponseObject *responseObject) {
                                                                      _PinterestBoards = [responseObject boards];
                                                                      shareType = @"pinterest";
                                                                      UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
                                                                      pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                      pickerLibrary.delegate = self;
                                                                      [self presentModalViewController:pickerLibrary animated:YES];
                                                                      [self startIndicator];
                                                                  } andFailure:nil];
         
     } andFailure:^(NSError *error) {
         
     }];
}
#pragma mark - Image process
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
////        [PHAssetChangeRequest creationRequestForAssetFromImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
//        
//    } completionHandler:^(BOOL success, NSError *error) {
//        if (success) {
//            NSLog(@"Success");
//        }
//        else {
//            NSLog(@"write error : %@",error);
//        }
//    }];
//    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
//}
-(void)startIndicator{
    [self.view setUserInteractionEnabled:NO];
    [activityIndicatorView startAnimating];
    [activityIndicatorView setHidden:false];
}
-(void)stopIndicator{
    [self.view setUserInteractionEnabled:YES];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:true];
}


#pragma mark - TumblrDelegate


#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
    [self stopIndicator];
    [self.socialView setHidden:true];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self stopIndicator];
    [self.socialView setHidden:true];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
    [self stopIndicator];
    [self.socialView setHidden:true];
}
@end
