//
//  AroundViewController.m
//  WheelOfEats
//
//  Created by panda on 21/11/2017.
//

#import "AroundViewController.h"
#import "CustomAnnotation.h"
#import "AppDelegate.h"
#import "UnlockViewController.h"
#import "WheelEditViewController.h"
#import "Global.h"
#import <MapKit/MapKit.h>

@interface AroundViewController ()
@property (weak, nonatomic) IBOutlet UIView *wheelView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UISlider *slider_restaurant;
@property (weak, nonatomic) IBOutlet UISlider *slider_mile;
@property (weak, nonatomic) IBOutlet UIButton *btt_vegetarian;
@property (weak, nonatomic) IBOutlet UIButton *btt_fastfood;
@property (weak, nonatomic) IBOutlet UIButton *btt_vegan;
@property (weak, nonatomic) IBOutlet UIButton *btt_seafood;
@property (weak, nonatomic) IBOutlet UIButton *btt_breakfast;
@property (weak, nonatomic) IBOutlet UIButton *btt_bbq;
@property (weak, nonatomic) IBOutlet UIButton *btt_casual;
@property (weak, nonatomic) IBOutlet UIButton *btt_fullbar;
@property (weak, nonatomic) IBOutlet UIButton *btt_refine;
@property (weak, nonatomic) IBOutlet UIView *refineView;
@property (weak, nonatomic) IBOutlet UIView *LoadingView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
BOOL isShowRefineView;
NSMutableArray *selectedSpecs;
NSMutableArray *sector;
UIImageView *bg;
NSString *bgImageName, *spinTitle;
WOECustomRotaryWheel *wheel;
int searchRadius, searchCount, tmpCount;
UIActivityIndicatorView *activityIndicatorView;

@implementation AroundViewController{    
    AppDelegate * appDel;
}

- (void)viewDidLoad {
    appDel = [UIApplication sharedApplication].delegate;
    [super viewDidLoad];
    isShowRefineView = YES;
    _mapView.delegate = self;
    searchCount = 8;
    searchRadius = 20;
    [self setInitSpecs];
    [self setInitViews];
    [self getRestaurantList];
    // Do any additional setup after loading the view.
}
-(void)setInitViews{
    bgImageName = @"style_wheel_back.png";
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.wheelView.bounds.size.height)];
    bg.image = [UIImage imageNamed:bgImageName];
    [self.wheelView addSubview:bg];
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options: nil
                     animations:^
     {
         CGFloat height = self.view.frame.size.height;
         CGRect frame = _refineView.frame;
         frame.origin.y = height-33;
         frame.origin.x = 0;
         _refineView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         [_refineView bringSubviewToFront:self.view];
         isShowRefineView = NO;
         [_btt_refine setImage:[UIImage imageNamed:@"ico2"] forState:UIControlStateNormal];
     }];
    [_slider_restaurant addTarget:self action:@selector(restaurantValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider_mile addTarget:self action:@selector(mileValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.view.center;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [activityIndicatorView setAlpha:1];
    [activityIndicatorView hidesWhenStopped];
}

- (IBAction)restaurantValueChanged:(UISlider *)sender {
    searchCount = sender.value;
//                 [self getRestaurantList];
}
- (IBAction)mileValueChanged:(UISlider *)sender {
    searchRadius = sender.value;
}
-(void)changeWheel:(NSMutableArray *)sector{
    if(wheel != nil){
        [wheel removeFromSuperview];
//        wheel = nil;
    }
    NSMutableDictionary *wheeldata = [[NSMutableDictionary alloc]init];
    [wheeldata setObject:sector forKey:@"around"];
    wheel = [[WOECustomRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 250, 250) andDelegate:self title:@"aroundme123!@#" withData:wheeldata];
    wheel.center = CGPointMake(self.view.bounds.size.width / 2, self.wheelView.bounds.size.height / 2);
    [self.wheelView addSubview:wheel];
    
}
- (void)setInitSpecs{
    selectedSpecs = [[NSMutableArray alloc] init];
    for(int i = 0; i < 8; i++){
        [selectedSpecs addObject:@"sel"];
    }
}
- (void)getRestaurantList{
    searchCount = _slider_restaurant.value;
    searchRadius = _slider_mile.value;
    _mapView.showsUserLocation = YES;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;//1 / searchRadius;
    span.longitudeDelta = 0.05;//1 / searchRadius;
    CLLocationCoordinate2D location;
    location.latitude = [Global getInstance].myLocation.latitude;
    location.longitude = [Global getInstance].myLocation.longitude;
    region.span = span;
    region.center = location;
    [_mapView setRegion:region animated:YES];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurant";
//    request.region = _mapView.region;
    request.region = MKCoordinateRegionMakeWithDistance(location, searchRadius * 1609, searchRadius * 1609);
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSMutableArray *annotations = [[NSMutableArray array] init];
        sector = [[NSMutableArray alloc] init];
        tmpCount = 0;
        [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *item, NSUInteger idx, BOOL *stop) {
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithPlacemark:item.placemark];
            
            annotation.title = item.name;
            NSLog(@"restaurant name = %@", item.name);
//            annotation.subtitle = item.placemark.addressDictionary[(NSString *)kABPersonAddressStreetKey];
//            annotation.phone = item.phoneNumber;
            tmpCount++;
            if(tmpCount <= searchCount){
                [sector addObject:item.name];
                [annotations addObject:annotation];
            }
        }];
        
        [self.mapView addAnnotations:annotations];
        [self changeWheel:sector];
        [_LoadingView setHidden:YES];
        [activityIndicatorView stopAnimating];
    }];
    
}
- (IBAction)researchFunction:(id)sender {
    [activityIndicatorView startAnimating];
    [self getRestaurantList];
}

- (void)wheelDidChangeSector:(int)position {
    _lb_title.text = sector[position];
}

- (void)wheelDidChangeTitle:(NSString *)newValue {
}
- (void)wheelDidChangeComment:(NSString *)newValue {
}
- (void)wheelDidChangeLink:(NSString *)newValue {
}
- (void)wheelDidChangeIconName:(NSString *)newValue {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    if(self.webView.isHidden){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.webView setHidden:YES];
    }
}
- (IBAction)createClick:(id)sender {
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
- (IBAction)yelpClick:(id)sender {
    NSString *myCity = [Global getInstance].myCity;
    
    NSString *query = [NSString stringWithFormat:@"http://yelp.com/search?find_desc=%@&find_loc=%@", _lb_title.text, myCity];
    NSLog(@"query = %@", query);
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self showWebView:query];
}

-(void)showWebView:(NSString *)link {
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    [self.webView setHidden:false];
}
- (IBAction)refineClick:(id)sender {
    CGFloat height = self.view.frame.size.height;
    if(!isShowRefineView){
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: nil
                         animations:^
         {
             CGRect frame = _refineView.frame;
             frame.origin.y = height-400;
             frame.origin.x = 0;
             _refineView.frame = frame;
         }
         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             [_refineView bringSubviewToFront:self.view];
             isShowRefineView = YES;
             [_btt_refine setImage:[UIImage imageNamed:@"ico1"] forState:UIControlStateNormal];
         }];
    }else{
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: nil
                         animations:^
         {
             CGRect frame = _refineView.frame;
             frame.origin.y = height-33;
             frame.origin.x = 0;
             _refineView.frame = frame;
         }
         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             [_refineView bringSubviewToFront:self.view];
             isShowRefineView = NO;
             [_btt_refine setImage:[UIImage imageNamed:@"ico2"] forState:UIControlStateNormal];
         }];
    }
}

- (IBAction)clickSpecs:(id)sender {
    UIButton *button = sender;
    int tag = button.tag;
    if([selectedSpecs[tag] isEqualToString:@"sel"]){
        [button setImage:[UIImage imageNamed:@"unsel"] forState:UIControlStateNormal];
        selectedSpecs[tag] = @"unsel";
    }else{
        [button setImage:[UIImage imageNamed:@"sel"] forState:UIControlStateNormal];
        selectedSpecs[tag] = @"sel";
        
    }
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
