//
//  HomeViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "HomeViewController.h"
#import "SharingData.h"
@import GoogleMobileAds;

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //AdMob view
    [self.bannerView sizeToFit];
    self.bannerView.adUnitID = @"ca-app-pub-1972998462639092/8780093952";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:request];
    
    //GeoLocation
    //Initializing SharingData fields and Getting Yelp Access Token
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

@end
