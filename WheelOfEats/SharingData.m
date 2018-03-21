//
//  SharingData.m
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "SharingData.h"

@implementation SharingData
@synthesize YELP_API_SEARCH_URL, YELP_API_AUTH_URL, ACCESS_TOKEN, TOKEN_TYPE;

static SharingData *instance = nil;

+(SharingData *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [SharingData new];
        }
    }
    return instance;
}

@end
