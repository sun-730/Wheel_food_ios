//
//  WhellEdit2ViewController.m
//  WheelOfEats
//
//  Created by admin on 16/08/2017.
//
//

#import "WhellEdit2ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "MyWheelViewController.h"

@interface WhellEdit2ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (strong, nonatomic) FIRDatabaseReference *wheelRef;
@end

@implementation WhellEdit2ViewController{
    AppDelegate* appDel;
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize title, txt1, txt2, txt3, txt4, txt5, txt6, txt7, txt8, description, isEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDel = [UIApplication sharedApplication].delegate;
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.1
                     animations:^(void){
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUI {
    if (isEdit) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
        if(result.count > 0){
            NSManagedObject *obj  =result[0];
            
            NSArray *keys = [[[obj entity] attributesByName] allKeys];
            NSDictionary *data = [obj dictionaryWithValuesForKeys:keys];
            
            NSLog(@"");
            self.txtDescription.text = data[@"wheeldescription"];
            
        }
        
    }else{
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)SaveWheel:(id)sender {_managedObjectContext = [self managedObjectContext];
    if(isEdit){
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Wheel"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wheelTitle == %@", title];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext;//Your ManagedObjectContext;
        NSArray *result = [appDel.managedObjectContext executeFetchRequest:request error:&error];
        if(result.count > 0){
            NSManagedObject *obj  =result[0];
            [appDel.managedObjectContext deleteObject:obj];
            
            // Save the object to persistent store
            if (![appDel.managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    
    // Create a new managed object
    NSManagedObject *wheel = [NSEntityDescription insertNewObjectForEntityForName:@"Wheel" inManagedObjectContext:appDel.managedObjectContext];
    [wheel setValue:title forKey:@"wheelTitle"];
    [wheel setValue:txt1 forKey:@"entry1"];
    [wheel setValue:txt2 forKey:@"entry2"];
    [wheel setValue:txt3 forKey:@"entry3"];
    [wheel setValue:txt4 forKey:@"entry4"];
    [wheel setValue:txt5 forKey:@"entry5"];
    [wheel setValue:txt6 forKey:@"entry6"];
    [wheel setValue:txt7 forKey:@"entry7"];
    [wheel setValue:txt8 forKey:@"entry8"];
    [wheel setValue:_txtDescription.text forKey:@"wheeldescription"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![appDel.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
//    MyWheelViewController *myWheel = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyWheelViewController"];
    
    UITabBarController *loadTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarcontroller1"];
    loadTabBar.selectedIndex=2;
    [self presentViewController:loadTabBar animated:YES completion:nil];
}
- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([[segue identifier] isEqualToString: @"save"]) {
        
    }
}
@end
