//
//  SMRotaryWheel.h
//  RotaryWheel
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOERotaryProtocol.h"
#import "WOESector.h"

#define STYLE_FOOD_WHEEL        0
#define CULTURE_FOOD_WHEEL      1
#define CUSTOM_FOOD_WHEEL       2
#define LIQUOR_DRINK_WHEEL      3
#define BEER_DRINK_WHEEL        4
#define TEA_DRINK_WHEEL         5
#define WINE_DRINK_WHEEL        6
#define SPANISH_CULTURE_WHEEL   7
#define EUROPEAN_CULTURE_WHEEL  8
#define NORTH_CULTURE_WHEEL     9
#define ASIAN_CULTURE_WHEEL     10
#define TROPICAL_CULTURE_WHEEL  11
#define MIDDLE_CULTURE_WHEEL    12
#define SEAFOOD_WHEEL           13
#define VEGETARIAN_WHEEL        14
#define MEAT_WHEEL              15
#define BAKERY_WHEEL            16
#define FLAVORS_WHEEL           17
#define CHEESE_WHEEL            18
#define AROUNTME_WHEEL          19

#define CUSTOM_SPIN_INDEX       20;


@interface WOERotaryWheel : UIControl

@property (weak) id delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property int wheelType;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property (nonatomic) NSArray *sectorsTitle;
@property int currentSector;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del inWheel:(int)wheelNo;

- (void) rotate;

@end


