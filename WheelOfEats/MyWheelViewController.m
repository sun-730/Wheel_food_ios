//
//  MyWheelViewController.m
//  WheelOfEats
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "MyWheelViewController.h"
#import "WheelEditViewController.h"
#import "CustomSpinViewController.h"
#import "WOECustomWheel.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SharingData.h"
#import "Global.h"
#import "UnlockViewController.h"
@import Firebase;

@interface MyWheelViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISwitch *editableSwitch;
@property (weak, nonatomic) IBOutlet UILabel *editStatus;
@property (weak, nonatomic) IBOutlet UIButton *creatButton;

@property (strong, nonatomic) FIRDatabaseReference *wheelRef;
@end

NSString *currentTitle;

SharingData *sharingData;

@implementation MyWheelViewController{
    AppDelegate* appDel;
}



@synthesize data,data1,allData;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 [self getYelpAccessToken];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSError *error;
    appDel = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wheel" inManagedObjectContext:appDel.managedObjectContextModify];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSArray *fetchedObject = [appDel.managedObjectContextModify executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched Object:");
    NSString *wheelTitle = NULL;
    allData=[[NSMutableDictionary alloc]init];
    NSDictionary *wheelData;
    int i = 0;
    int listWheelWidth = _contentView.bounds.size.width / 3;
    int listWheelHeight = listWheelWidth;
    for(UIView *usview in self.contentView.subviews){
        [usview removeFromSuperview];
    }
    for (NSManagedObject *obj in fetchedObject) {
        
        
        NSArray *keys = [[[obj entity] attributesByName] allKeys];
        wheelData = [obj dictionaryWithValuesForKeys:keys];
        data=[wheelData mutableCopy];
        wheelTitle = data[@"wheelTitle"];
        
        [data removeObjectForKey:@"wheelTitle"];
        [allData setObject:data forKey:wheelTitle];
        WOECustomWheel *wheel = [[WOECustomWheel alloc] initWithFrame:CGRectMake(0, 0, listWheelWidth - 20, listWheelHeight - 20) andDelegate:self title:wheelTitle withData: data];
        wheel.center = CGPointMake(listWheelWidth / 2 + (i % 3) * listWheelWidth, 30 + listWheelHeight / 2 + (int)(i / 3) * (listWheelHeight + 30));
        // 4 - Add wheel to view
        [self.contentView addSubview:wheel];
        wheel.layer.shadowColor = [UIColor grayColor].CGColor;
        wheel.layer.shadowOffset = CGSizeMake(1, 3);
        wheel.layer.shadowOpacity = 0.5;
        wheel.layer.shadowRadius = 1.0;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((i % 3) * listWheelWidth, 30 + listWheelHeight + (int)(i / 3) * (listWheelHeight + 30), listWheelWidth, 20)];
        [titleLabel setNumberOfLines:0];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:wheelTitle];
        [self.contentView addSubview:titleLabel];
        
        i++;
        
        
    }
    [self checkInAppPurchaged];

}
-(void)checkInAppPurchaged {
    if(![appDel loadInAppPuchage:kPuchage_Custom]){
        [self.creatButton addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.creatButton addTarget:self action:@selector(goToWheelEdit:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)goToUnlock:(UIButton *)sender{
    UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:unlock];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)goToWheelEdit:(UIButton *)sender{
    
    WheelEditViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WheelEditViewController"];
    
    UINavigationController *navigationController =  [[UINavigationController alloc] initWithRootViewController:unlock];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)getYelpAccessToken{
    sharingData = [SharingData getInstance];
    sharingData.YELP_API_SEARCH_URL = @"https://api.yelp.com/v3/businesses/search";
    sharingData.YELP_API_AUTH_URL = @"https://api.yelp.com/oauth2/token";
    sharingData.CLIENT_ID = @"t2Db0L9r0dqwEIbtZgDHPQ";
    sharingData.CLIENT_SECRET = @"vm9VOGxD2vqESR0dWOAVCVoHOJwr2yhlcKnWst0Zti9ezsBQ0WGyzv5dEaWH8OZV";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"grant_type": @"client_credentials",
                             @"client_id": sharingData.CLIENT_ID,
                             @"client_secret": sharingData.CLIENT_SECRET};
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editStatusChanged:(id)sender {
    if (_editableSwitch.isOn) {
        _editStatus.text = @"ENABLE";
    }
    else {
        _editStatus.text = @"DISABLE";
    }
}

- (void)wheelDidTouched:(NSString *)title {
    currentTitle = title;
    NSLog(@"Here %@ delegate", title);
    
    if (_editableSwitch.isOn) {
        WheelEditViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WheelEditViewController"];
        custom.title = currentTitle;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:custom];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else {
        
        CustomSpinViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomSpinViewController"];
        
        custom.title = currentTitle;
        custom.wheelData = allData[currentTitle];
        [self presentViewController:custom animated:YES completion:nil];
    }

}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *dest = [segue destinationViewController];
    if([[sender title] isEqualToString:@"Back"]){
//        [self popoverPresentationController];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([[segue identifier] isEqualToString: @"wheelEdit"]) {
        ((WheelEditViewController *)dest).title = currentTitle;
    } else if([[segue identifier] isEqualToString: @"wheelView"]) {
        ((CustomSpinViewController *)dest).modeCustom = self.modeCustom;
        ((CustomSpinViewController *)dest).title = currentTitle;
        ((CustomSpinViewController *)dest).wheelData = allData[currentTitle];
    } else if([[segue identifier] isEqualToString:@"CreateWheel"]){
        
    }else if ([[segue identifier] isEqualToString: @"EditWheel"]) {
//        ((WheelEditViewController *)dest).title = currentTitle;
    }
}


@end
