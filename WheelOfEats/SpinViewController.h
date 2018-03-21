//
//  SpinViewController.h
//  WheelOfEats
//
//  Created by Admin on 5/4/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOERotaryWheel.h"
#import <PinterestSDK/PinterestSDK.h>

@interface SpinViewController : UIViewController{
    
    UIActivityIndicatorView *activityIndicatorView;
    PDKInterest *pinterest;
}
@property int wheelType;
@property NSString *helpLink;
@property (nonatomic) int Hi;

//- (void)(handler);

@end
