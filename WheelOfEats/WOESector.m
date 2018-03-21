//
//  SMSector.m
//  RotaryWheel
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "WOESector.h"

@implementation WOESector

@synthesize minValue, maxValue, midValue, sector;

- (NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
}


@end
