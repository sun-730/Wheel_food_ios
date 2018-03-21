//
//  RestaurantViewController.m
//  WheelOfEats
//
//  Created by admin on 11/08/2017.
//
//

#import "RestaurantViewController.h"
#import "SpinViewController.h"
#import "DrinkViewController.h"
#import "Global.h"
#import "AppDelegate.h"
#import "UnlockViewController.h"
@import GoogleMobileAds;
@import Firebase;


@interface RestaurantViewController ()
@property (weak, nonatomic) IBOutlet UITableView *RestaurantTable;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end

@implementation RestaurantViewController
{
    AppDelegate* appDel;
    NSArray *RestaurantNameData, *RestaurantImageData, *RestaurantLabelData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = [UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    RestaurantNameData = [NSArray arrayWithObjects:@"DRINKS", @"MEAT", @"FLAVORS", @"VEGETARIAN", @"SEAFOOD", @"BAKERY",@"CHEESE", nil];
    RestaurantImageData = [NSArray arrayWithObjects: @"drink_BTN.png", @"meat_BTN.png", @"flavors_BTN.png", @"vegetarian_BTN.png", @"seafood_BTN.png", @"bakery_BTN.png",@"cheese_BTN.png", nil];
    RestaurantLabelData = [NSArray arrayWithObjects:@"PICK MY", @"PICK MY", @"PICK MY", @"I'M A", @"I WANT", @"AT A", @"PICK MY", nil];
//    RestaurantNameData = [NSArray arrayWithObjects:@"SEAFOOD", @"MEAT", @"DRINKS", @"VEGETARIAN", nil];
//    RestaurantImageData = [NSArray arrayWithObjects:@"seafood_BTN.png", @"meat_BTN.png", @"drink_BTN.png", @"vegetarian_BTN.png", nil];
//    RestaurantLabelData = [NSArray arrayWithObjects:@"I WANT", @"PICK MY", @"PICK MY", @"I'M A", nil];
    [self setADView];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)goToSpin:(UIButton*)sender{
    int index = sender.tag;
    NSString *name = [RestaurantNameData objectAtIndex:index];
    if([name isEqualToString:@"SEAFOOD"]){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = SEAFOOD_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
    }else if([name isEqualToString:@"MEAT"]){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = MEAT_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
        
    }else if([name isEqualToString:@"VEGETARIAN"]){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = VEGETARIAN_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
        
    }else if([name isEqualToString:@"FLAVORS"]){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = FLAVORS_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
        
    }else if([name isEqualToString:@"BAKERY"]){
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = BAKERY_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
        
    }else if([name isEqualToString:@"DRINKS"]){
        DrinkViewController *drink = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DrinkViewController"];
        drink.fromRestaurant = 10;
        
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:drink animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:drink];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
    }else if([name isEqualToString:@"FLAVORS"]){
        
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = FLAVORS_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
    }else if([name isEqualToString:@"CHEESE"]){
        
        SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
        spin.wheelType = CHEESE_WHEEL;
        if ([self presentedViewController]) {
            [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:spin animated:YES completion:nil];
                });
            }];
        } else {
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:spin];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }
    }
    
}

-(void)goToUnlock:(UIButton *)sender{
    UnlockViewController *unlock = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UnlockViewController"];
    
    UINavigationController *navigationController =  [[UINavigationController alloc] initWithRootViewController:unlock];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 360;
    }
    else
    {
        return 180;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 360;
    }
    else
    {
        return 180;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = (int)((RestaurantNameData.count + 1) / 2);
    return num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index1 = indexPath.row * 2;
    int index2 = indexPath.row * 2 + 1;
    UITableViewCell *Cell = [self.RestaurantTable dequeueReusableCellWithIdentifier:@"cell"];
    UIImageView *img1 = (UIImageView *)[Cell viewWithTag:101];
    UIImageView *img2 = (UIImageView *)[Cell viewWithTag:201];
    
    UILabel *lbl11 = (UILabel *)[Cell viewWithTag:102];
    UILabel *lbl12 = (UILabel *)[Cell viewWithTag:103];
    UILabel *lbl21 = (UILabel *)[Cell viewWithTag:202];
    UILabel *lbl22 = (UILabel *)[Cell viewWithTag:203];
    
    UIButton *btt1 = (UIButton *)[Cell viewWithTag:104];
    UIButton *btt2 = (UIButton *)[Cell viewWithTag:204];
    
    [img1 setImage:[UIImage imageNamed:[RestaurantImageData objectAtIndex:index1]]];
    [lbl11 setText:[RestaurantLabelData objectAtIndex:index1]];
    [lbl12 setText:[RestaurantNameData objectAtIndex:index1]];
    [btt1 setTag:index1];
    if((![appDel loadInAppPuchage:kPuchage_Seafood]) && ([[RestaurantNameData objectAtIndex:index1] isEqualToString:@"SEAFOOD"])){
        [btt1 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt1 setBackgroundColor:[UIColor whiteColor]];
        [btt1 setAlpha:0.5f];
        btt1.layer.cornerRadius = btt1.layer.frame.size.height/2;
        [btt1 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Vegetarian]) && ([[RestaurantNameData objectAtIndex:index1] isEqualToString:@"VEGETARIAN"])){
        [btt1 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt1 setBackgroundColor:[UIColor whiteColor]];
        [btt1 setAlpha:0.5f];
        btt1.layer.cornerRadius = btt1.layer.frame.size.height/2;
        [btt1 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Bakery]) && ([[RestaurantNameData objectAtIndex:index1] isEqualToString:@"BAKERY"])){
        [btt1 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt1 setBackgroundColor:[UIColor whiteColor]];
        [btt1 setAlpha:0.5f];
        btt1.layer.cornerRadius = btt1.layer.frame.size.height/2;
        [btt1 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Cheese]) && ([[RestaurantNameData objectAtIndex:index1] isEqualToString:@"CHEESE"])){
        [btt1 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt1 setBackgroundColor:[UIColor whiteColor]];
        [btt1 setAlpha:0.5f];
        btt1.layer.cornerRadius = btt1.layer.frame.size.height/2;
        [btt1 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btt1 addTarget:self action:@selector(goToSpin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(index2 >= RestaurantNameData.count){
        [img2 setHidden:true];
        [lbl21 setHidden:true];
        [lbl22 setHidden:true];
        [btt2 setHidden:true];
        return Cell;
    }else{
        [img2 setImage:[UIImage imageNamed:[RestaurantImageData objectAtIndex:index2]]];
        [lbl21 setText:[RestaurantLabelData objectAtIndex:index2]];
        [lbl22 setText:[RestaurantNameData objectAtIndex:index2]];
        [btt2 setTag:index2];
        
    }
    if((![appDel loadInAppPuchage:kPuchage_Seafood]) && ([[RestaurantNameData objectAtIndex:index2] isEqualToString:@"SEAFOOD"])){
        [btt2 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt2 setBackgroundColor:[UIColor whiteColor]];
        [btt2 setAlpha:0.5f];
        btt2.layer.cornerRadius = btt2.layer.frame.size.height/2;
        [btt2 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Vegetarian]) && ([[RestaurantNameData objectAtIndex:index2] isEqualToString:@"VEGETARIAN"])){
        [btt2 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt2 setBackgroundColor:[UIColor whiteColor]];
        [btt2 setAlpha:0.5f];
        btt2.layer.cornerRadius = btt2.layer.frame.size.height/2;
        [btt2 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Bakery]) && ([[RestaurantNameData objectAtIndex:index2] isEqualToString:@"BAKERY"])){
        [btt2 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt2 setBackgroundColor:[UIColor whiteColor]];
        [btt2 setAlpha:0.5f];
        btt2.layer.cornerRadius = btt2.layer.frame.size.height/2;
        [btt2 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else if((![appDel loadInAppPuchage:kPuchage_Cheese]) && ([[RestaurantNameData objectAtIndex:index2] isEqualToString:@"CHEESE"])){
        [btt2 setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [btt2 setBackgroundColor:[UIColor whiteColor]];
        [btt2 setAlpha:0.5f];
        btt2.layer.cornerRadius = btt2.layer.frame.size.height/2;
        [btt2 addTarget:self action:@selector(goToUnlock:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btt2 addTarget:self action:@selector(goToSpin:) forControlEvents:UIControlEventTouchUpInside];
    }
//
//    [objectOfButton addTarget:self action:@selector(YourSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    return Cell;
}
@end
