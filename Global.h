//
//  Global.h
//  WheelOfEats
//
//  Created by Taimoor on 23/06/2017.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Global : NSObject

@property (nonatomic, assign) Boolean IS_MUTE;
@property (nonatomic) NSString *myCity;
@property (nonatomic) CLLocationCoordinate2D myLocation;


#define kPuchage_Bakery     @"com.designrox.wheelofeats.bakery"
#define kPuchage_Beer       @"com.designrox.wheelofeats.beer"
#define kPuchage_Custom     @"com.designrox.wheelofeats.custom"
#define kPuchage_Seafood    @"com.designrox.wheelofeats.seafood"
#define kPuchage_Vegetarian @"com.designrox.wheelofeats.vegetarian"
#define kPuchage_Wine       @"com.designrox.wheelofeats.wine"
#define kPuchage_Cheese     @"com.designrox.wheelofeats.cheese"

+(Global *)getInstance;
@end
