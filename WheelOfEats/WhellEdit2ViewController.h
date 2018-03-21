//
//  WhellEdit2ViewController.h
//  WheelOfEats
//
//  Created by admin on 16/08/2017.
//
//

#import <UIKit/UIKit.h>

@interface WhellEdit2ViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *title, *txt1, *txt2, *txt3, *txt4, *txt5, *txt6, *txt7, *txt8, *description;
@property (nonatomic) Boolean isEdit;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
