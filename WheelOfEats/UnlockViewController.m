//
//  UnlockViewController.m
//  WheelOfEats
//
//  Created by admin on 11/08/2017.
//
//

#import "UnlockViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import <StoreKit/StoreKit.h>
#import "SpinViewController.h"
#import "DrinkViewController.h"
#import "MyWheelViewController.h"


@interface UnlockViewController ()
@property (weak, nonatomic) IBOutlet UITableView *UnlockFeatureTable;

@end

@implementation UnlockViewController
{
    NSArray *UnlockData_image, *UnlockData_title, *UnlockData_description, *UnlockData_price;
    AppDelegate *appDel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = [UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    UnlockData_image = [NSArray arrayWithObjects:@"unlock_item5.png", @"unlock_item6.png", @"unlock_item1.png", @"unlock_item2.png", @"unlock_item4.png", @"unlock_item3.png", @"unlock_item7.png", nil];
    UnlockData_title = [NSArray arrayWithObjects:@"AT A BAKERY",@"PICK MY BEER",@"CUSTOM WHEELS",@"PICK MY SEAFOOD", @"VEGETARIAN", @"PICK MY WINE",@"PICK MY CHEESE",nil];
    UnlockData_description = [NSArray arrayWithObjects:@"Too many pastries to choose from? Don’t know if you want a crepe or croissant sandwich? This wheel will upload in “Already at Restaurant” upon purchase. Each result you land on comes with small facts.",@"Making decisions can be more difficult when already under the influence. Purchase our beer wheel to help you. Each result you land on comes with small facts.",@"Create your own wheels and save them. Enter many as 8 options, You can go back and edit these options anytime.",@"Need a break from cattle? Buy our seafood wheel, it will automatically be added to the 'Already at Restaurant' menu. Each result you land on comes with small facts.",@"For this wheel we listed vegetables high in nutrients. Whatever the wheel lands on, find a dish with that primary ingredient, it'll be easier to pick a dish if you're at a restaurant or finding a recipe. Each result you land on comes with small facts.",@"Some restaurants can have an extensive wine list that can be overwhelming. We're here to help. Each result you land on comes with small facts.",@"Need to host a party, or fill a cheeseboard at a restaurant? Spin to help you decide. The following choices are popular cheeses that pair well with wine.", nil];
    UnlockData_price = [NSArray arrayWithObjects:@"BUY $0.99",@"BUY $0.99",@"BUY $0.99",@"BUY $0.99",@"BUY $0.99",@"BUY $0.99",@"BUY $0.99", nil];
    [self checkPurchaged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restorePressed:(id)sender {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)checkPurchaged{
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.view.center;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [activityIndicatorView setAlpha:1];
    [activityIndicatorView hidesWhenStopped];
    [self fetchAvailableProducts];
}
-(void)fetchAvailableProducts {
    NSSet *productIdentifier = [NSSet setWithObjects:kPuchage_Bakery,kPuchage_Beer, kPuchage_Custom, kPuchage_Seafood, kPuchage_Vegetarian, kPuchage_Wine,kPuchage_Cheese, nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifier];
    productsRequest.delegate = self;
    [productsRequest start];
}
- (void)goToPurchage:(UIButton*)sender{
    int index = sender.tag;
    if(validProducts == nil) return;
    if(validProducts.count - 1 < index) return;
    [self purchaseMyProduct:[validProducts objectAtIndex:index]];
//    NSString *iapString;
//    switch (index) {
//        case 0:
//            iapString = kPuchage_Custom;
//            break;
//        case 1:
//            iapString = kPuchage_Seafood;
//            break;
//        case 2:
//            iapString = kPuchage_Bakery;
//            break;
//        case 3:
//            iapString = kPuchage_Vegetarian;
//            break;
//        case 4:
//            iapString = kPuchage_Wine;
//            break;
//        case 5:
//            iapString = kPuchage_Beer;
//            break;
//            
//        default:
//            break;
//    }
}

- (BOOL)restoreThePurchase {
    
    // restore the purchase
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    
    return YES;
}
-(BOOL)canMakePurchases{
    return [SKPaymentQueue canMakePayments];
}
- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}
#pragma mark StoreKit Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count>0) {
        validProducts = response.products;
        for(int i = 0; i < count; i++){
            validProduct = [response.products objectAtIndex:i];
//            if ([validProduct.productIdentifier
//                 isEqualToString:kPuchage_Beer]) {
//                [appDel saveInAppPuchage:kPuchage_Beer :@"no"];
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Wine]) {
//                [appDel saveInAppPuchage:kPuchage_Wine :@"no"];
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Seafood]) {
//                [appDel saveInAppPuchage:kPuchage_Seafood :@"no"];
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Bakery]) {
//                [appDel saveInAppPuchage:kPuchage_Bakery :@"no"];
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Custom]) {
//                [appDel saveInAppPuchage:kPuchage_Custom :@"no"];
//            }else if([validProduct.productIdentifier
//                      isEqualToString:kPuchage_Vegetarian]) {
//                [appDel saveInAppPuchage:kPuchage_Vegetarian :@"no"];
//            }
        }
    }
    [activityIndicatorView stopAnimating];
    
}
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    purchasedItemIDs = [[NSMutableArray alloc] init];
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
    for(NSString *str in purchasedItemIDs){
        if ([str isEqualToString:kPuchage_Beer]) {
            [appDel saveInAppPuchage:kPuchage_Beer :@"yes"];
        }else if ([str isEqualToString:kPuchage_Wine]) {
            [appDel saveInAppPuchage:kPuchage_Wine :@"yes"];
        }else if ([str isEqualToString:kPuchage_Bakery]) {
            [appDel saveInAppPuchage:kPuchage_Bakery :@"yes"];
        }else if ([str isEqualToString:kPuchage_Custom]) {
            [appDel saveInAppPuchage:kPuchage_Custom :@"yes"];
        }else if ([str isEqualToString:kPuchage_Vegetarian]) {
            [appDel saveInAppPuchage:kPuchage_Vegetarian :@"yes"];
        }else if ([str isEqualToString:kPuchage_Seafood]) {
            [appDel saveInAppPuchage:kPuchage_Seafood :@"yes"];
        }else if ([str isEqualToString:kPuchage_Cheese]) {
            [appDel saveInAppPuchage:kPuchage_Cheese :@"yes"];
        }
    }
    [self.UnlockFeatureTable reloadData];
}
-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kPuchage_Beer]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Beer :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Wine]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Wine :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Bakery]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Bakery :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Custom]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Custom :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Vegetarian]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Vegetarian :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Seafood]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Seafood :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Cheese]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Cheese :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self.UnlockFeatureTable reloadData];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                if ([transaction.payment.productIdentifier
                     isEqualToString:kPuchage_Beer]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Beer :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Wine]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Wine :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Bakery]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Bakery :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Custom]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Custom :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Vegetarian]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Vegetarian :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Seafood]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Seafood :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }else if ([transaction.payment.productIdentifier
                           isEqualToString:kPuchage_Cheese]) {
                    NSLog(@"Purchased ");
                    [appDel saveInAppPuchage:kPuchage_Cheese :@"yes"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Successfully restored your purchase" message:nil delegate:
                                              self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self.UnlockFeatureTable reloadData];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}
- (void)displayAlertViewWithMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully restored your purchase" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
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
        return 200;
    }
    else
    {
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 200;
    }
    else
    {
        return 100;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return UnlockData_image.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            if([appDel loadInAppPuchage:kPuchage_Bakery]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = BAKERY_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            }
            break;
        case 1:
            if([appDel loadInAppPuchage:kPuchage_Beer]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = BEER_DRINK_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
            break;
        case 2:
            if([appDel loadInAppPuchage:kPuchage_Custom]){
                MyWheelViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyWheelViewController"];
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
            break;
        case 3:
            if([appDel loadInAppPuchage:kPuchage_Seafood]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = SEAFOOD_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
            break;
        case 4:
            if([appDel loadInAppPuchage:kPuchage_Vegetarian]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = VEGETARIAN_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
            break;
        case 5:
            if([appDel loadInAppPuchage:kPuchage_Wine]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = WINE_DRINK_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
        case 6:
            if([appDel loadInAppPuchage:kPuchage_Cheese]){
                SpinViewController *spin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpinViewController"];
                spin.wheelType = CHEESE_WHEEL;
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:spin];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
                
            }
            break;
            
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [self.UnlockFeatureTable dequeueReusableCellWithIdentifier:@"unlockCell"];
    
    UIImageView *imgLogo = (UIImageView *)[Cell viewWithTag:301];
    UILabel *lblTitle = (UILabel *)[Cell viewWithTag:302];
    UITextField *tfDescription = (UITextField *)[Cell viewWithTag:303];
    UIButton *bttBuy = (UIButton *)[Cell viewWithTag:304];
    
    [imgLogo setImage:[UIImage imageNamed:[UnlockData_image objectAtIndex:indexPath.row]]];
    [lblTitle setText:[UnlockData_title objectAtIndex:indexPath.row]];
    [tfDescription setText:[UnlockData_description objectAtIndex:indexPath.row]];
    [bttBuy setTag:indexPath.row];
    switch (indexPath.row) {
        case 0:
            if([appDel loadInAppPuchage:kPuchage_Bakery]){
                [bttBuy.titleLabel setText: @"Purchased"];
                [bttBuy setEnabled:false];
            }
            break;
        case 1:
            if([appDel loadInAppPuchage:kPuchage_Beer]){
                [bttBuy setEnabled:false];
            }
            break;
        case 2:
            if([appDel loadInAppPuchage:kPuchage_Custom]){
                [bttBuy setEnabled:false];
            }
            break;
        case 3:
            if([appDel loadInAppPuchage:kPuchage_Seafood]){
                [bttBuy setEnabled:false];
            }
            break;
        case 4:
            if([appDel loadInAppPuchage:kPuchage_Vegetarian]){
                [bttBuy setEnabled:false];
            }
            break;
        case 5:
            if([appDel loadInAppPuchage:kPuchage_Wine]){
                [bttBuy setEnabled:false];
            }
        case 6:
            if([appDel loadInAppPuchage:kPuchage_Cheese]){
                [bttBuy setEnabled:false];
                [bttBuy.titleLabel setText: @"Purchased"];
            }
            break;
            
        default:
            break;
    }
    [bttBuy addTarget:self action:@selector(goToPurchage:) forControlEvents:UIControlEventTouchUpInside];
    
    return Cell;
}
@end
