//
//  LeftMenuViewController.m
//  WheelOfEats
//
//  Created by Admin on 4/27/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "AccountViewCell.h"
#import "MainViewCell.h"
#import "OtherViewCell.h"
#import "SignoutViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
@import Firebase;


@interface LeftMenuViewController ()

@property (strong, nonatomic) NSArray *mainMenuTitleArray;
@property (strong, nonatomic) NSArray *mainMenuIconArray;
@property (strong, nonatomic) NSArray *otherMenuTitleArray;
@property (weak, nonatomic) IBOutlet UIButton *visitStore;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // adding background image
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    myImage.image = [UIImage imageNamed:@"sidebar-BG.jpg"];
    self.tableView.backgroundView = myImage;
    
    self.mainMenuTitleArray = @[@"Food",
                                @"Drink",
                                @"My Wheels",
//                                @"Facts Listed",
                                @"Setting"];
    self.mainMenuIconArray = @[@"food_icon.png",
                               @"drink_icon.png",
                               @"mywheel_icon.png",
//                               @"result_icon.png",
                               @"setting_icon.png"];
//    self.otherMenuTitleArray = @[@"Terms of Use",
//                                 @"Privacy Policy"];
    _visitStore.layer.borderColor = [UIColor whiteColor].CGColor;
    _visitStore.layer.borderWidth = 2;
    _visitStore.layer.cornerRadius = 25
    ;
    _visitStore.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _visitStore.titleLabel.numberOfLines = 2;
    _visitStore.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_visitStore setTitle:@"VISIT MY STORE \nfor bookinngs and gift cards" forState:UIControlStateNormal];

}

- (IBAction)visitMyStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.designrox.com/product/cooking-bookmark/"]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+ self.mainMenuTitleArray.count;// + self.otherMenuTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"account_cell"];
        if ([FIRAuth auth].currentUser) {
            ((AccountViewCell *)cell).accountName.text = [FIRAuth auth].currentUser.email;
        } else {
            // No user is signed in.
            ((AccountViewCell *)cell).accountName.text = @"";
        }
        
//        NSData *imageData = [NSData dataWithContentsOfURL:[FIRAuth auth].currentUser.photoURL];
//        ((AccountViewCell *)cell).accountImage.image = [UIImage imageWithData:imageData];
//        ((AccountViewCell *)cell).accountImage.layer.cornerRadius = ((AccountViewCell *)cell).accountImage.frame.size.width / 2;
//        ((AccountViewCell *)cell).accountImage.layer.masksToBounds = YES;
//        ((AccountViewCell *)cell).accountImage.layer.borderColor = [[UIColor whiteColor] CGColor];
//        ((AccountViewCell *)cell).accountImage.layer.borderWidth = 3;
        
    }
    else if (indexPath.row <= self.mainMenuTitleArray.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"main_cell"];
        ((MainViewCell *)cell).mainMenuTitle.text = self.mainMenuTitleArray[indexPath.row - 1];
        
        ((MainViewCell *)cell).mainMenuIcon.image = [UIImage imageNamed: self.mainMenuIconArray[indexPath.row - 1]];
        
    }
    else if (indexPath.row == self.mainMenuTitleArray.count + 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"empty_cell"];
    }
//    else if (indexPath.row < self.mainMenuTitleArray.count + 4) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"other_cell"];
//        ((OtherViewCell *)cell).otherMenuTitle.text = self.otherMenuTitleArray[indexPath.row - 2 - self.mainMenuTitleArray.count];
//    }
//    else if (indexPath.row == self.mainMenuTitleArray.count + 4) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"blank_cell"];
//    }
//    else {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"signout_cell"];
//    }

    
   
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 150;
    }
    else if (indexPath.row <= self.mainMenuIconArray.count) {
        return 60;
    }
//    else if (indexPath.row == self.mainMenuIconArray.count + 1) {
//        return 30;
//    }
//    else if (indexPath.row < self.mainMenuIconArray.count + 4) {
//        return 40;
//    }
    else {
        return 30;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController;
       switch (indexPath.row) {
        case 0:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            break;
        case 1:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodViewController"];
            break;
        case 2:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrinkViewController"];
            break;
        case 3:
            
//            username = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
//            if (username == nil)
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
//                
//            else
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWheelViewController"];
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSpinViewController"];
            break;
//        case 4:
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
//            break;
        case 4:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            break;
        case 5:
            NSLog(@"HI");
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            break;
//        case 6:
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
//            break;
//        case 7:
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PolicyViewController"];
            break;
        case 6:
            
            return;
//        case 9:
//            {
//                NSError *signOutError;
//                BOOL status = [[FIRAuth auth] signOut:&signOutError];
//                if (!status) {
//                    NSLog(@"Error signing out: %@", signOutError);
//                    return;
//                }
//            }
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWheelViewController"];
            break;
        default:
            return;
        
    }
    
    [navigationController setViewControllers:@[viewController]];
    [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
