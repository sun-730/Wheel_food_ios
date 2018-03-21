//
//  MainViewController.m
//  LGSideMenuControllerDemo
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LeftMenuViewController.h"

@interface MainViewController ()

@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setupWithType:(NSUInteger)type {
    self.type = type;

    // -----

    if (self.storyboard) {
        // Left and Right view controllers is set in storyboard
        // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

        // Sizes and styles is set in storybord
        // You can also find there all other properties

        // LGSideMenuController fully customizable from storyboard
    }
    else {
        self.leftViewController = [LeftMenuViewController new];

        self.leftViewWidth = 200.0;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"imageLeft"];
        self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.65 blue:0.5 alpha:0.95];
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    }

    // -----

    UIColor *greenCoverColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.3];
    UIBlurEffectStyle regularStyle;

    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        regularStyle = UIBlurEffectStyleRegular;
    }
    else {
        regularStyle = UIBlurEffectStyleLight;
    }

    // -----

    switch (self.type) {
        case 0: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
        case 1: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rootViewCoverColorForLeftView = greenCoverColor;

            break;
        }
        case 2: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;

            break;
        }
        case 3: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;

            break;
        }
        case 4: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rootViewCoverBlurEffectForLeftView = [UIBlurEffect effectWithStyle:regularStyle];
            self.rootViewCoverAlphaForLeftView = 0.8;

            break;
        }
        case 5: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.leftViewCoverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.leftViewCoverColor = nil;

            break;
        }
        case 6: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:regularStyle];
            self.leftViewBackgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
            self.rootViewCoverColorForLeftView = greenCoverColor;

            break;
        }
        case 7: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rootViewCoverColorForLeftView = greenCoverColor;

            break;
        }
        case 8: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;

            break;
        }
        case 9: {
            self.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;

            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
        case 10: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
    }
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (BOOL)isLeftViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isLeftViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
