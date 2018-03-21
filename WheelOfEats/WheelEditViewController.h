//
//  WheelEditViewController.h
//  WheelOfEats
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelEditViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *title, *description;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
