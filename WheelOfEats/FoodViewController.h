//
//  FoodViewController.h
//  WheelOfEats
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FoodViewController : UIViewController<SKRequestDelegate, SKPaymentTransactionObserver, CLLocationManagerDelegate>
{
    SKProductsRequest *productsRequest;
//    NSArray *validProducts;
    UIActivityIndicatorView *activityIndicatorView;
    
}
-(void)fetchAvailableProducts;
-(BOOL)canMakePurchases;
-(void)purchaseMyProduct:(SKProduct *)product;

@end
