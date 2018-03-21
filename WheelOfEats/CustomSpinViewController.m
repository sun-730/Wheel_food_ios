//
//  CustomSpinViewController.m
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "CustomSpinViewController.h"
#import "MyWheelViewController.h"
#import "WheelEditViewController.h"
#import "CustomSpinViewController.h"
#import "WOECustomWheel.h"
#import "SharingData.h"
#import "AppDelegate.h"
#import "Global.h"
@import GoogleMobileAds;
@import Firebase;
//#import <CoreLocation/CoreLocation.h>

@interface CustomSpinViewController ()
@property (weak, nonatomic) IBOutlet UIView *wheelView;
@property (weak, nonatomic) IBOutlet UILabel *sectorTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sectorIcon;
@property (weak, nonatomic) IBOutlet UIButton *createNewButton;
@property (weak, nonatomic) IBOutlet UIButton *openInYelpButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *difaultComment;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end


//CLLocationManager *locationManager;
//float latitude;
//float longitude;


@implementation CustomSpinViewController{
    AppDelegate* appDel;
}
@synthesize title, wheelData;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self.openInYelpButton addTarget:self action:@selector(openInYelpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.wheelView.bounds.size.height)];
    bg.image = [UIImage imageNamed:@"style_wheel_back.png"];
    [self.wheelView addSubview:bg];
    // 3 - Set up rotary wheel
    WOECustomRotaryWheel *wheel = [[WOECustomRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 250, 250) andDelegate:self title:self.title withData:wheelData];
    wheel.center = CGPointMake(self.view.bounds.size.width / 2, self.wheelView.bounds.size.height / 2);
    // 4 - Add wheel to view
    [self.wheelView addSubview:wheel];
    
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
    [self.webView addSubview:activityIndicatorView];
    [activityIndicatorView setHidden:true];
    
    
    //GeoLocation
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    [locationManager startUpdatingLocation];
//    
//    latitude = locationManager.location.coordinate.latitude;
//    longitude = locationManager.location.coordinate.longitude;
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openInYelpButtonPressed {
    [self maybeDoSomethingWithYelp];
    [self insertResult];
}
- (void)deleteButtonPressed{
    
    appDel = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wheel" inManagedObjectContext:appDel.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
        
        NSManagedObject *obj  =result[0];
        [appDel.managedObjectContext deleteObject:obj];
    
    // Save the object to persistent store
    if (![appDel.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUI {
    [self.titleLabel setTitle:title];
    [self.sectorTitle setHidden:true];
    if(self.modeCustom != 20){
        UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 375, 60)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(backButtonPressed:)];
        UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:title];
        navigItem.leftBarButtonItem = backItem;
        //do something like background color, title, etc you self
        [self.view addSubview:navbar];
        navbar.items = [NSArray arrayWithObjects: navigItem,nil];
//        [self.lblTitle setHidden:true];
//        [self.backButton setHidden:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)wheelDidChangeTitle:(NSString *)newValue {
    [self.sectorTitle setHidden:false];
    self.sectorTitle.text = newValue;
    NSString *comment = self.wheelData[@"wheeldescription"];
    [self.difaultComment setHidden:false];
    self.difaultComment.text = comment;
//    [self.sectorTitle setHidden:false];
//    [self.edtcomment setHidden:false];
//    [self.edtcomment setEditable:true];
}

- (void)wheelDidChangeLink:(NSString *)newValue {
}
- (void)wheelDidChangeComment:(NSString *)newValue {
//    self.sectorComment.text = newValue;
//    [self.sectorComment setHidden:false];
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
    NSString *myCity = [Global getInstance].myCity;
    
    NSString *query = [NSString stringWithFormat:@"http://yelp.com/search?find_desc=%@&find_loc=%@", _sectorTitle.text, myCity];
//    NSString *query = [NSString stringWithFormat:@"http://yelp.com/search?find_desc=%@", _sectorTitle.text];
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self showWebView:query];
    return;
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


-(void)showWebView:(NSString *)link {
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.webView setHidden:false];
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

@end
