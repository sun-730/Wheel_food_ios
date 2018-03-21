//
//  WOECustomWheel.h
//  WheelOfEats
//
//  Created by Admin on 5/18/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOERotaryProtocol.h"

@interface WOECustomWheel : UIControl

@property (weak) id delegate;
@property (nonatomic, strong) UIView *container;
@property NSString *wheelTitle;
@property int numberOfSections;
@property NSMutableArray* wheelEntry;
@property CGAffineTransform startTransform;
@property NSMutableDictionary* wheelData;
@property NSMutableArray *sectorsTitle;
@property NSMutableArray *sectorsComment;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del title:title withData:(NSMutableDictionary*)data;

@end
