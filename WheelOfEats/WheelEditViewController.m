//
//  WheelEditViewController.m
//  WheelOfEats
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "WheelEditViewController.h"
#import "WhellEdit2ViewController.h"
@import Firebase;
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface WheelEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *wheelTitle;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry1;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry2;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry3;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry4;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry5;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry6;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry7;
@property (weak, nonatomic) IBOutlet UITextField *wheelEntry8;

@property (weak, nonatomic) IBOutlet UIButton *wheelEditButton;

@property (strong, nonatomic) FIRDatabaseReference *wheelRef;
@property (nonatomic ) Boolean isEdit;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;

@end

@implementation WheelEditViewController{
    AppDelegate* appDel;
    
}

@synthesize title, description;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit = false;
    appDel = [UIApplication sharedApplication].delegate;
    
//    self.wheelRef = [[[[FIRDatabase database] reference] child:[FIRAuth auth].currentUser.uid]  child:@"wheel"];
    [self initUI];
    
    self.wheelTitle.delegate = self;
    self.wheelEntry1.delegate = self;
    self.wheelEntry2.delegate = self;
    self.wheelEntry3.delegate = self;
    self.wheelEntry4.delegate = self;
    self.wheelEntry5.delegate = self;
    self.wheelEntry6.delegate = self;
    self.wheelEntry7.delegate = self;
    self.wheelEntry8.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
//    let info = notification.userInfo!
//    notification.userInfo
//    let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//    CGRect *keyboardFrame = []
//    
//    
//    UIView.animateWithDuration(0.1, animations: { () -> Void in
//        self.bottomConstraint.constant = keyboardFrame.size.height + 20
//    })
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.1
                     animations:^(void){
                     }
                     completion:^(BOOL finished){
         
                     }];
    
}

- (void)initUI {
    if (title != nil) {
        
        self.titleLabel.title = @"Edit Wheel";
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext;//Your ManagedObjectContext;
        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
        
        NSManagedObject *obj  =result[0];
            
        NSArray *keys = [[[obj entity] attributesByName] allKeys];
        NSDictionary *data = [obj dictionaryWithValuesForKeys:keys];
        NSLog(@"");
        _wheelTitle.text = title;

        _wheelEntry1.text = data[@"entry1"];
        _wheelEntry2.text = data[@"entry2"];
        _wheelEntry3.text = data[@"entry3"];
        _wheelEntry4.text = data[@"entry4"];
        _wheelEntry5.text = data[@"entry5"];
        _wheelEntry6.text = data[@"entry6"];
        _wheelEntry7.text = data[@"entry7"];
        _wheelEntry8.text = data[@"entry8"];
        description = data[@"wheeldescription"];
        _isEdit = true;
        [_wheelEditButton setImage:[UIImage imageNamed:@"delete_button.png"] forState:UIControlStateNormal];
       
    }else{
        self.navigationController.title = @"Create Wheel";
        description = @"";
        [_wheelEditButton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchedBackButton:(id)sender {
    _managedObjectContext = [self managedObjectContext];
    if(_isEdit){
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext;//Your ManagedObjectContext;
        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
        
        NSManagedObject *obj  =result[0];
        [appDel.managedObjectContext deleteObject:obj];
        
        // Save the object to persistent store
        if (![appDel.managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

    }else{
        // Create a new managed object
        NSManagedObject *wheel = [NSEntityDescription insertNewObjectForEntityForName:@"Wheel" inManagedObjectContext:appDel.managedObjectContext];
        [wheel setValue:_wheelTitle.text forKey:@"wheelTitle"];
        [wheel setValue:_wheelEntry1.text forKey:@"entry1"];
        [wheel setValue:_wheelEntry2.text forKey:@"entry2"];
        [wheel setValue:_wheelEntry3.text forKey:@"entry3"];
        [wheel setValue:_wheelEntry4.text forKey:@"entry4"];
        [wheel setValue:_wheelEntry5.text forKey:@"entry5"];
        [wheel setValue:_wheelEntry6.text forKey:@"entry6"];
        [wheel setValue:_wheelEntry7.text forKey:@"entry7"];
        [wheel setValue:_wheelEntry8.text forKey:@"entry8"];
        [wheel setValue:description forKey:@"wheeldescription"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![appDel.managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)didTouchedSaveButton:(id)sender {
    
//    _managedObjectContext = [self managedObjectContext];
//    if(_isEdit){
//        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
//        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
//        [request setPredicate:predicate];
//        [request setReturnsObjectsAsFaults:NO];
//        
//        NSError *error = nil;
//        NSManagedObjectContext *managedObjectContext;//Your ManagedObjectContext;
//        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
//        
//        NSManagedObject *obj  =result[0];
//        [appDel.managedObjectContext deleteObject:obj];
//
//        // Save the object to persistent store
//        if (![appDel.managedObjectContext save:&error]) {
//            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//        }
//
//    }else{
//        description = @"";
//    }
    
    
/*
    // Create a new managed object
    NSManagedObject *wheel = [NSEntityDescription insertNewObjectForEntityForName:@"Wheel" inManagedObjectContext:appDel.managedObjectContext];
    [wheel setValue:_wheelTitle.text forKey:@"wheelTitle"];
    [wheel setValue:_wheelEntry1.text forKey:@"entry1"];
    [wheel setValue:_wheelEntry2.text forKey:@"entry2"];
    [wheel setValue:_wheelEntry3.text forKey:@"entry3"];
    [wheel setValue:_wheelEntry4.text forKey:@"entry4"];
    [wheel setValue:_wheelEntry5.text forKey:@"entry5"];
    [wheel setValue:_wheelEntry6.text forKey:@"entry6"];
    [wheel setValue:_wheelEntry7.text forKey:@"entry7"];
    [wheel setValue:_wheelEntry8.text forKey:@"entry8"];
    [wheel setValue:description forKey:@"description"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![appDel.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
 */
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    if (nextTag > 8) {
        [textField resignFirstResponder];
    }
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *dest = [segue destinationViewController];
    if ([[segue identifier] isEqualToString: @"editNext"]) {
        ((WhellEdit2ViewController *)dest).isEdit = _isEdit;
        ((WhellEdit2ViewController *)dest).title = _wheelTitle.text;
        ((WhellEdit2ViewController *)dest).txt1 = _wheelEntry1.text;
        ((WhellEdit2ViewController *)dest).txt2 = _wheelEntry2.text;
        ((WhellEdit2ViewController *)dest).txt3 = _wheelEntry3.text;
        ((WhellEdit2ViewController *)dest).txt4 = _wheelEntry4.text;
        ((WhellEdit2ViewController *)dest).txt5 = _wheelEntry5.text;
        ((WhellEdit2ViewController *)dest).txt6 = _wheelEntry6.text;
        ((WhellEdit2ViewController *)dest).txt7 = _wheelEntry7.text;
        ((WhellEdit2ViewController *)dest).txt8 = _wheelEntry8.text;
        ((WhellEdit2ViewController *)dest).description = description;
    }
}

@end
