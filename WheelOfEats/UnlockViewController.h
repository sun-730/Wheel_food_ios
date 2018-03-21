//
//  UnlockViewController.h
//  WheelOfEats
//
//  Created by admin on 11/08/2017.
//
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface UnlockViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    
    SKProductsRequest *productsRequest;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *validProducts;
    NSMutableArray *purchasedItemIDs;
}

@end
