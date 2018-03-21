//
//  WOECustomRotaryWheel.h
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOERotaryProtocol.h"
#import "WOESector.h"


@interface WOECustomRotaryWheel : UIControl
@property (weak) id delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property NSString *wheelTitle;
@property NSMutableDictionary* wheelData;
@property NSMutableArray *sectorsTitle;
@property NSMutableArray *sectorsComment;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del title:title withData:(NSMutableDictionary*)data;

- (void) rotate;


@end
