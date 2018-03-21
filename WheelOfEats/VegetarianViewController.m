//
//  VegetarianViewController.m
//  WheelOfEats
//
//  Created by dev on 4/28/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "VegetarianViewController.h"
#import "SpinViewController.h"

@interface VegetarianViewController ()
@property (weak, nonatomic) IBOutlet UIButton *liquorButton;
@property (weak, nonatomic) IBOutlet UIButton *beerButton;
@property (weak, nonatomic) IBOutlet UIButton *teaButton;
@property (weak, nonatomic) IBOutlet UIButton *wineButton;

@end

@implementation VegetarianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SpinViewController *dest = [segue destinationViewController];
    if ([[segue identifier] isEqualToString: @"liquorWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = LIQUOR_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"beerWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = BEER_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"teaWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = TEA_DRINK_WHEEL;
    } else if([[segue identifier] isEqualToString: @"wineWheel"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SpinViewController *spin = (SpinViewController *)nav.topViewController;
        spin.wheelType = WINE_DRINK_WHEEL;
    }
}

@end
