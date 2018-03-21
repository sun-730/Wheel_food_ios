//
//  DrinkViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "DrinkViewController.h"
#import "SpinViewController.h"
#import "Global.h"
#import "UnlockViewController.h"
#import "AppDelegate.h"

@import GoogleMobileAds;
@import Firebase;


@interface DrinkViewController ()
@property (weak, nonatomic) IBOutlet UIButton *liquorButton;
@property (weak, nonatomic) IBOutlet UIButton *beerButton;
@property (weak, nonatomic) IBOutlet UIButton *teaButton;
@property (weak, nonatomic) IBOutlet UIButton *wineButton;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation DrinkViewController{
    AppDelegate* appDel;
}

@synthesize fromRestaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = [UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    if(self.fromRestaurant == 10){
        [self setADView];
    }else{
        //        [self.bannerView setHidden:true];
    }
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    [self setSwipeFunction];
}
-(void)viewWillAppear:(BOOL)animated{
    [self checkInAppPurchaged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSwipeFunction {
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}
- (IBAction)tappedLeftButton:(id)sender
{
    [self.tabBarController setSelectedIndex:0];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromLeft];
    
    [anim setDuration:0.5f];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                             kCAMediaTimingFunctionEaseIn]];
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
}
-(void)setADView{
    [self.bannerView setHidden:false];
    //AdMob view
    [self.bannerView sizeToFit];
    self.bannerView.adUnitID = @"ca-app-pub-1972998462639092/8780093952";
    //    self.bannerView.layer.frame.origin.y -=100.0f;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:request];
    
}
-(void)checkInAppPurchaged {
    self.beerButton.tag = 333;
    self.wineButton.tag = 334;
    self.wineButton.tag = 334;
    self.wineButton.tag = 334;
    if(![appDel loadInAppPuchage:kPuchage_Beer]){
        [self.beerButton setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [self.beerButton setBackgroundColor:[UIColor whiteColor]];
        [self.beerButton setAlpha:0.7f];
        self.beerButton.layer.cornerRadius = self.beerButton.layer.frame.size.height/2;
        [self.beerButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.beerButton removeTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.beerButton addTarget:self action:@selector(goToSpin:) forControlEvents:UIControlEventTouchUpInside];
        [self.beerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.beerButton setBackgroundColor:[UIColor clearColor]];
        [self.beerButton setAlpha:1.0f];
    }
    if(![appDel loadInAppPuchage:kPuchage_Wine]){
        [self.wineButton setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [self.wineButton setBackgroundColor:[UIColor whiteColor]];
        [self.wineButton setAlpha:0.7f];
        self.wineButton.layer.cornerRadius = self.wineButton.layer.frame.size.height/2;
        [self.wineButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.wineButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.wineButton removeTarget:self action:@selector(goToSpin:) forControlEvents:UIControlEventTouchUpInside];
        [self.wineButton addTarget:self action:@selector(goToSpin:) forControlEvents:UIControlEventTouchUpInside];
        [self.wineButton setBackgroundColor:[UIColor clearColor]];
        [self.wineButton setAlpha:1.0f];
    }

}
- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goToUnlock:(UIButton *)sender{
    
    UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
    UINavigationController *navigationController =  [[UINavigationController alloc] initWithRootViewController:unlock];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)goToSpin:(UIButton *)sender{
    SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
    if(sender.tag == 333){
        spin.wheelType = BEER_DRINK_WHEEL;
    }else if(sender.tag == 334){
        spin.wheelType = WINE_DRINK_WHEEL;
    }
    UINavigationController *navigationController =  [[UINavigationController alloc] initWithRootViewController:spin];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    SpinViewController *dest = [segue destinationViewController];
    if ([[segue identifier] isEqualToString: @"liquorWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = LIQUOR_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"beerWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = BEER_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"teaWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = TEA_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"wineWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = WINE_DRINK_WHEEL;
    }
}

@end
