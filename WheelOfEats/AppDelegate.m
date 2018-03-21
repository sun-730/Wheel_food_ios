//
//  AppDelegate.m
//  WheelOfEats
//
//  Created by Admin on 4/23/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "AppDelegate.h"
#import "TutorialViewController.h"
#import "MainViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <PinterestSDK/PinterestSDK.h>
#import "PDKClient.h"

static NSString * const kPDKExampleFakeAppId = @"4917310690579988706";
static NSString * const OAuthTokenConsumerKey = @"5fpsum8xG3hOb6FMu337J9bhDDTqjNzMsaqTD3Sx57QjA4EwFU";
static NSString * const ConsumerSecret = @"Fq4OMq0cztvY7f7MfgjLdmslbghwQ7Cd3KRimzrbMGh9CHxjz2";
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize isMute = _isMute;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    IQKeyboardManager.sharedManager().enable = true;
    // Use Firebase library to configure APIs.
    [FIRApp configure];
    [self setupRootViewController];
    // Initialize the Google Mobile Ads SDK.
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-1972998462639092~7303360752"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [[Twitter sharedInstance] startWithConsumerKey:@"xix9PBEmnaA7D8WiDaYi7lWyP" consumerSecret:@"pMvZnpSUrnNGK157s6nzeHBdlhie0nnlswsxA9RURL4O2uvR7d"];
//    [Fabric with:@[[Crashlytics class]]];
    
    [PDKClient configureSharedInstanceWithAppId:kPDKExampleFakeAppId];

    [Fabric with:@[[Crashlytics class], [Twitter class]]];

    
    _isMute = false;
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[PDKClient sharedInstance] handleCallbackURL:url];
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    [[Twitter sharedInstance] application:app openURL:url options:options];
//    return [[PDKClient sharedInstance] handleCallbackURL:url];
//}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL twitter = [[Twitter sharedInstance] application:app openURL:url options:options];
    BOOL pinterest = [[PDKClient sharedInstance] handleCallbackURL:url];
    BOOL facebook = [[FBSDKApplicationDelegate sharedInstance] application:app didFinishLaunchingWithOptions:options];
    if(twitter || pinterest || facebook){
        return true;
    }
    return false;
}
- (void) setupRootViewController {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tuto_view"]==nil) {
       TutorialViewController  *tutorialViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TutorialViewController"]; //or the homeController
//        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
//        [navController setNavigationBarHidden:YES animated:YES];
        self.window.rootViewController = tutorialViewController;
    } else {
//        MainViewController  *mainViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@""];
//        self.window.rootViewController = mainViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarcontroller1"];
        self.window.rootViewController = rootViewController;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
} 
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    return [[Twitter sharedInstance] application:app openURL:url options:options];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContextModify{
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
-(void)saveInAppPuchage:(NSString *)forKey :(NSString *)value
{
    NSString *valueToSave = value;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:forKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(Boolean)loadInAppPuchage:(NSString *)forKey
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:forKey];
    if([savedValue isEqualToString:@"no"]) return NO;
    return YES;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
