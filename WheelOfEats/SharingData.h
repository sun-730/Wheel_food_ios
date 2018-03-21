//
//  SharingData.h
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SharingData : NSObject

@property (nonatomic, retain) NSString *YELP_API_SEARCH_URL;
@property (nonatomic, retain) NSString *YELP_API_AUTH_URL;
@property (nonatomic, retain) NSString *CLIENT_ID;
@property (nonatomic, retain) NSString *CLIENT_SECRET;
@property (nonatomic, retain) NSString *ACCESS_TOKEN;
@property (nonatomic, retain) NSString *TOKEN_TYPE;

+(SharingData *)getInstance;

@end
