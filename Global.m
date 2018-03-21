//
//  Global.m
//  WheelOfEats
//
//  Created by Taimoor on 23/06/2017.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "Global.h"

@implementation Global


@synthesize IS_MUTE, myCity;

static Global *instance = nil;

+(Global *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [Global new];
            instance.myCity = @"";
        }
    }
    return instance;
}
@end
