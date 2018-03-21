//
//  TutorialViewController.m
//  WheelOfEats
//
//  Created by StarMac on 4/22/17.
//  Copyright © 2017 Roxana carrion. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"
#import "SharingData.h"
#import "Global.h"


@interface TutorialViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *arrayImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btn_OK;
@property (weak, nonatomic) IBOutlet UIButton *btn_readTerm;

@end

@implementation TutorialViewController
{
    AppDelegate* appDel;
}
Boolean istermRead;

- (void)viewDidLoad {
    [super viewDidLoad];
    istermRead = true;
    [self.btn_readTerm setHidden: YES];
    self.arrayImage = [NSArray arrayWithObjects:@"tutorials1.jpg", @"tutorials2.jpg", @"tutorials3.jpg", @"tutorials4.jpg", @"tutorials5.jpg", @"tutorials6.jpg", @"tutorials7.jpg", nil, nil];
    
    for (int i = 0; i < self.arrayImage.count; i++) {
        UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, -20, self.view.frame.size.width, self.view.frame.size.height)];
        
        page.image = [UIImage imageNamed:self.arrayImage[i]];
        page.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:page];
    }
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*(self.arrayImage.count), self.view.frame.size.height - 20);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        _pageControl.numberOfPages = self.arrayImage.count;
//        _pageControl.backgroundColor = [UIColor whiteColor];
//        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self setInitialInAppPuchageData];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if(istermRead){
        [self.btn_OK setEnabled:true];
    }else{
        [self.btn_OK setEnabled:false];
    }
}
-(void)setInitialInAppPuchageData{
    appDel = [UIApplication sharedApplication].delegate;
    Boolean test = true;
    if(test){
        [appDel saveInAppPuchage:kPuchage_Bakery :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Beer :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Custom :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Seafood :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Vegetarian :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Wine :@"yes"];
        [appDel saveInAppPuchage:kPuchage_Cheese :@"yes"];
    }else{
        [appDel saveInAppPuchage:kPuchage_Bakery :@"no"];
        [appDel saveInAppPuchage:kPuchage_Beer :@"no"];
        [appDel saveInAppPuchage:kPuchage_Custom :@"no"];
        [appDel saveInAppPuchage:kPuchage_Seafood :@"no"];
        [appDel saveInAppPuchage:kPuchage_Vegetarian :@"no"];
        [appDel saveInAppPuchage:kPuchage_Wine :@"no"];
        [appDel saveInAppPuchage:kPuchage_Cheese :@"no"];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int contentOffset = scrollView.contentOffset.x;
    NSInteger currentPage = contentOffset/self.view.frame.size.width;
    if (currentPage == [self.arrayImage count] - 1) {
        [self.btn_OK setHidden: NO];
        [self.btn_readTerm setHidden: NO];
    }
    else {
        [self.btn_OK setHidden: YES];
        [self.btn_readTerm setHidden: YES];
    }
    
    self.pageControl.currentPage = currentPage;
}
- (IBAction)goToTerms:(id)sender {
    istermRead = true;
}


- (IBAction)gotItButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:@"tuto_view"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
