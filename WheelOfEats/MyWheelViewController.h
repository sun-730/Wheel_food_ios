//
//  MyWheelViewController.h
//  WheelOfEats
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWheelViewController : UIViewController
@property (strong) NSMutableDictionary *data,*allData;
@property (strong) NSMutableArray *data1;
@property int modeCustom;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
