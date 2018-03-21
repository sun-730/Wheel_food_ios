//
//  CustomSpinViewController.h
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOECustomRotaryWheel.h"

@interface CustomSpinViewController : UIViewController{
    
    UIActivityIndicatorView *activityIndicatorView;
}
@property NSString* title;
@property NSMutableDictionary *wheelData;
@property int modeCustom;
@end
