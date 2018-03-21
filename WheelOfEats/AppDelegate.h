//
//  AppDelegate.h
//  WheelOfEats
//
//  Created by Admin on 4/23/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContextModify;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data
-(void)saveInAppPuchage:(NSString *)forKey :(NSString *)value;
-(Boolean)loadInAppPuchage:(NSString *)forKey;

@property(nonatomic,assign) BOOL isMute;
@end







