//
//  FoodViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "FoodViewController.h"
#import "SpinViewController.h"
#import "MyWheelViewController.h"
#import "UnlockViewController.h"
#import "AppDelegate.h"
#import "Global.h"

@interface FoodViewController ()
@property (weak, nonatomic) IBOutlet UIButton *styleButton;
@property (weak, nonatomic) IBOutlet UIButton *cultureButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;

@end
Global *globalData;

@implementation FoodViewController{
    AppDelegate* appDel;
}
CLLocationManager *locationManager;
CLGeocoder *geocoder;
int locationFetchCounter;
NSString *city;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = [UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    geocoder = [[CLGeocoder alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self setSwipeFunction];
}
-(void)viewWillAppear:(BOOL)animated
{    
    [self lockItem];
//    [self checkPurchaged];
    if([self checkPurchageState]){
                [self.customButton addTarget:self action:@selector(goToMyWheel:) forControlEvents:UIControlEventTouchUpInside];
        
            }else{
                [self.customButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
                
            }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(Boolean)checkPurchageState{
    return [appDel loadInAppPuchage:kPuchage_Custom];
}

-(void)setSwipeFunction {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
}
- (IBAction)tappedRightButton:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
    
    //To animate use this code
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:0.2f];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                             kCAMediaTimingFunctionEaseIn]];
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
}
//-(void)checkInAppPurcharged {
////    [self.customButton setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
//    [self.customButton setBackgroundColor:[UIColor whiteColor]];
//    [self.customButton setAlpha:0.7f];
//    self.customButton.layer.cornerRadius = self.customButton.layer.frame.size.height/2;
//}
//
//-(void)checkPurchaged{
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicatorView.center = self.view.center;
//    [self.view addSubview:activityIndicatorView];
//    [activityIndicatorView startAnimating];
//    [activityIndicatorView setAlpha:1];
//    [activityIndicatorView hidesWhenStopped];
//    [self fetchAvailableProducts];
//}
//-(void)fetchAvailableProducts {
//    NSSet *productIdentifier = [NSSet setWithObjects:kPuchage_Custom,kPuchage_Seafood, kPuchage_Bakery, kPuchage_Vegetarian, kPuchage_Wine, kPuchage_Beer, nil];
//    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifier];
//    productsRequest.delegate = self;
//    [productsRequest start];
//}
-(void)lockItem {
    if([self checkPurchageState]) return;
    [self.customButton setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    [self.customButton setBackgroundColor:[UIColor whiteColor]];
    [self.customButton setAlpha:0.7f];
    self.customButton.layer.cornerRadius = self.customButton.layer.frame.size.height/2;
    
}
-(void)goToUnlock:(UIButton *)sender{
    UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
    
    UINavigationController *navigationController =  [[UINavigationController alloc] initWithRootViewController:unlock];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)goToMyWheel:(UIButton *)sender{
    MyWheelViewController *myWheel = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyWheelViewController"];
    
    myWheel.modeCustom = CUSTOM_SPIN_INDEX;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:myWheel];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}


#pragma mark - Location delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // this delegate method is constantly invoked every some miliseconds.
    // we only need to receive the first response, so we skip the others.
    if (locationFetchCounter > 0) return;
    locationFetchCounter++;
    
    // after we have current coordinates, we use this method to fetch the information data of fetched coordinate
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        
//                NSString *street = placemark.thoroughfare;
        NSString *city = placemark.locality;
        [Global getInstance].myCity = city;
        CLLocationCoordinate2D location;
        location.latitude = placemark.location.coordinate.latitude;
        location.longitude = placemark.location.coordinate.longitude;
        [Global getInstance].myLocation = location;
//        globalData.myCity = city;
//        [appDel savemyLocation: city];
//                NSString *posCode = placemark.postalCode;
//                NSString *country = placemark.country;
        
        
        // stopping locationManager from fetching again
        [locationManager stopUpdatingLocation];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
}
//#pragma mark StoreKit Delegate


//-(void)productsRequest:(SKProductsRequest *)request
//    didReceiveResponse:(SKProductsResponse *)response
//{
//    SKProduct *validProduct = nil;
//    int count = [response.products count];
//    if (count>0) {
//        
//        Global.getInstance.IAP_BEER = true;
//        Global.getInstance.IAP_WINE = true;
//        Global.getInstance.IAP_SEAFOOD = true;
//        Global.getInstance.IAP_BAKERY = true;
//        Global.getInstance.IAP_CUSTOM = true;
//        Global.getInstance.IAP_VEGETARIAN = true;
//        for(int i = 0; i < count; i++){
//            validProduct = [response.products objectAtIndex:i];
//            if ([validProduct.productIdentifier
//                 isEqualToString:kPuchage_Beer]) {
//                Global.getInstance.IAP_BEER = false;
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Wine]) {
//                Global.getInstance.IAP_WINE = false;
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Seafood]) {
//                Global.getInstance.IAP_SEAFOOD = false;
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Bakery]) {
//                Global.getInstance.IAP_BAKERY = false;
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Custom]) {
//                Global.getInstance.IAP_CUSTOM = false;
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Vegetarian]) {
//                Global.getInstance.IAP_VEGETARIAN = false;
//            }
//        }
//    } else {
//        Global.getInstance.IAP_BEER = true;
//        Global.getInstance.IAP_WINE = true;
//        Global.getInstance.IAP_SEAFOOD = true;
//        Global.getInstance.IAP_BAKERY = true;
//        Global.getInstance.IAP_CUSTOM = true;
//        Global.getInstance.IAP_VEGETARIAN = true;
//    }
//    [activityIndicatorView stopAnimating];
//    [self lockItem];
//    if(Global.getInstance.IAP_CUSTOM){
//        [self.customButton addTarget:self action:@selector(goToMyWheel:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }else{
//        [self.customButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Identifier: %@", segue.identifier);

    SpinViewController *dest = [segue destinationViewController];
    NSLog(@"Identifier: %@", segue.identifier);
    if ([[segue identifier] isEqualToString: @"styleWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = STYLE_FOOD_WHEEL;
    } else if([[segue identifier] isEqualToString: @"cultureWheel"]) {
         NSLog(@"BO: %d",CULTURE_FOOD_WHEEL);
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = CULTURE_FOOD_WHEEL;
    } else if([[segue identifier] isEqualToString: @"customWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = CUSTOM_FOOD_WHEEL;
    }else if([[segue identifier] isEqualToString: @"atCustom"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        MyWheelViewController *spin = (MyWheelViewController *)nav.topViewController;
        spin.modeCustom = CUSTOM_SPIN_INDEX;
    }
}

@end
