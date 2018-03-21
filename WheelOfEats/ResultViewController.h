//
//  ResultViewController.h
//  WheelOfEats
//
//  Created by Admin on 6/1/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@end
