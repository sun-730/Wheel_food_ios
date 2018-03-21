//
//  Additional.m
//  WheelOfEats
//
//  Created by Syed Askari on 7/27/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "Additional.h"
#import "SpinViewController.h"
#import "DrinkViewController.h"

@interface Additional ()

@end

@implementation Additional

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed1:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonPressed2:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonPressed3:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Identifier: %@", segue.identifier);
    //fromrestauranttodrink
    SpinViewController *dest = [segue destinationViewController];
    NSLog(@"Identifier: %@", segue.identifier);
    if ([[segue identifier] isEqualToString: @"vegetarian"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = VEGETARIAN_WHEEL;
    } else if([[segue identifier] isEqualToString: @"seaFood"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        
        //        SpinViewController *spin = [segue destinationViewController];
        //        [spin topViewController];
        
        //        dest.wheelType = CULTURE_FOOD_WHEEL;
        //        dest.wheelType = 1;
        //        dest.Hi = 1;
        spin.wheelType = SEAFOOD_WHEEL;
    } else if([[segue identifier] isEqualToString: @"customWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = CUSTOM_FOOD_WHEEL;
    } else if([[segue identifier] isEqualToString: @"meat"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = MEAT_WHEEL;
    } else if([[segue identifier] isEqualToString:@"fromrestauranttodrink"]){
//        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        DrinkViewController *drink = (DrinkViewController *)segue.destinationViewController;
        drink.fromRestaurant = 10;
        
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

@end
