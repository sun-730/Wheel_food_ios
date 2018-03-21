//
//  SMRotaryWheel.m
//  RotaryWheel
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 Harry. All rights reserved.
//

#import "WOERotaryWheel.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Global.h"

#define WHITE_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define BLACK_COLOR [UIColor colorWithRed:1/255.0 green:0/255.0 blue:0/255.0 alpha:1]
@interface WOERotaryWheel()
{
    float rotateV;
    NSTimer* timer;
    float initAngle;
    float lastAngle;
    NSTimeInterval initTime;
    NSTimeInterval lastTime;
    float initW;
    NSArray *sectorsTitleColor;
    NSArray *sectorsComment;
    NSArray *sectorsLink;
    AVAudioPlayer* audioPlayer;
    AVAudioPlayer* audioPlayer1;
}

- (void) drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorEven;
- (void) buildSectorOdd;
- (void) initWheelInfo;
- (NSString *) getSectorTitle:(int)position;
- (NSString *) getSectorComment:(int)position;
- (NSString *) getSectorLink:(int)position;
- (NSString *) getSectorIconName:(int)position;
- (int) getSectionNumbers;
- (int) getSectorViewHeight:(int) r;
- (UIColor *)lighterColorForColor:(UIColor *)c;
- (UIColor *)darkerColorForColor:(UIColor *)c;
- (void)addPieShapeToView:(UIView *) view withColor:(UIColor *)color;
- (UIColor *)getSectorColr:(int) i;
- (UIColor *)getSectorColrForWheelType:(int) i;



@end

static float deltaTime = 0.04;
static float deltaAngle = 0.002;

@implementation WOERotaryWheel{
    AppDelegate *appDel ;
    
    
}

@synthesize delegate, container, numberOfSections, wheelType;
@synthesize startTransform;
@synthesize sectors, sectorsTitle;
@synthesize currentSector;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del inWheel:(int)wheelNo {
    //1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        //2 - Set properties
        self.delegate = del;
        self.wheelType = wheelNo;
        //4 - Initialize wheel information
        [self initWheelInfo];
        self.numberOfSections = [self getSectionNumbers];
        //3 - Draw wheel
        [self drawWheel];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"GameShowWheelSpinSound" ofType:@"mp3"];
        NSURL* file = [NSURL fileURLWithPath:path];
        // thanks @gebirgsbaerbel
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer prepareToPlay];
        
        
        NSString* path1 = [[NSBundle mainBundle] pathForResource:@"Cheering-Sound" ofType:@"mp3"];
        NSURL* file1 = [NSURL fileURLWithPath:path1];
        // thanks @gebirgsbaerbel
        
        audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:file1 error:nil];
        [audioPlayer1 prepareToPlay];
        
        
    }
    return self;
}

- (void) drawWheel {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    int wheelRadius1 = 140;
    int wheelRadius2 = 140;
    int spinpointY = -26;
    if(width <= 320){
        wheelRadius1 = 130;
        wheelRadius2 = 115;
        spinpointY = -15;
    }
    // 1
    container = [[UIView alloc] initWithFrame:self.frame];
    
    // 2
    CGFloat angleSize = 2 * M_PI / numberOfSections;
    // 3 - Create the sectors
    self.currentSector = 0;
    for (int i = 0; i < numberOfSections; i++) {
        // 4 - Create image view
        UIView *sectorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wheelRadius1, [self getSectorViewHeight:wheelRadius1])];
        [self addPieShapeToView:sectorView withColor:[self getSectorColrForWheelType:i]];
        sectorView.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sectorView.layer.position = CGPointMake(container.bounds.size.width / 2.0 - container.frame.origin.x, container.bounds.size.height / 2.0 - container.frame.origin.y);
        sectorView.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorView];
        
        UIImageView *sectorImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        NSString *sectorImageName = [self getSectorIconName:i];
        UIImage *img = [UIImage imageNamed: sectorImageName];
        
        [sectorImg setImage:img];
        
        if(self.wheelType == CHEESE_WHEEL){
            
        }else{
            sectorImg.image = [sectorImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [sectorImg setTintColor:[UIColor whiteColor]];
            
        }
        sectorImg.layer.anchorPoint = CGPointMake(3.5f, 0.5f);
        sectorImg.layer.position = CGPointMake(container.bounds.size.width / 2.0 - container.frame.origin.x, container.bounds.size.height / 2.0 - container.frame.origin.y);
        sectorImg.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorImg];
//            UILabel *sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, wheelRadius2, [self getSectorViewHeight:wheelRadius2] - 20)];
//            [sectorLabel setNumberOfLines:0];
//            [sectorLabel setTextAlignment:NSTextAlignmentLeft];
//            [sectorLabel setTextColor:sectorsTitleColor[i]];
//            sectorLabel.text = sectorsTitle[i];
//            if (numberOfSections > 12)
//                sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:11];//10
//            else
//                sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];//15
//            sectorLabel.layer.anchorPoint = CGPointMake(0.95f, 0.5f);
//            sectorLabel.layer.position = CGPointMake(container.bounds.size.width / 2.0 - container.frame.origin.x, container.bounds.size.height / 2.0 - container.frame.origin.y);
//            sectorLabel.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
//            [container addSubview:sectorLabel];
    }
    
    // 7
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    // 7.1 - Add background and spin point image
    //    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height)];
    //    bg.image = [UIImage imageNamed:@"wheel_back.png"];
    //    [self addSubview:bg];
    UIImageView *spinPoint = [[UIImageView alloc] initWithFrame:CGRectMake(container.bounds.size.width / 2 - 10, spinpointY, 20, 25)];
    spinPoint.image = [UIImage imageNamed:@"spin_point.png"];
    [self addSubview:spinPoint];
    
    
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(container.bounds.size.width / 2 - 35, container.bounds.size.height / 2 - 35, 70, 70)];
    centerImage.image = [UIImage imageNamed:@"spin_center.png"];
    //    [self addSubview:centerImage];
    
    // 8 - Initialize sectors and wheelInfos
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0) {
        [self buildSectorEven];
    } else {
        [self buildSectorOdd];
    }
}

- (void) rotate {
    CGAffineTransform t = CGAffineTransformRotate(container.transform, initW);
    container.transform = t;
    if (initW > 0) {
        
        
        if(![Global getInstance].IS_MUTE){
            [audioPlayer play];
        }
        
        
        
        initW -= deltaAngle;
    } else if (initW < 0) {
        if(![Global getInstance].IS_MUTE){
            [audioPlayer play];
        }
        
        initW += deltaAngle;
    }
    
    if (initW > -deltaAngle && initW < deltaAngle){
        [timer invalidate];
        timer = nil;
        
        CGFloat radians = atan2f(container.transform.b, container.transform.a);
        for (WOESector *s in sectors) {
            if (s.minValue > 0 && s.maxValue < 0) {
                if (s.maxValue > radians || s.minValue < radians) {
                    currentSector = s.sector;
                    break;
                }
            } else if (radians > s.minValue && radians < s.maxValue) {
                currentSector = s.sector;
                break;
            }
            
        }
        NSLog(@"Current Sector is %d", currentSector);
        
        
        if(![Global getInstance].IS_MUTE){
            
            [audioPlayer stop];
            [audioPlayer1 play];
        }
        [self.delegate wheelDidChangeSector:currentSector];
        [self.delegate wheelDidChangeTitle:[self getSectorTitle:currentSector]];
        [self.delegate wheelDidChangeComment:[self getSectorComment:currentSector]];
        [self.delegate wheelDidChangeLink:[self getSectorLink:currentSector]];
        [self.delegate wheelDidChangeIconName:[self getSectorIconName:currentSector]];
        
    }
    
    NSLog(@"initW......%f", initW);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //1 - Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < 40 || dist > 150) {
        NSLog(@"ignoring tap (%f, %f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    //2 - Calculate distance from center
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    //3 - Calculate init gngle and init timeticks.
    initAngle = atan2(dy, dx);
    initTime = [[NSDate date] timeIntervalSince1970];
    //4 - Save current transform
    startTransform = container.transform;
    NSLog(@"Begin Tracking with touch");
    
    
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float ang = atan2(dy, dx);
    NSLog(@"angle is %f", ang);
    float angleDifference = initAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    NSLog(@"Continue Tracking with touch");
    
    
    
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    lastAngle = atan2(dy, dx);
    
    if(initAngle > 0){
        if(lastAngle < 0){
            initAngle *= -1;
        }
    }else if(initAngle < 0){
        if(lastAngle > 0){
            initAngle *= -1;
        }
    }
    lastTime = [[NSDate date] timeIntervalSince1970];
    initW = (lastAngle - initAngle) / (lastTime - initTime) * deltaTime;
    NSLog(@"initAngle is %f", initAngle);
    NSLog(@"lastAngle is %f", lastAngle);
    NSLog(@"deltaAngle is %f", lastAngle - initAngle);
    NSLog(@"deltaTime is %f", lastTime - initTime);
    NSLog(@"initW is %f", initW);
    
    if (timer != nil){
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:deltaTime target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    NSLog(@"End Tracking with touch");
    
}

- (float)calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx * dx + dy * dy);
}

- (void) buildSectorOdd {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI * 2 / numberOfSections;
    // 2 - Set intial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        WOESector *sector = [[WOESector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth / 2);
        sector.maxValue = mid + (fanWidth / 2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < -M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // 5 - Add sector to array
        [sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}

- (void) buildSectorEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI * 2 / numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        WOESector *sector = [[WOESector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth / 2);
        sector.maxValue = mid + (fanWidth / 2);
        sector.sector = i;
        if (sector.maxValue - fanWidth < -M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
        }
        mid -= fanWidth;
        NSLog(@"cl is %@", sector);
        // 5 - Add sector to array
        [sectors addObject:sector];
    }
}

- (NSString *) getSectorTitle:(int)position {
    return sectorsTitle[position];
}
- (UIColor *) getSectorTitleColor:(int)position {
    return sectorsTitleColor[position];
}

- (NSString *) getSectorComment: (int)position {
    return sectorsComment[position];
}
- (NSString *) getSectorLink: (int)position {
    return sectorsLink[position];
}

- (NSString *) getSectorIconName: (int)position {
    switch (wheelType) {
        case STYLE_FOOD_WHEEL:
            return [NSString stringWithFormat:@"style_wheel_icon%i.png", position];
        case CULTURE_FOOD_WHEEL:
            return [NSString stringWithFormat:@"culture_wheel_icon%i.png", position];
        case LIQUOR_DRINK_WHEEL:
            return [NSString stringWithFormat:@"liquor_wheel_icon%i.png", position];
        case BEER_DRINK_WHEEL:
            return [NSString stringWithFormat:@"beer_wheel_icon%i.png", position];
        case TEA_DRINK_WHEEL:
            return [NSString stringWithFormat:@"tea%i.png", position];
        case WINE_DRINK_WHEEL:
            return [NSString stringWithFormat:@"wine_wheel_icon%i.png", position];
        case SPANISH_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"spanish_wheel_icon%i.png", position];
        case EUROPEAN_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"european_wheel_icon%i.png", position];
        case NORTH_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"north_wheel_icon%i.png", position];
        case ASIAN_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"asian_wheel_icon%i.png", position];
        case TROPICAL_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"tropical_wheel_icon%i.png", position];
        case MIDDLE_CULTURE_WHEEL:
            return [NSString stringWithFormat:@"middle_wheel_icon%i.png", position];
        case VEGETARIAN_WHEEL:
            return [NSString stringWithFormat:@"vegetarian_icon%i.png", position];
        case SEAFOOD_WHEEL:
            return [NSString stringWithFormat:@"seafood_icon%i.png", position];
        case MEAT_WHEEL:
            return [NSString stringWithFormat:@"meat_icon%i.png", position];
        case BAKERY_WHEEL:
            return [NSString stringWithFormat:@"bakery_icon%i.png", position];
        case FLAVORS_WHEEL:
            return [NSString stringWithFormat:@"flavor_icon%i.png", position];
        case CHEESE_WHEEL:
            return [NSString stringWithFormat:@"cheese_icon%i.png", position];
        default:
            return @"style_wheel_icon";
    }
}

- (void) initWheelInfo {
    
    if (wheelType == STYLE_FOOD_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SEAFOOD", @"GASTRO-PUB", @"CAFE/BAKERY", @"BREWERY", @"FOOD TRUCK", @"PIZZERIA",
                        @"WINE BAR", @"SANDWICH", @"BREAKFAST", @"DINER", @"BURGER", @"FINE DINING", @"TAPAS", @"HIBACHI", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Go out and enjoy some oysters! Allergic to shellfish? You can still eat salmon in any style, Mediterranean fish, Moroccan style, baked, pan-fried, or even get some good sushi. If you need to rely on soy sauce or spicy mayo for flavor, most likely you just paid for bad rolls.",
                          @"These venues combine upscale cooking techniques with the casual dining experience of a pub. The main focus is to use fresh & local ingredients on their food and craft beers; To show the importance of sustainable, socially and ethically responsible foods. Click here to learn more about eating sustainably.",
                          @"A coffeehouse, coffee shop or café is an establishment that serves hot coffee, related coffee beverages, tea, and snacks. At a bakery you’ll find more bread, cookies, cakes, pastries, and pies. Some bistros will serve crepes, bagels, icecreams/gelato, etc. depending on the theme or cultural origin.",
                          @"A brewery is a business that makes and sells beer. Distinct sets of brewing equipment called a plant is usually displayed. Most breweries service American style food or appetizer style food such as wings, burgers, pretzels, fries, spinach dip, steamed vegetables, BBQ food, and more.",
                          @"Locate a food truck near you. A food cart is a mobile kitchen that is set up on the street to facilitate the sale and marketing of street food to people from the local pedestrian traffic. Food carts are often found in large cities throughout the world and can be found selling food of just about any varieties.",
                          @"Locate a pizzeria near you. The first known pizza shop opened in Port Alba in Naples and is still there today. Now there are many mom and pop pizzerias as well as franchises. Franchises incl. Domino’s Pizza, Pizza Hut, Papa Johns, Hungry Howies, Uno Pizza & grill and more.",
                          @"A wine bar (also known as a bodega) is a tavern-like business focusing on selling wine, rather than liquor or beer. They typically serve finger foods that complement the wine. Simple plates of meats, cheeses, nuts and olives are common.",
                          @"Sandwiches began as portable finger food in the Western world, consisting of slices of vegetables and meats. Eventually sub categories like the “Submarine Sandwich” emerged. Basically if you’re holding a long baguette with sliced meats or veggies, it’s now a “sub”. Also listed as “wedge”, “hoagie”, “hero”, “grinder”, or “baguette” it just depends where you live. Visit a sandwich shop near you.",
                          @"Locate a breakfast restaurant near you. Explore locally owned places. Some people love breakfast foods no matter what time it is. Breakfast franchises incl. IHOP, Keke’s Breakfast, Denny’s, Waffle House, First Watch and more. ",
                          @"A diner is less formal than a restaurant. Diners typically serve American food such as hamburgers, french fries, club sandwiches, and other quick and inexpensive fares. Much of the food is grilled, as early diners were based around a grill. They often serve hand-blended milkshakes and desserts such as pies. ",
                          @"A burger is a sandwich consisting of one or more cooked patties of ground meat (usually beef), placed inside a sliced bread roll or bun. Old menus from the 1920s to 1950s often listed a burger as a hamburger sandwich. Basically, if it doesn’t consist of ground meat, and you’re using sliced bread, it’s a sandwich.",
                          @"Fine dining restaurants are full service restaurants with specific dedicated meal courses. Décor of such restaurants features higher-quality materials, with establishments having certain rules of dining which visitors are generally expected to follow, often including a dress code.Click here for more info on fine dining etiquette",
                          @"Tapas are a variety of small savoury Spanish dishes, often served as a snack with drinks, or with other tapas as a meal. To ìtapearî, going from bar to bar for drinks and tapas, is an essential part of the social culture of Spain. Recent american restaurants are popping with this same dining style, creating small savoury dishes that are not necesarily spanish. Visit a tapas style restaurant near you.",
                          @"Hibachi is a style of Japanese cooking where foods are prepared over a hot open grill. Many restaurants have a group setup where customers surround one grill and the chef entertains with their cooking. Other restaurants will have a private setup where each dining table has their own grill and the customers cook themselves.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"https://www.etiquettescholar.com/etiquette_scholar/dining_etiquette.html",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       @"http://www.sustainabletable.org/873/eating-sustainably",
                       nil];
        
    }
    else if (wheelType == CULTURE_FOOD_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SPANISH", @"EUROPEAN", @"NORTH AMERICA/OCEANIC", @"ASIAN CUISINE", @"   TROPICAL/CARIBBEAN   ", @"MIDDLE EAST & AFRICAN", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR,  nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Look for any of the following restaurants: Ecuadorian, Peruvian, Ecuadorian, Brazilian, Mexican, Colombian, or Spaniard style resaurant. All countries have their own style of paellas, arepas, empanadas and plantain sides. Still can’t decide? Spin our “Latin American” wheel to narrow down your choices.",
                          @"Locate a German, Italian, Polish, Greek, Belgian, Swedish, Irish, French restaurant in your area. Still can’t decide? Spin our European Wheel to narrow down your choices.",
                          @"American cuisine is known for the Hamburger, French Fries, Sandwiches, turkey and apple pies. However like other countries, each region has its own influence such as creole, cajun, tex mex, and more, see “North American Wheel” for a breakdown. New American cuisine refers to a type of fusion cuisine which assimilates flavors from the melting pot of traditional American cooking techniques mixed with flavors from other cultures and sometimes molecular gastronomy components.",
                          @"Asian cuisine includes several major regional cuisines: East Asian, Southeast Asian, South Asian, Central Asian, and Middle Eastern. Locate a Chinese, Thai, Japanese, Thai, Korean, Philippine, Vietnamese, Mongolian restaurant and more. Still can’t decide? Spin Asian Wheel to narrow down your choices.",
                          @"Well known Caribbean cuisine includes key lime pie, barbecued ribs served with guava sauce, chicken kabobs, jerk chicken, and coconut shrimp. Still can’t decide? Spin our Tropical/Caribbean wheel to narrow down your choice.",
                          @"The cuisine of the Middle East generally falls under the category of “Mediterranean” cooking, such as olive oil, fresh vegetables and fruit, cheese and moderate amounts of fish and poultry. The various cuisines of Africa use a combination of locally available fruits, cereal grains and vegetables, as well as milk and meat products, and do not usually get food imported.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == LIQUOR_DRINK_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"  BRANDY", @"  TEQUILA", @"  GIN", @"  VODKA", @"  RUM", @"  WHISKEY", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Brandy is a strong alcoholic spirit distilled from wine or fermented fruit juice. Some brandies are aged in wooden casks, some are coloured with caramel colouring to imitate the aging. Others are produced with both combinations. Common drinks incl: B&B, Brandy Cocktail, Sidecar, Metropolitan, Vieux Carre, Tom & Jerry, etc.",
                          @"Tequila is a regionally specific name for a distilled beverage made from the blue agave plant, primarily in the area surrounding the city of Tequila, Mexico.Common drinks incl: Long Island Iced Tea, Paloma, Matador, Margarita, Tequila Sunrise, etc.",
                          @"Gin is a spirit which derives its predominant flavour from juniper berries. Common drinks incl: Gin and Tonic, Gimlet, Martini, Negroni, Monkey Gland, Singapore Sing, Corpse Reviver, Aviation Cocktail, etc.",
                          @"Vodka is a distilled beverage composed primarily of water and ethanol, sometimes with traces of impurities and flavorings. Common drinks incl: Cosmopolitan, Bloody Mary, Lemon Drop, Moscow Mule, Screw Driver, Vodka Tonic, Vodka Martini etc.",
                          @"Rum is a distilled alcoholic beverage made from sugarcane byproducts, such as molasses, or directly from sugarcane juice, by a process of fermentation and distillation.\" Common drinks incl: Cuba Libre, Daiquiries, Dark n’ Stormy, Mojito, Mai Tai, Rum Old Fashioned, Rum & Coco, etc.",
                          @"Whisky or whiskey is a type of distilled alcoholic beverage made from fermented grain mash. Various grains are used for different varieties, including barley, corn, rye, and wheat.Common drinks incl: Irish Coffee, Jack and Coke, Manhattan Cocktail, Old-fashioned, Whiskey Sour etc.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == BEER_DRINK_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"INDIA PALE ALE", @"WHEAT", @"PILSNER", @"HEFEWEIZEN", @"CIDER", @"SAISON", @"AMERICAN BROWN ALE", @"GOSE", @"LAGER", @"BELGIAN", @"AMERICAN PALE ALE", @"BARLEY WINE", @"STOUT", @"PORTER", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"IPA’s are a hoppy beer style within the broader category of pale ale, commonly imported to East India in the 18th century.  They can be both strong and bitter. The term IPA is commonly used for low-gravity beers of 4-6%. Double IPAs (aka Imperial IPAs) are a stronger, very hoppy with an alcohol content above 7.5% by volume.",
                          @"Wheat beer is a beer, usually top-fermented, which is brewed with a large proportion of wheat relative to the amount of malted barley. The two main varieties are Weissbier and Witbier; minor types include Lambic, Berliner Weisse and Gose. ",
                          @"Pilsner is a type of pale lager, with a strong hop flavor, originally brewed at Pilsen in Bohemia (now the Czech Republic). They are medium- to medium-full bodied and are characterized by high carbonation and tangy Czech varieties of hops that impart floral aromas and a crisp, bitter finish. They’re often the most difficult beers to brew.",
                          @"Hefeweizen is a type of wheat beer, however a Hefeweizen refers to an unfiltered wheat beer with yeast. “Hefe” means yeast in German and “Weizen” means wheat. It’s the wheat that defines it – Hefeweizens are top-fermented and use significant amounts of malted wheat.  ",
                          @"Although technically ciders are fermented fruit juices, it becomes an alcoholic beverage when the you add sugar or extra fruit before a second fermentation, increasing the alcoholic content of the resulting beverage. Apple ciders are the more popular choice.",
                          @"Saison is a pale ale that is generally around 5-8% ABV, highly carbonated, fruity, spicy, and often bottle conditioned. They tend to be semi-dry with many only having touch of sweetness. ",
                          @"Of British origin, these ales generally have a good balance of malt and hops.Brown ale is a style of beer with a dark amber or brown colour. The bitterness and hop flavor has a wide range and the alcohol is not limited to the average either. Average alcohol by volume (abv) range: 4.0-8.0%",
                          @"Gose is an old German beer style from Leipzig and is unfiltered wheat beer made with 50-60% malted wheat. This creates a cloudy yellow color and provides a refreshing crispness and twang. A Gose will sometimes be laced with various flavored and colored syrups. Also known as Sour beer.",
                          @"Lager is a type of beer that is conditioned at low temperatures, normally at the brewery. It may be pale, golden, amber, or dark. They tend to be smooth and mellow. Lagers have “bottom-fermenting” yeasts, which ferment at the bottom of a fermentation container. ",
                          @"Belgian beers are cloudy pale beers that are brewed with some unmalted wheat along with the regular malted barley, giving this beer its wheaty flavor and thick creamy texture. They are traditionally flavored with coriander and orange peel and have a very low bitterness. Ex incl. Allagash White, Blue Moon Belgian White, or Blanche de Chambly. ",
                          @"Of British origin, these ales generally have a good balance of male and hops. American versions tend to be cleaner and hoppier, while British tend to be more malty, buttery, aromatic and balanced. Average alcohol by volume (abv) range: 4.0-7.0% ",
                          @"Despite its name, a Barleywine (or Barley Wine) is very much a beer. It's one of the strongest of the beer styles. Expect anything from an amber to dark brown colored beer, with aromas ranging from intense fruits to intense hops.",
                          @"A stout is a dark beer made using roasted malt or roasted barley, hops, water and yeast. Stouts were traditionally the generic term for the strongest or stoutest porters, typically 7% or 8%, produced by a brewery. ",
                          @"Porter is a dark style of beer developed in London from well-hopped beers made from brown malt. All stouts are types of porter. But not all porters are stouts. Only the stronger ones are. For it’s full history and description click here.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == TEA_DRINK_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"TISANE",@"WHITE TEA",@"GREEN TEA",@"BLACK TEA",@"OOLONG",@"PU'ERH TEA", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:@"The advantage of tisanes is that they are generally caffeine-free and gentle on the body. Some tisanes are imbibed for a specific purpose. Dandelion tea is an effective diuretic, and kava tea is used to help relieve stress. See an experienced herbalist to determine which tisane is right for your condition. Don't attempt to self-treat, as some herbal combinations can either cancel each other out or become too strong.",
                          @"White tea undergoes the least processing of all teas. Traditionally cultivated in China, white tea was picked only a few days out of the year./n Benefits: Reduces tooth decay, reduces cardiovascular disorders, prevents cancer, protects skin, helps with weight loss, has antibacterial and antiviral properties.",
                          @"Because they are unoxidized, green teas keep their vital color. To prevent oxidization, the leaves are heat processed to eliminate the enzyme responsible for oxidization./n Benefits: It is loaded with powerful antioxidants and boosts your metabolism.",
                          @"Known as red tea in China, black tea leaves are fully oxidized, making them brew up strong, bold, and often malty. Unlike green tea, black tea eliminates all antioxidants existing in it once processed./n Benefits:  Low in caffeine content which is great for circulation.",
                          @"Oolong, also spelled Wu Long, teas are semi-oxidized. This tea richer in antioxidants and vitamins, more than black tea and green tea./n Benefits:  Helps sharpen thinking skills and improve mental alertness. It is also used to prevent cancer, tooth decay, osteoporosis, and heart disease.",
                          @"Puíerh is a fermented style of tea. Most puíerh is sold in a pressed cake form. Pu'er teas yield a dark, hearty brew that is low in caffeine./n Benefits: This tea has a lower antioxidant content than white or green tea, but Chinese people believe it aids in weight loss, reduces serum cholesterol, and has cardiovascular protection."
                          , nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == WINE_DRINK_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"PINOT NOIR", @"MERLOT", @"ROSE", @"MALBEC", @"CABERNET SAUVIGNON", @"SHIRAZ", @"SPARKLING", @"RIESLING", @"ZINFANDEL", @"CHARDONNAY", @"PINOT GRIS", @"SAUVIGNON BLANC   ",@"SANGRIA", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, BLACK_COLOR, BLACK_COLOR, BLACK_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Pinot Noir is over 1000 years older than Cabernet Sauvignon. Pinot Gris/Grigio and Pinot Blanc are simply color mutations of Pinot Noir. Germany is the 3rd largest producer of Pinot Noir after France and the US. Pinot Noir is commonly called Spätburgunder in Germany. Its often noted for its natural ability to be lighter than other red wines. Fruitier versions make a great match with salmon or other fatty fish, roasted chicken or pasta dishes; bigger, more tannic Pinots are ideal with duck and other game birds, casseroles or, of course, stews like beef bourguignon. Also pairs well with Gruyere and Taleggio cheese.",
                          @"Merlot is a dark blue-colored wine grape that is used as both a blending grape and for varietal wines. Red fruits, easy tannins and a soft finish are the characteristics of Merlot wine. Pairs well with chicken and other light meats as well as lightly-spiced dark meats.  ",
                          @"A rosé is a type of wine that incorporates some of the color from the grape skins, but not enough to qualify it as a red wine. It may be the oldest known type of wine. Pairs well with light salads, light pasta and rice dishes, especially with seafood, raw and lightly cooked shellfish and grilled fish and goats' cheeses. ",
                          @"Malbec is a purple grape variety used in making red wine. The grapes tend to have an inky dark color and robust tannins. It’s earthier flavors make it pair well with a brisket and lamb or cured beef as a starter.  Manchego, Iberico, Taleggio and Cashel Blue cheeses pair well also.",
                          @"These wines are generally bolder therefore one of the most dry red wines. This grape is much more tannic, meaning it will give your mouth that drying sensation. Pairs well with Swordfish and tuna, brussel sprouts, broccoli rabe, grilled radicchio, kale or spinach. Gorgonzola, Gouda, Cheddar, Vella Jack, mild blue cheeses and aged cheeses.  ",
                          @"Syrah and Shiraz are the exact same wine. Syrah is a wine with a large amount of tannins, and it is known to be full-bodied, which means it feels heavy and will dry your mouth. Pairs with Briskets, Lamb, Beef Stews and Chili. Shiraz is not a good cheese wine. But if needed, go with softer, creamier cheeses like Camembert, Gruyere or even a smoked Cheddar. ",
                          @"Sparkling wine is a wine with significant levels of carbon dioxide in it, making it fizzy. The best known example of a sparkling wine is Champagne and Prosecco. Pairs well with salty foods such as chips, sausages, smoked salmon, caviar etc.",
                          @"Riesling is a white grape originating in Germany. It is an aromatic grape variety displaying flowery, almost perfumed, aromas which make it sweet, but there are also acidic versions.Sweet versions pairs with: Chicken, Shrimp, or Pork. Dry versions pair with Halibut, Broccoli and roasted root Vegtables.",
                          @"Zinfandel is lighter in color than both Cabernet Sauvignon and Merlot. However, although a light-bodied red wine like Pinot Noir, Zin's moderate tannin and high acidity make it taste bold. Generally speaking, most Zinfandel wines have higher alcohol levels ranging from about 14 – 17% ABV.",
                          @"Chardonnay is a green-skinned grape variety used in the production of white wine. Bolder styles of Chardonnay pair with bold, creamy dishes like mushroom risotto, lobster bisque and chicken, leek and ham pie. There are both oak and unoaked styles of Chadonnay.",
                          @"Pinot gris/Pinot Grigio/Grauburgunder is a white wine grape variety of the species Vitis vinifera. The primary fruit flavors are lime, lemon, pear, white nectarine and apple.With its zesty and refeshing acidity it pairs well with fresh vegetables, raw fish and lighter meals. Fish and shellfish are classic pairing partners with Pinot Gris.",
                          @"is a green-skinned grape variety that originates from the Bordeaux region of France.Pairs well with white meats as well as white fish e.g. tilapia, halibut. Look for briny and sour cheeses like Goat’s milk cheese, Yogurt, and Crème fraîche. ",
                          @"Of spanish origin, a Sangria is a red wine mixed with lemonade, fruits, spices, or sweeteners. In traditional sangrias, the fruit is normally sliced and soaked in wine overnight, the other ingredients are added the next day. Sangria as an iced drink, was reintroduced in the U.S. by the late 1940s through Hispanic Americans and spanish restauants.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
        
        
    }
    else if (wheelType == SPANISH_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SPAIN", @"COLOMBIAN", @"MEXICAN", @"BRAZILIAN", @"ECUADORIAN", @"PERUVIAN", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Spain is commonly known for tapas style dining. Their famous dishes incl: Paella (a rice dish topped with vegetables, meats, saffron, runner beans and butter beans), Gazpacho, Tortilla Española (Spanish Omlette), Gambas/Pollo al Ajillo (Garlic Prawns/Chicken), Patatas bravas, and more.",
                          @"Colombians are known for their Patacones (fried plantains), Bandeja Paisa (big platter of beans, rice, fried eggs, chorizo, and pork rind), Pandebono (egg and cheese bread), Fritanga (meats with fried plantains, chicharrones, and yellow potatoes with aji sauce), Arepas and more.  ",
                          @"Unlike Spanish cuisine, many Mexican dishes contain some of the hottest peppers in the world, and use spices like chili powder, garlic, and cloves. They are known for their corn tortillas and mole sauce. Popular dishes incl. Tacos al pastor and Tamales (Steame cornmeal paste filled with any meats).",
                          @"In general, root vegetables are commonly used. Mangos, papayas, guavas, granadillas and pineapples are all favourites. They’re known for Baião de Dois, Bobó de Camarão (shrimp in a purée of manioc), Caldeirada (fish strew), Carne-de-sol, Churrasco (grilled beef), etc.",
                          @"Meats such as cuy (guinea pig) are popular in the mountainous regions. Yuca is a staple in the rainforest area. Near the coast Ceviche (raw seafood cooked in lime and tomato sauce) is common. Other popular dishes incl. Fritada (pork fried in pork fat), Hornado and choclo (roast pig and Andean corn), Humitas, and Encebollado de Pescado (onioned fish soup).",
                          @"Peruvian cuisine is influenced by their indigenous roots, and cuisines brought by European & Asian immigrants. Staples of Peru are corn, potatoes, Quinoa, and legumes. They’re known for their Ceviche (raw fish marinated in citrus juice), Cuy (guinea pig), Lomo Saltado (Beef in soy sauce and onions), Anticuchos (skewered meats) and more.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == EUROPEAN_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"GERMAN", @"FRENCH", @"IRISH", @"SWEDISH", @"BELGIAN", @"GREEK", @"POLISH", @"ITALIAN", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Germany is known for their Sauerkraut (fermented cabbage), Bretzel (soft, white pretzels), and Wurst (sausage). There are more than 1,500 types of Wurst made there. Popular dishes incl. Rouladen (thinly sliced meat wheels filled), Kasespatzle (Soft egg noodle w cheese), Sauerbraten (pickled pot roast), etc.",
                          @"France is known some of the world's best wines and cheeses. In France platers of cheeses are typically served after the main course and before desert. Popular dishes incl. Soupe à l'oignon (French Onion Soup), Coq au vin (Rooster in wine), Beef bourguignon, Ratatouille (stewed vegetables) and more.",
                          @"Modern Ireland is known for their Irish Stew and Shepards Pie (meat and vegetables, topped with potato). They’re also known for their Soda Bread, Shellfish, Boxty (Potatoe dumpling, pancake), and Coddle (the name comes from the slow simmering of leftovers in a one-pot stew).",
                          @"Swedish cuisine is known for meatballs and Lingonberries. Husmanskost is the Swedish equivalent of country-style cooking. Popular dishes incl. Raggmunk (potatoe pancake), Wallenbergare (ground beef with cream and eggs, coated in breadcrumbs), Pickled Herring, and Gravad lax (Cured Salmon).",
                          @"Beligum is known for chocolate, waffles, fries, varieties of beers, and baked goods. Popular dishes incl. Spaghetti Bolognese, Brussels waffles (usually served with ice cream, fruit or other sweet spreads), Carbonade Flamande (beef stew), and Sole Meunière (classic fish and chips).",
                          @"Find a Greek restaurant near you. Important ingredients incl. olives, cheese, eggplant, zucchini, lemon juice, herbs, bread and yoghurt. They are not known for eating big breakfasts. In rural areas, the main meal is eaten around 1:00 or 2:00PM. The country itself relies on seafood and fish.",
                          @"Polish cuisine is known for their use of cabbage e.g. Sauerkraut and sausages. Their herbs and spices incl. marjoram, dill, caraway seeds & parsley. Popular dishes are Bigos (finely chopped meats, stewed with Sauerkraut), Kielbasa (polish sausage), Pierogi (Polish dumplings), Klopsiki (meatloaf), etc.",
                          @"North italy cooks more rice based dishes, while south italy uses pasta. Both use a lot of tomatoes and pecorino cheese. Best known for their pizza, lasagnas, Prosciutto, Osso buco alla Milanese, Gelato, & Tiramisu. “Al Dente” pasta literally translates to “to the tooth,” it describes pasta that are cooked to be firm to the bite.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == NORTH_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SOUTHERN", @"FRENCH CANADIAN", @"SEAFOOD", @"BARBECUE FOOD", @"CLASSIC", @"HAWIIAN", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Southern food is synonymous with fried foods, grits and greens such as black-eyed peas, collard greens, turnips etc. Popular dishes incl. biscuits and gravy, Mac and Cheese, Chicken and Waffles, mashed potatoes, etc. Also try an American diner, or Louisiana Creole style restaurant where Gumbos, Jumbalayas and Catfish is common.",
                          @"Canada is known for Bacon and maple syrup. However the eastern provinces are known for their Poutine (French fries, gravy and cheese curds), BeaverTails (flattened donut without a hole), Butter Tarts, Nanaimo Bars, Split Pea Soup etc. Stews, BBQ, and Asian style dishes originated in the Western areas e.g. Calgary-style Ginger Beef, Tourtiere (meat pie) etc. ",
                          @"Shellfish and finfish are common in the northeastern coast of the U.S. Bluefish filets, Clambake, lobster rolls and grilled oysters are popular in the East Coast. Sardines, Alaskan Salmon, Halibut, Crabs and Cod are common in the West Coast. Shrimp and catfish are a staple in the South e.g. Shrimp and grits, Gumbo and Jambalaya.",
                          @"Locate a BBQ place near you. Barbecue varies by region, with four main styles. Memphis is known for pulled pork-shoulder in sweet tomato sauce. North Carolina smokes a whole hog in a vinegar. Kansas City natives eat ribs in a dry rub, and Texans use mostly beef (famous for mesquite-grilled briskets). You can also explore Korean BBQ, Mongolian BBQ, and Argentinian BBQ.",
                          @"Classic american dishes are known for being homey. Popular dishes incl. Waffles, pancakes, hashbrowns, home fries, scrambled eggs, cheeseburgers, meatloaf, Pies, pot roast, corned beef hash, sandwiches, tuna salad, egg salad, grilled cheese, casseroles, and more. Try any breakfast place or diner to find these foods.",
                          @"Hawaii is famous for their fruit such as pineapple and passion fruit. Many traditional Hawaiian dishes were originally brought over from Pacific Polynesian islands. Popular dishes incl. Poi (starch dish), Laulau (made with pork, wrapped in layers of taro leaves), Kalua pig, Poke (Hawaiian version of sashimi), Lomi Salmon, etc.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == ASIAN_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"MONGOLIAN", @"VIETNAMESE", @"PHILIPPINE", @"KOREAN", @"INDIAN", @"CHINESE", @"THAI", @"JAPANESE", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"The extreme continental climate forced the Mongolian cuisine to primarily consist of dairy products, meat, and animal fats. Use of vegetables and spices are limited. The meats are from domesticated sheep, horses and yaks. Meat is mostly cooked or used in soups and dumplings.",
                          @"Common ingredients include fish sauce, shrimp paste, soy sauce, lemongrass, ginger, Vietnamese mint, long coriander, Saigon cinnamon, bird's eye chili, lime, and Thai basil leaves. Popular dishes are PH? (rice noodles in a broth), BÚN CH? (grilled pork sausage patties), G?I CU?N (SPRING ROLLS), BANH CHUNG / BANH TET (sticky rice cake wrapped in banana leaf)",
                          @"Dishes range from the very simple, e.g. fried salted fish and rice, to the complex paellas and cocidos created for fiestas of Spanish origin. Popular dishes include: lechón (whole roasted pig), longganisa (Philippine sausage), mechado (larded beef in soy and tomato sauce), and more.",
                          @"Traditional Korean meals have a number of side dishes that accompany steam-cooked short-grain rice. Kimchi is almost always served at every meal.  Commonly used ingredients include sesame oil, doenjang, soy sauce, salt, garlic, ginger, pepper flakes, gochujang and cabbage.",
                          @"If you don’t like hot/spicy dishes you’re better off spinning again. Or start small and read this beginners guide, there are milder choices for you.Click here",
                          @"Challenge yourself by finding a TRADITIONAL sit in restaurant. There is a difference between American Chinese and real Chinese cuisine. For ex: Nobody eats cheese in China, so crab ragoon is American. For more mythical chinese dishes click here.",
                          @"Common flavors in Thai food come from garlic, galangal, coriander/cilantro, lemon grass, shallots, pepper, kaffir lime leaves, shrimp paste, fish sauce, and chilies. Popular dishes incl. Tom Yum Goong (Spicy Shrimp Soup),  Pad Thai (Thai style Fried Noodles), Tom Kha Kai (Chicken in Coconut Soup) and more.",
                          @"Traditional Japanese food usually consists of steamed white rice, served with miso soup and other side dishes (fish or pickled vegetables). Many foods are seared, boiled or eaten raw with minimal seasoning (they never use garlic, chile, and oil). Click here to read about “Things to Avoid” while eating here.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"http://www.houstonpress.com/restaurants/here-eat-this-a-beginners-guide-to-indian-cuisine-6409314",
                       @"http://dc.eater.com/2011/10/31/6640509/10-chinese-dishes-that-real-chinese-people-dont-eat",
                       @"",
                       @"http://www.savoryjapan.com/learn/culture/dining.etiquette.html",
                       nil];
    }
    else if (wheelType == TROPICAL_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"HAITIAN", @"CUBAN", @"JAMAICAN", @"PUERTO RICAN", @"BAHAMAS", @"DOMINICAN", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Haitian cuisine is kréyol cuisine, a mixture of French, African, Spanish and indigenous cooking methods. Rice, beans and a liberal use of peppers are a staple here. Popular dishes incl. Krevet (Creole shrimp), Lambi (Boiled conch), Boeuf á la Haïtienne (Beef with tomatoes and peppers), etc.",
                          @"Most Cuban cooking uses garlic, cumin, oregano, and bay laurel leaves. Many dishes use a sofrito as their base. Popular dishes incl. Cubano (cuban sandwich with ham & cheese), Medianoche (similar to cubano but with sweet bread), Ropa Vieja (Cuban style shredded beef), Chicken Stew with olives and capers, etc.",
                          @"Jerk pork or chicken is Jamaica's national dish. Pork or chicken is seasoned with Scotch Bonnet peppers along with thyme, onions and scallions. Popular Jamaican dishes include curry goat, fried dumplings, ackee and saltfish (cod), \"jerk\", steamed cabbage and \"rice and peas.\"",
                          @"Although Puerto Rican cooking is similar to Spanish, Cuban and Mexican cuisine, it also has African, Taíno influences. They use green sofrito as a base. Popular dishes incl. Puerto Rican rice and Pigeon peas, Alcapurrias, Mofongo (mashed plantain filled with meat), Pastelón (layered casserole of platanos), etc.",
                          @"Seafood is the staple of the Bahamian diet. Peas are a popular ingredient that is used in most of their soups. Popular dishes incl. Conch soup (large type of ocean mollusc) , Tropical Sea Snail served with raw lime juice and spices, Jerk Chicken, and more. A common beverage is coconut water.",
                          @"Dominican food is known for using grains, e.g. rice, corn, wheat; beans, potatoes, yuca, or plantains. Popular dishes incl. Green Pigeon Pea Rice, Sancocho (7-Meat Stew), Mangú (Plantain Mash served with eggs, fried Dominican “salami” and Fried Cheese), Pollo Guisado (Braised Chicken), etc.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    else if (wheelType == MIDDLE_CULTURE_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"NORTH AFRICAN", @"MOROCCAN", @"SOUTH AFRICAN", @"ETHIOPIAN", @"NIGERIAN", @"TURKISH", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"In North African cuisine, the most common staple foods are wheat e.g. couscous, fish, seafood, goat, lamb, beef, dates, almonds, olives etc. Because the region is predominantly Muslim, halal meats are eaten. Most dishes are spiced with cumin, ginger, paprika, cinnamon and saffron. North Africa incl. Moroccan, Algerian, Tunisian, Libyan, and Mauritanian restaurants.",
                          @"Couscous is their old national delicacy. Beef is the most commonly eaten red meat, usually eaten in a tagine with a wide selection of vegetables. Chicken is also very commonly used in tagines, or roasted. Typical dishes include B’ssara (bean soup), Kefta tagine (rolled beef or lamb), Zaalouk (cooked vegtable salads), B’stilla (pigeon meat pie), etc.",
                          @"Traditional African food is generally cooked over an open fire or in a three-legged pot (or potjie). Typical South African dishes include tripe, morogo (wild spinach), chakalaka (spicy relish), amadumbe, and the ubiquitous boerewors roll. Grilled chicken feet and heads (known as walkie-talkies) are a popular dish in rural South Africa.",
                          @"Ethiopian food is mostly served in a communal platter, designed for sharing. Popular dishes include Injera (large spread in a thin spongy sourdough flatbread), Wat (Ethiopia’s version of curry), Berbere (spice blend), Doro wat (chicken based stew), Tibs (marinated beef sauteed with vegetables), and more.",
                          @"West African cuisines, it uses spices and herbs with palm or groundnut oil to create deeply flavoured sauces and soups often very spicy hot with chili peppers. Popular dishes incl. Jollof Rice, Akara (Deep fried Bean cakes), Suya (skewers of spiced cuts of meat), Moin moin (african version of a tamale), Edikangikong, etc.",
                          @"Frequently used ingredients in Turkish specialties include: lamb, beef, rice, fish, eggplants, green peppers, onions, garlic, lentils, beans, zucchinis and tomatoes. Popular dishes incl. Lentil or Black Cabbage soup, Baklava (Pistachico pastry), Meze (a range of cold appetizers) , Kebap (charcoal grilled meats), Mantı (turkish ravioli), Dolma and sarma etc.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    } else if (wheelType == SEAFOOD_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SALMON", @"CRAB", @"SCALLOPS", @"HALIBUT", @"OYSTERS", @"TILAPIA", @"CLAMS", @"SHRIMP", @"OCTOPUS", @"MUSSELS", @"TUNA", @"LOBSTER", nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Fish such as salmon is a little higher in fat. It includes all of the essential amino acids for human health, making it a complete protein source. The American Heart Association recommends aiming for at least two 3.5-oz servings per week.",
                          @"Crabs are low in calories and saturated fats, but increases cholesterol and blood pressure if over consumed (the sea water they soak up increases sodium which affects blood pressure). Consider opting for blue or Dungeness crab meat, both have less than 340 milligrams of sodium.",
                          @"Scallops are often served seared or baked, and offer more than 80 percent protein. They're also a good source of magnesium, potassium, and B12. They also contain benefits for your cardiovascular system. Preparing them in butter is what decreases their health benefits.",
                          @"This fish grows and matures slowly (living as long as 50 years), so it is susceptible to overfishing. Contains, B12, B6, and folic acid that lower levels of homocysteine (a compound that can damage artery walls). It’s also packed with magnesium, a natural calcium channel blocker, and contains Triglycerides.",
                          @"These mollusks pack vitamin E and C.  They also contain various other minerals that help our immune system. They reduce the plaque that accumulates on arteries, also good for the eyes, bone health and full of B12. The zinc found in oysters is why they are considered an age-old aphrodisiac!",
                          @"Tilapia is lower in omega-3 levels than fatty fish like salmon (tilapia 135m/salmon 2,000m). Farmed tilapia may have even less than wild tilapia because fish acquire omega-3s by eating aquatic plants and other fish. Despite these problems, white fish such as tilapia is high in protein and low in fat.",
                          @"A 3oz serving of steamed clams provides 22 grams of protein, or 44 % of the daily value. Although they are potentially high in toxic contaminants, they contain more iron than beef, more protein than oysters and scallops, but roughly the same protein and fat content as chicken.",
                          @"Avoid farmed shrimp due to health and environmental impacts. Despite the higher cholesterol levels, shrimp contains minimal saturated fat and no trans fat. Both fats increase “bad” cholesterol. It’s also an Excellent source of selenium (antioxidant), B12, phosphorus, choline, copper and iodine.",
                          @"Although it is not in a shell, Octopus still belongs in the mollusk family. It is rich in B12, Iron (vital for the hemoglobin formation), copper, protein, B6, Phosphorus, magnesium, B5, and reduces hypertension.",
                          @"Mussels help prevent asthma, reduce arthritis, helps circulation, promotes heart health, and prevents anemia. Contains 340% of recommended daily value of B12, 30% of Vitamin C, and contain mucopolysaccharides that aid in maintaining a smooth complexion and skin elasticity.",
                          @"Tuna contains 150mg of omega-3 fatty acids per 4oz serving. Canned tuna fish has less mercury than fresh or frozen tuna steaks (generally speaking, smaller fish—will accumulate less mercury). Eating 3 ounces of tuna steak boosts your protein intake by 24 grams. Also contains B12 and selenium.",
                          @"Lobster is a rich source of copper and selenium, also contains zinc, phosphorus, vitamin B12, magnesium, vitamin E and a small amount of omega-3 fatty acids.  Lobster does contain cholesterol, but no enough to deem harmful. Is not a significant source of saturated fat.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"http://allrecipes.com/recipes/416/seafood/fish/salmon/?nternalSource=hn_carousel%2002_Quick%20Salmon%20Dinners&referringId=411&referringContentType=recipe%20hub&referringPosition=carousel%2002",
                       @"https://www.thedailymeal.com/best-recipes/imitation-crab",
                       @"https://www.yummly.co/recipes/vegetarian-scallops",
                       @"http://www.eatingwell.com/recipes/19175/ingredients/fish-seafood/fish/halibut/",
                       @"http://allrecipes.com/recipes/437/seafood/shellfish/oysters/",
                       @"http://allrecipes.com/recipes/417/seafood/fish/tilapia/",
                       @"http://www.bonappetit.com/recipes/slideshow/26-clam-recipes-steaming-grilling-needs",
                       @"https://www.realsimple.com/food-recipes/recipe-collections-favorites/quick-easy/easy-shrimp-recipes",
                       @"https://cooking.nytimes.com/tag/octopus",
                       @"http://allrecipes.com/recipes/439/seafood/shellfish/mussels/",
                       @"http://allrecipes.com/recipes/411/seafood/fish/?internalSource=hub%20nav&referringId=421&referringContentType=recipe%20hub&referringPosition=4&linkName=hub%20nav%20exposed&clickId=hub%20nav%204",
                       @"http://www.eatingwell.com/recipes/19176/ingredients/fish-seafood/shellfish/lobster/",
                       
                       nil];
    } else if (wheelType == VEGETARIAN_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"EGGPLANT", @"KALE", @"SWEET POTATO", @"MUSHROOMS", @"EGGS/DAIRY", @"BEANS/TOFU", @"BUTTERNUT     SQUASH", @"AVOCADO", @"BROCCOLI", @"SPINACH", @"CALIFLOWER", @"ZUCCHINI" ,nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, BLACK_COLOR, BLACK_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Eggplant is a very good source of dietary fiber, vitamin B1 and copper. Also a good source of manganese, vitamin B6, niacin, potassium, folate and vitamin K.",
                          @"One cup of kale has only 36 calories, 5 grams of fiber and 0 grams of fat. It’s high in Iron, Vitamin K, and antioxidants. Also a source of Vitamins, A, C and calcium. Per calorie, kale has more calcium than milk.",
                          @"Sweet potato has over 400% of your daily needs for vitamin A as well as fiber. They contain more grams of natural sugars than a regular potato, however these sugars are released slowly into the bloodstream (reducing sugar spikes) and have more nutrients (Vitamins B6. C, D, iron, magnesium, potassium, etc.).",
                          @"Mushrooms are rich in the antioxidant called selenium. They’re also good source of chitin and beta-glucan, (fibers that lower cholesterol), Vitamins B, Copper, & potassium. The most common types in stores are: shiitake, portobello, crimini, button/white mushroom, oyster, enoki, beech, maitake.",
                          @"One egg offers 6 grams of protein for just 70 calories. Dairy products, like milk, yogurt, cottage cheese and ricotta cheese are good lean sources of protein. Think outside of breakfast and add a hard-boiled egg to your salad at lunch.",
                          @"One half cup of beans and lentils contains as much protein as an ounce of broiled steak. They are loaded with fiber and keep you full for hours. Examples incl. pinto beans, edamame, chickpeas/garbanzo beans, pistachios etc.",
                          @"This squash is native to the Western Hemisphere. Can be substituted in most recipes that call for pumpkin. It's loaded with vitamin A (1 cup of cooked squash has 457% of the recommended daily allowance). It’s also a good source of fiber, potassium, and magnesium.",
                          @"The avocado is a tree that is native to South Central Mexico, classified as a member of the flowering plant family Lauraceae. Regular consumption helps maintain healthy cholesterol levels, maintains eye tissues, prevent osteoporosis, lower risk of cancer and depression, provide antioxidants and improve digestion.",
                          @"It is a very good source of dietary fiber, pantothenic acid, vitamin B6, vitamin E, manganese, phosphorus, choline, vitamin B1, vitamin A (in the form of carotenoids), potassium and copper. Also a good source of vitamin B1, magnesium, omega-3 fatty acids, protein, zinc, calcium, iron, niacin and selenium.",
                          @"Low in fat and even lower in cholesterol, spinach is high in niacin and zinc, as well as protein, fiber, vitamins A, C, E and K, thiamin, vitamin B6, folate, calcium, iron, magnesium, phosphorus, potassium, copper, and manganese.",
                          @"One serving of cauliflower contains 77 percent of the recommended daily value of vitamin C. It's also a good source of vitamin K, protein, thiamin, riboflavin, niacin, magnesium, phosphorus, fiber, vitamin B6, folate, pantothenic acid, potassium, and manganese.",
                          @"Zucchini/Summer Squash has a good amount of potassium, antioxidants, 35mg of vitamin C and A. It is 95% water, making it naturally low in calories. A medium zucchini, for example, contains just 33 calories. Can be consumed raw or sautéed.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"https://www.pinterest.com/explore/vegan-eggplant-recipes/",
                       @"http://www.amuse-your-bouche.com/33-vegetarian-kale-recipes/",
                       @"http://www.delish.com/holiday-recipes/thanksgiving/g622/sweet-potato-recipes/",
                       @"http://www.amuse-your-bouche.com/40-vegetarian-mushroom-recipes/",
                       @"http://www.cookinglight.com/food/vegetarian/vegetarian-egg-recipes#avocado-egg-salad-sandwiches-pickled-celery-2",
                       @"http://www.goodhousekeeping.com/food-recipes/healthy/g2319/vegetarian-tofu-recipes/",
                       @"https://draxe.com/butternut-squash-recipes/",
                       @"https://www.californiaavocado.com/vegetarian",
                       @"http://cookieandkate.com/tag/broccoli/",
                       @"http://www.recipe.com/recipes/vegetarian/spinach/",
                       @"http://www.bonappetit.com/recipes/slideshow/these-38-recipes-want-to-make-us-eat-all-the-cauliflower-all-the-time",
                       @"https://www.pinterest.com/explore/vegan-zucchini-recipes/",
                       @"",
                       @"",
                       nil];
        
    } else if (wheelType == MEAT_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"BEEF", @"PORK", @"TURKEY", @"LAMB", @"CHICKEN", @"SEAFOOD",nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"The recommended daily consumption is 22g. It takes 36 - 72 hrs to digest, (transit times from mouth to bowels) but it provides iron, zinc and vitamin B12. You can choose between Ground beef, Brisket, Stews, Rubs and Steak.\n Typical steak cuts incl: Sirloin, T-bone, Skirt, Strip and Flank.",
                          @"Pork is versatile and is 31% leaner than it was 20yrs ago. Pork cuts incl: picnic ham, leg ham, pork chops, pork loin, ribs, or pork belly. Bacon and sausage are on the table.",
                          @"The meat is low-GI and can help keep insulin levels stable. Turkey contains the amino acid tryptophan, which produces serotonin and plays an important role in strengthening the immune system. It is also a source of selenium, which is essential for thyroid hormone metabolism.",
                          @"Lamb is a staple in Mediterranean diets, believed to be the world's healthiest diet because of its ability to lower the risk of cardiovascular disease. And although it can be slightly higher in calories than other meats, that can be offset when you remove some of the fat from a cut of lamb. Lamb cuts incl. lamb shanks, lamb chops, loin cuts, lamb legs and shoulder. ",
                          @"Chicken is a lean protein but the skin is loaded with saturated fat. Both chicken and turkey give you about 25 grams of high-quality protein, along with B vitamins and seleanium. ",
                          @"Seafood is an excellent source of protein because it’s usually low in fat. Fish such as salmon is a little higher in fat. It includes all of the essential amino acids for human health, making it a complete protein source. The American Heart Association recommends aiming for at least two 3.5-oz servings per week.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
        
    } else if (wheelType == BAKERY_WHEEL) {
        sectorsTitle = [NSArray arrayWithObjects:@"SOUFFLÉ", @"BUNS/ROLLS", @"CAKE", @"CREPE", @"PIE", @"PANINI",@"MUFFIN",@"ROULADE/SWISS ROLL",@"COOKIE",@"PUDDING",@"TART",@"DOUGHNUT",@"CROISSANT",@"BAGEL",nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"The two main parts of a souffé are a custard base (a creamy sauce) and egg whites that have been beaten to form a Meringue. The name soufflé comes from the French verb souffler, which means to blow up or puff up. Common ingredients include cheese, chocolate, fruits, berries and jam. Served quickly upon coming out of the oven in ramekins.",
                          @"Buns are usually made from flour, sugar, milk, yeast and butter. Look for sweet bread or any item that is just as portable and baked with yeast e.g. cinnamon roll, cinnamon twists, biscuits etc. Coffee cakes commonly use yeast as well. The purpose of yeast is to help bread rise.",
                          @"Cakes are a sweet baked food made of flour, liquid, eggs, raising agent, such as baking soda or baking powder. The anatmoy of a cake can be layered with cake, buttercream/ganache, icing and decorated with fondant or more icing or buttercream. Can opt for a cupcake as well.",
                          @"A crepe is a type of thin pastry, usually made from wheat flour or buckwheat flour. Unlike pancakes, they are large in diameter and do not use a raising agent. So they are served thin and folded to be filled with any combination you desire such as fruits and creams.",
                          @"A pie is different from pastries by the way the butter is incorporated in the dough making process. It is also completely encased in the pastry dough, covered, enclosed with sweet fillings or meats. Unlike turnovers, they're defined by their crust and larger size overall. You may still buy a Turnover/Empanada depending on the nationality of the bakery.",
                          @"Panini is literally the Italian plural word for sandwiches. It is a grilled and pressed sandwich with a bread roll. Examples of bread types used are a baguette, ciabatta, and michetta. Ciabatta or foccacia is preferred. Fillings incl. meats, vegetables and cheeses. Must be pressed showing grill marks to be considered a panini. Unlike other sandwiches itÕs not topped with any spreads. The bread should be flavorful enough.",
                          @"The mixing process differs from cupcake making. Muffins for ex: sometimes replace all-purpose flour with whole wheat flour, oat flour or nut flours. Can be filled with dried fruits, nuts or chocolate chips. They may also replace butter with a liquid form of fat, such as vegetable oil. Muffins are not topped with frosting, so the amount of butter and sugar is higher in cupcakes than in muffins.",
                          @"A roulade is a dish served in the form of a roll. In baking in particular, it starts out as a thin flat SPONGE cake thats layered with whipped cream, jam, or icing known as a swiss roll. It is then rolled up into a spiral. If the cake is made incorrectly the cake will crack in the rolling process. Can be topped with more cream or powdered sugar.",
                          @"A cookie is literally a flat, small and round sweet cake. They differ from cakes in that they are made with cookie dough and not a batter, which is generally more moist. Cookies tend to have a higher ratio of fat and less moisture, which keeps them in their crisp condensed form. That is why they are never decorated or filled with icing/cream. You can however make a cookie sandwich. Cakes call for less butter, less sugar and more eggs than cookies.",
                          @"Pudding can be served as a dessert or a savory dish. The original pudding was formed by mixing various ingredients with a grain product. Creamy newer versions consists of sugar, milk, cornstarch, gelatin, eggs, rice or tapioca to create a sweet, creamy dessert. These puddings are made either by simmering on stove top or baking, often in a bain-marie. Flan can be considered a pudding as it falls under the custard family. Rice pudding is an example of the creamy sweeter version.",
                          @"A tart is an open pastry case containing a fruit-based, sometimes custard filling. Usually made from pastry dough with a bottom crust, no covering. Popular variations include quiches, pies, and cheesecake. Its sides are much thinner and shallower than regular pies. They're baked in a pan with a removable bottom.",
                          @"Doughnuts are usually deep fried from a flour dough, and typically either ring-shaped or without a hole. They can be dusted with sugar, filled with jelly or cream or coated with glaze or frosting. The average doughnut has 303 calories, while a generic bagel has 250 calories.",
                          @"A croissant is a French crescent-shaped roll made of sweet flaky pastry, often eaten for breakfast. You can enjoy them with a jam or as croissant sandwich. A generic croissant has more calories than a bagel and doughnut. They're also higher in saturated fat than whole-grain bagels.",
                          @"A bagel is a dense bread roll in the shape of a ring, different from regular bread in that its dough is boiled then baked in an oven. Bagels serve as a conduit for cream cheese and can be topped with cheeses and meats to make a sandwich for any meal. A generic bagel has 250 calories.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"https://wonderopolis.org/wonder/what-is-a-souffle",
                       @"",
                       @"",
                       @"https://www.chowhound.com/food-news/176459/whats-the-difference-between-crepes-and-pancakes/",
                       @"https://www.eatbydate.com/difference-between-puff-pastry-and-pie-crust/",
                       @"http://www.thejabberwocky.co.uk/2015/08/13/the-difference-between-grilled-cheese-paninis-and-toasties/",
                       @"https://spoonuniversity.com/lifestyle/cupcake-different-from-muffin-facts",
                       @"",
                       @"http://www.cakespy.com/blog/2014/9/2/batter-versus-dough-whats-the-difference.html",
                       @"",
                       @"",
                       @"http://www.voxmagazine.com/food/bagels-vs-doughnuts-which-measures-up-as-the-hole-ier/article_2857b341-62e6-5d88-b18c-bb8df3b2c9ee.html",
                       @"",
                       @"http://www.huffingtonpost.com/entry/what-makes-a-bagel-different-from-a-circular-piece-of-bread-with-a-hole-in-the-center_us_56059c79e4b0768126fd7edd",
                       nil];
        
    } else if (wheelType == FLAVORS_WHEEL){
        sectorsTitle = [NSArray arrayWithObjects:@"VANILLA", @"PECAN", @"CHERRY", @"COOKIE DOUGH", @"COFFEE", @"MINT",@"BANANA",@"BUTTERCREAM",@"LIME",@"STRAWBERRY",@"PEANUT BUTTER",@"CHOCOLATE",@"PISTACHIO",@"CARAMEL",nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
        
    }else if (wheelType == CHEESE_WHEEL){
        sectorsTitle = [NSArray arrayWithObjects: @"TALEGGIO", @"FONTINA", @"ASIAGO", @"GORGONZOLA/ROQUEFORT", @"PECORINO", @"HAVARTI",@"MOZZARELLA",@"GOAT CHEESE",@"CHEDDAR",@"GOUDA",@"BRIE/CAMEMBERT",@"MANCHEGO",@"GRUYERE",@"BURRATA",nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"Taleggio is a semisoft cheese that uses cow's milk and comes from the Lombardy region of Italy. It is considered a 'washed rind' cheese, because in order to prevent it from mold infestation, the cheese is washed with seawater once a week. This process leaves it with a firm, often pungent outer rind, yet it has delicate and fairly mild interior. The cheese is cave aged about 40 days mainly from the caves of Val Taleggio, and becomes quite tangy. It is thought to be one of the oldest soft cheeses; Pair with white or red Burgundy, Barbaresco or even a rich Chardonnay.",
                          @"Fontina’s nutty and creamy flavor is appreciated everywhere. It has been made in the Val d’Aosta area of Italy since the 12th century. Today it is produced in other parts of Italy, France, Sweden and Denmark. This cheese is perfect in a wide range of recipes because it melts more evenly and smoothly than other cheeses. Even today it must uphold the same standards it did when made in 1957. The cheese is also aged longer than other varieties. This cheese ranges from ivory to golden yellow depending on the age; Pairs well with Chardonnay, Riesling, and wheat beer; 109 calories per oz.",
                          @"Traditionally, Asiago was made from sheep's milk but today it is produced from unpasteurised cow's milk, produced only on the Asiago plateau in the Veneto foothills in Italy.  There are two types of Asiago according to its aging - fresh Asiago (Asiago Pressato) has a smooth texture, while the aged Asiago (Asiago d'allevo) has a crumbly texture. Asiago d’allevo is matured for different time periods, while Asiago Pressato made with whole milk is matured for a month and sold fresh as a softer, milder cheese. Depending on age, the rinds of Asiago can be straw coloured and elastic to brownish gray and hard. Both pair well with Chianti, Sherry and Chardonnay. Aged Asiago also pairs with Madeira and Beaujolais.",
                          @"Roquefort and Gorgonzola are two kinds of blue cheese. Blue Cheese is a broad category to distinguish cheeses with the blue spots/veins of mold. The blue spots appear after a process where Penicillium (a type of mold) is added. The cheese is then aged in a temperature-monitored setting (i.e. a cave). Roquefort uses French sheep’s milk and Gorgonzola is Italian, made from cow’s milk. Roquefort has a sharper flavor, but is not as strongly flavored and aromatic as a Gorgonzola. Both pair well with a Rosé, Riesling, or Port. Other blue cheese includes the Stilton Cheese.",
                          @"Pecorino is a family of hard Italian cheeses made from ewe's milk hence the name Pecora, Italian for Sheep; Pecorino Romano refers to pecorino cheese from Rome while Pecorino Siicilliano cheeses come from Sicily. These cheeses are all hard, drum shaped with a brownish color rind. It’s flaky and crumbly just like a Parmesan cheese, however Parmesan’s milk comes from a cow or raw skim milk making it pale in color instead of yellow. Pecorino Romano is a favorite because it provides a nice tangy, salty flavor and smokey flavor; Pairs well with an Italian red wine or a light beer.",
                          @"Havarti or Cream Havarti is a semisoft Danish cow's milk cheese. It’s Denmark’s most famous cheese. Today it’s also made in Wisconsin USA, but made with the traditional Scandinavian manner. This interior-ripened cheese is aged for around three months. The cheese has tiny holes throughout the paste with cream to yellow in colour. The cheese can be mild to sharp in flavour and buttery depending on its aging. Havarti is made from high-pasteurized cow's milk. Cream Havarti, is prepared by the same original recipe but is enriched with extra cream. Because of its texture it can be sliced, grilled, or melted; Pairs well with a Pinot Grigio.",
                          @"Mozzarella cheese is a sliceable curd cheese originating in Italy. Traditional mozzarella is made from water buffalo milk (not North American buffalo or bison) this flavor is highly prized. Water buffalo milk is 3xs more expensive than cow's milk, is costly to ship, and the animals are herded in very few countries. For these reasons it’s now made from cow’s milk. Mozzarella cheese contains 40 - 45 % fat, although skim versions are available. This cheese is not aged like most cheeses and is actually best when eaten within hours of its making; Pairs well with a Sauvignon Blanc; has 78 calories per ounce.",
                          @"Goat cheese has fewer calories than cow’s cheese at only 75-103 calories per ounce. It is also easier to digest because it has less lactose and a different protein structure than cow’s milk. The taste of goat cheese has been likened to cream cheese and is considered to be saltier than feta. Fresh goat cheese should look moist.  Reject if air-bloated, moldy, or leaking whey. Fresh artisan goat cheeses are not usually aged, so they are fresh and creamy looking with a fairly mild, salty flavor; Pairs well with a Sauvignon Blanc.",
                          @"The coloring in yellow cheddar was added to distinguish where the cheese was made. Cheddar Cheeses made in the New England states (including Cabot Cheddar Cheese made in Vermont) traditionally do not contain color additives. It is common for some moisture to develop inside the package of naturally produced Cheddar cheese. Syneresis allows Cheddar cheese to reach the next stage of aging giving it a sharp crumbly texture; Pairs best with a Malbec; Cheddar cheese pairs with a Cabernet Sauvignon; 113 calories per ounce.",
                          @"Gouda is named after the city of Gouda in the Netherlands. It is a semi-hard cheese celebrated for its rich, unique flavour and smooth texture. Gouda is typically made from pasteurised cow’s milk although some artisan varieties use sheep’s or goat’s milk to age them for a long time. American versions are smoother and less flavourful. Young Goudas pair well with beer, medium cheeses pair with a fruity Riesling or Chenin Blanc. Aged Goudas pair best with Cabernet Sauvignon or Merlot.",
                          @"Brie and Camambert are very similar in texture and color and both are originally from France.  The cheesemaking technique is similar except Brie Cream is added to Brie and not to the Camembert. Traditional French Brie and Camembert are made with raw milk outside the US. However, the USDA requires that all cheese made with raw milk be aged 60 days before being sold in US. Therefore American versions are always made with pasteurized milk. Camembert has more intense, deeper earthy notes than the milder and buttery Brie. Also a wheel of Camembert is much smaller, so it always sold in whole 8oz wheels. Brie wheels on average are 9-14in. in diameter. Because of this they are often sold in pie-shaped slices. Both pair well with Pinot Noir, while Brie may also pair with a Chardonnay; 95 calories per ounce.",
                          @"Manchego cheese is a sheep's milk cheese from Spain that contains an inedible rind. The crosshatched appearance in the rind comes from the basket it was aged in. The rind is typically wrapped in black wax, revealing a creamy white to pale yellow cheese inside. It adds a salty, nutty flavor to dishes. Because of a sheep’s diet, having notes of herbs and plants are also common in the final product depending on the age. It is sold in 3 various stages, as a Fresco when aged for 2 months, a Curado when aged for 1 year, and Anejo when aged for 2 years. Look for brands with La Mancha origin on the label for authentication; Pairs well with a Rioja Wine.",
                          @"Gruyère is a hard yellow cheese, named after the town of Gruyères in Switzerland. It is a smooth-melting type of swiss cheese that's made from whole cow's milk and generally cured for 6 months or longer. Also like the swiss cheese, it has holes created by the gas bubbles released by the bacteria used in making the cheese. However it is slightly nutty in taste, and makes a great melting cheese, wonderful for fondue. The water-to-fat ratio, and curdling with enzymes called rennet is what enables it to melt. Keep in mind that the longer a cheese is aged, the more it dries out. Younger fresher cheeses will melt better than aged cheeses; Pairs well with Chardonnay or Sauvignon Blanc.",
                          @"Burrata is made from Mozzarella but it is NOT a Mozzarella. After making Mozzarella, the cheese is formed into a pouch, and then filled with soft, stringy curd called stracciatella and cream. The outer shell remains a solid Mozzarella, but its center is a milky, buttery flavor that's rich without being too indulgent; hence its name Burrata, which literally translates into 'buttered.' After slicing into the ball of cheese, the creamy filling will be revealed, often spilling onto the plate. For the most flavor and best texture, bring burrata up to room temperature before serving; should be eaten as fresh as possible. When burrata has gone bad, the flavor is sour and it will smell like old milk. Pairs best with a Sauvignon Blanc, Chenin blanc, and Pinot Gris.",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       
                       nil];
    }else if(wheelType == AROUNTME_WHEEL){
        sectorsTitle = [NSArray arrayWithObjects: @"RESTAURANT #1",
                        @"RESTAURANT #2",
                        @"RESTAURANT #3",
                        @"RESTAURANT #4",
                        @"RESTAURANT #5",
                        @"RESTAURANT #6",
                        @"RESTAURANT #7",
                        @"RESTAURANT #8",
                        @"RESTAURANT #9",
                        @"RESTAURANT #10",
                        @"RESTAURANT #11",
                        @"RESTAURANT #12",
                        @"RESTAURANT #13",
                        @"RESTAURANT #14",
                        nil];
        sectorsTitleColor = [NSArray arrayWithObjects:WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, WHITE_COLOR, nil];
        sectorsComment = [NSArray arrayWithObjects:
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          @"",
                          nil];
        sectorsLink = [NSArray arrayWithObjects:
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       @"",
                       nil];
    }
    
}
- (int) getSectionNumbers {
    switch (wheelType) {
        case STYLE_FOOD_WHEEL:
            return 14;
        case CULTURE_FOOD_WHEEL:
            return 6;
        case LIQUOR_DRINK_WHEEL:
            return 6;
        case BEER_DRINK_WHEEL:
            return 14;
        case TEA_DRINK_WHEEL:
            return 6;
        case WINE_DRINK_WHEEL:
            return 13;
        case SPANISH_CULTURE_WHEEL:
            return 6;
        case EUROPEAN_CULTURE_WHEEL:
            return 8;
        case NORTH_CULTURE_WHEEL:
            return 6;
        case ASIAN_CULTURE_WHEEL:
            return 8;
        case TROPICAL_CULTURE_WHEEL:
            return 6;
        case MIDDLE_CULTURE_WHEEL:
            return 6;
        case SEAFOOD_WHEEL:
            return 12;
        case VEGETARIAN_WHEEL:
            return 12;
        case MEAT_WHEEL:
            return 6;
        case BAKERY_WHEEL:
            return 14;
        case FLAVORS_WHEEL:
            return 14;
        case CHEESE_WHEEL:
            return 14;
        case AROUNTME_WHEEL:
            return 14;
        default:
            return 12;
    }
}

- (int) getSectorViewHeight:(int) r {
    return r * sinf(M_PI / numberOfSections) * 2;
}

- (void)addPieShapeToView:(UIView *) view withColor:(UIColor *)color {
    int x = view.bounds.size.width;
    int y = view.bounds.size.height / 2;
    int thickness = x - 10;
    int r = thickness / 2;
    
    UIBezierPath *mainPath = [UIBezierPath new];
    float angle = M_PI / numberOfSections;
    float center_x = x - cosf(angle) * r;
    float center_y = y + sinf(angle) * r;
    [mainPath moveToPoint:CGPointMake(center_x, center_y)];
    [mainPath addArcWithCenter:CGPointMake(x, y) radius:r startAngle:M_PI - angle endAngle:M_PI + angle clockwise:YES];
    
    UIColor *clear = [UIColor clearColor];
    
    CAShapeLayer *mainLayer = [[CAShapeLayer alloc] init];
    mainLayer.frame = view.bounds;
    mainLayer.path = [mainPath CGPath];
    mainLayer.strokeColor = [color CGColor];
    mainLayer.fillColor = [clear CGColor];
    mainLayer.lineWidth = thickness;
    
    [view.layer addSublayer:mainLayer];
    
    UIBezierPath *outlinePath = [UIBezierPath new];
    thickness = 10;
    r = x - 5;
    center_x = x - cosf(angle) * r;
    center_y = y + sinf(angle) * r;
    [outlinePath moveToPoint:CGPointMake(center_x, center_y)];
    [outlinePath addArcWithCenter:CGPointMake(x, y) radius:r startAngle:M_PI - angle endAngle:M_PI + angle clockwise:YES];
    
    UIColor *darkerColor = [self darkerColorForColor:color];
    
    CAShapeLayer *outlineLayer = [[CAShapeLayer alloc] init];
    outlineLayer.frame = view.bounds;
    outlineLayer.path = [outlinePath CGPath];
    outlineLayer.strokeColor = [darkerColor CGColor];
    outlineLayer.fillColor = [clear CGColor];
    outlineLayer.lineWidth = thickness;
    
    [view.layer addSublayer:outlineLayer];
}

- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

- (UIColor *)getSectorColr:(int) i {
    switch (i) {
        case 0:
            return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        case 1:
            return [UIColor colorWithRed:71/255.0 green:183/255.0 blue:73/255.0 alpha:1];
        case 2:
            return [UIColor colorWithRed:151/255.0 green:209/255.0 blue:187/255.0 alpha:1];
        case 3:
            return [UIColor colorWithRed:20/255.0 green:121/255.0 blue:189/255.0 alpha:1];
        case 4:
            return [UIColor colorWithRed:43/255.0 green:50/255.0 blue:124/255.0 alpha:1];
        case 5:
            return [UIColor colorWithRed:62/255.0 green:23/255.0 blue:36/255.0 alpha:1];
        case 6:
            return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
        case 7:
            return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
        case 8:
            return [UIColor colorWithRed:228/255.0 green:77/255.0 blue:139/255.0 alpha:1];
        case 9:
            return [UIColor colorWithRed:217/255.0 green:27/255.0 blue:85/255.0 alpha:1];
        case 10:
            return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
        case 11:
            return [UIColor colorWithRed:118/255.0 green:28/255.0 blue:86/255.0 alpha:1];
        case 12:
            return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
        case 13:
            return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
        default:
            return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
            
    }
}

- (UIColor *)getSectorColrForWheelType:(int) i {
    if(self.wheelType == 3)//for LIQUOR
    {
        switch (i) {
            case 3:
                return [UIColor colorWithRed:20/255.0 green:121/255.0 blue:189/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:43/255.0 green:50/255.0 blue:124/255.0 alpha:1];
            case 1:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
            case 0:
                return [UIColor colorWithRed:128/255.0 green:53/255.0 blue:27/255.0 alpha:1];
            case 5:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 4:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:228/255.0 green:77/255.0 blue:139/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:217/255.0 green:27/255.0 blue:85/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:118/255.0 green:28/255.0 blue:86/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
                
        }
    }else if(self.wheelType == 4)//for BEER
    {
        switch (i) {
            case 0:
                return [UIColor colorWithRed:68/255.0 green:183/255.0 blue:73/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:62/255.0 green:21/255.0 blue:35/255.0 alpha:1];
            case 5:
                return [UIColor colorWithRed:202/255.0 green:50/255.0 blue:39/255.0 alpha:1];
              case 4:
                return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
            case 3:
                return [UIColor colorWithRed:134/255.0 green:33/255.0 blue:26/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:244/255.0 green:226/255.0 blue:40/255.0 alpha:1];
            case 1:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:68/255.0 green:183/255.0 blue:73/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:62/255.0 green:21/255.0 blue:35/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:134/255.0 green:33/255.0 blue:26/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:235/255.0 green:181/255.0 blue:103/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:244/255.0 green:226/255.0 blue:40/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
                
        }
        
    }else if(self.wheelType == 5)//for TEA
    {
        switch (i) {
            case 5:
                return [UIColor colorWithRed:169/255.0 green:109/255.0 blue:0/255.0 alpha:1];
            case 0:
                return [UIColor colorWithRed:154/255.0 green:59/255.0 blue:13/255.0 alpha:1];
            case 1:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:139/255.0 green:202/255.0 blue:81/255.0 alpha:1];
            case 3:
                return [UIColor colorWithRed:217/255.0 green:137/255.0 blue:18/255.0 alpha:1];
            case 4:
                return [UIColor colorWithRed:200/255.0 green:100/255.0 blue:42/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:228/255.0 green:77/255.0 blue:139/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:217/255.0 green:27/255.0 blue:85/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:118/255.0 green:28/255.0 blue:86/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
                
        }
        
    }else if(self.wheelType == 6)//for WINE
    {
        switch (i) {
            case 0:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 1:
                return [UIColor colorWithRed:131/255.0 green:18/255.0 blue:19/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:226/255.0 green:71/255.0 blue:104/255.0 alpha:1];
            case 3:
                return [UIColor colorWithRed:131/255.0 green:18/255.0 blue:19/255.0 alpha:1];
            case 4:
                return [UIColor colorWithRed:97/255.0 green:0/255.0 blue:38/255.0 alpha:1];
            case 5:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:255/255.0 green:243/255.0 blue:141/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:234/255.0 green:175/255.0 blue:0/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:255/255.0 green:243/255.0 blue:141/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:255/255.0 green:243/255.0 blue:141/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:131/255.0 green:18/255.0 blue:19/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:131/255.0 green:18/255.0 blue:19/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
                
        }
        
    }else if(self.wheelType == BAKERY_WHEEL){//bakery
        switch (i) {
            case 0:
            case 7:
                return [UIColor colorWithRed:202/255.0 green:12/255.0 blue:63/255.0 alpha:1];
                break;
            case 1:
            case 8:
                return [UIColor colorWithRed:64/255.0 green:21/255.0 blue:55/255.0 alpha:1];
                break;
            case 2:
            case 9:
                return [UIColor colorWithRed:209/255.0 green:42/255.0 blue:106/255.0 alpha:1];
                break;
            case 3:
            case 10:
                return [UIColor colorWithRed:202/255.0 green:39/255.0 blue:57/255.0 alpha:1];
                break;
            case 4:
            case 11:
                return [UIColor colorWithRed:243/255.0 green:114/255.0 blue:105/255.0 alpha:1];
                break;
            case 5:
            case 12:
                return [UIColor colorWithRed:252/255.0 green:121/255.0 blue:49/255.0 alpha:1];
                break;
            case 6:
            case 13:
                return [UIColor colorWithRed:255/255.0 green:180/255.0 blue:133/255.0 alpha:1];
                break;
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        }
        
    }else if(self.wheelType == FLAVORS_WHEEL){//flavor
        switch (i) {
            case 0:
            case 7:
                return [UIColor colorWithRed:244/255.0 green:131/255.0 blue:39/255.0 alpha:1];
                break;
            case 1:
            case 8:
                return [UIColor colorWithRed:235/255.0 green:120/255.0 blue:102/255.0 alpha:1];
                break;
            case 2:
            case 9:
                return [UIColor colorWithRed:195/255.0 green:41/255.0 blue:53/255.0 alpha:1];
                break;
            case 3:
            case 10:
                return [UIColor colorWithRed:202/255.0 green:39/255.0 blue:104/255.0 alpha:1];
                break;
            case 4:
            case 11:
                return [UIColor colorWithRed:62/255.0 green:21/255.0 blue:55/255.0 alpha:1];
                break;
            case 5:
            case 12:
                return [UIColor colorWithRed:116/255.0 green:183/255.0 blue:68/255.0 alpha:1];
                break;
            case 6:
            case 13:
                return [UIColor colorWithRed:243/255.0 green:169/255.0 blue:18/255.0 alpha:1];
                break;
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        }
        
    }else if(self.wheelType == SEAFOOD_WHEEL){//seafood
        switch (i) {
            case 0:
                return [UIColor colorWithRed:48/255.0 green:119/255.0 blue:153/255.0 alpha:1];
                break;
            case 1:
                return [UIColor colorWithRed:36/255.0 green:98/255.0 blue:140/255.0 alpha:1];
                break;
            case 2:
                return [UIColor colorWithRed:72/255.0 green:140/255.0 blue:172/255.0 alpha:1];
                break;
            case 3:
                return [UIColor colorWithRed:143/255.0 green:177/255.0 blue:193/255.0 alpha:1];
                break;
            case 4:
                return [UIColor colorWithRed:162/255.0 green:187/255.0 blue:200/255.0 alpha:1];
                break;
            case 5:
                return [UIColor colorWithRed:129/255.0 green:170/255.0 blue:189/255.0 alpha:1];
                break;
            case 6:
                return [UIColor colorWithRed:34/255.0 green:83/255.0 blue:108/255.0 alpha:1];
                break;
            case 7:
                return [UIColor colorWithRed:46/255.0 green:115/255.0 blue:148/255.0 alpha:1];
                break;
            case 8:
                return [UIColor colorWithRed:78/255.0 green:142/255.0 blue:173/255.0 alpha:1];
                break;
            case 9:
                return [UIColor colorWithRed:36/255.0 green:98/255.0 blue:140/255.0 alpha:1];
                break;
            case 10:
                return [UIColor colorWithRed:143/255.0 green:177/255.0 blue:193/255.0 alpha:1];
                break;
            case 11:
                return [UIColor colorWithRed:34/255.0 green:83/255.0 blue:108/255.0 alpha:1];
                break;
            case 12:
                return [UIColor colorWithRed:34/255.0 green:83/255.0 blue:108/255.0 alpha:1];
                break;
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        }
        
    }else if(self.wheelType == VEGETARIAN_WHEEL){//vegetarian
        switch (i) {
            case 0:
                return [UIColor colorWithRed:118/255.0 green:28/255.0 blue:86/255.0 alpha:1];
                break;
            case 1:
                return [UIColor colorWithRed:0/255.0 green:118/255.0 blue:2/255.0 alpha:1];
                break;
            case 2:
                return [UIColor colorWithRed:212/255.0 green:75/255.0 blue:0/255.0 alpha:1];
                break;
            case 3:
                return [UIColor colorWithRed:228/255.0 green:77/255.0 blue:139/255.0 alpha:1];
                break;
            case 4:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
                break;
            case 5:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
                break;
            case 6:
                return [UIColor colorWithRed:62/255.0 green:23/255.0 blue:36/255.0 alpha:1];
                break;
            case 7:
                return [UIColor colorWithRed:136/255.0 green:165/255.0 blue:0/255.0 alpha:1];
                break;
            case 8:
                return [UIColor colorWithRed:151/255.0 green:209/255.0 blue:187/255.0 alpha:1];
                break;
            case 9:
                return [UIColor colorWithRed:71/255.0 green:183/255.0 blue:73/255.0 alpha:1];
                break;
            case 10:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
                break;
            case 11:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
                break;
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        }
        
    }if(self.wheelType == CHEESE_WHEEL)//7? FOR CHEESE
    {
        switch (i) {
            case 1:
                return [UIColor colorWithRed:243/255.0 green:233/255.0 blue:72/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:234/255.0 green:222/255.0 blue:0/255.0 alpha:1];
            case 3:
                return [UIColor colorWithRed:249/255.0 green:237/255.0 blue:131/255.0 alpha:1];
            case 4:
                return [UIColor colorWithRed:240/255.0 green:216/255.0 blue:44/255.0 alpha:1];
            case 5:
                return [UIColor colorWithRed:249/255.0 green:237/255.0 blue:131/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:243/255.0 green:233/255.0 blue:72/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:240/255.0 green:216/255.0 blue:44/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:249/255.0 green:237/255.0 blue:131/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:234/255.0 green:222/255.0 blue:0/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:243/255.0 green:233/255.0 blue:72/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:235/255.0 green:212/255.0 blue:48/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:249/255.0 green:237/255.0 blue:131/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:243/255.0 green:233/255.0 blue:72/255.0 alpha:1];
            case 14:
                return [UIColor colorWithRed:235/255.0 green:212/255.0 blue:48/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:243/255.0 green:233/255.0 blue:72/255.0 alpha:1];
                
        }
    }if(self.wheelType == AROUNTME_WHEEL)//19 FOR NEAR AROUND ME
    {
        switch (i) {
            case 1:
            case 5:
            case 8:
            case 12:
            case 15:
                return [UIColor colorWithRed:0/255.0 green:136/255.0 blue:236/255.0 alpha:1];
            case 2:
            case 9:
            case 14:
                return [UIColor colorWithRed:1/255.0 green:103/255.0 blue:178/255.0 alpha:1];
            case 3:
            case 10:
                return [UIColor colorWithRed:2/255.0 green:121/255.0 blue:211/255.0 alpha:1];
            case 4:
            case 6:
            case 11:
            case 13:
                return [UIColor colorWithRed:1/255.0 green:85/255.0 blue:147/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:0/255.0 green:102/255.0 blue:176/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:0/255.0 green:102/255.0 blue:176/255.0 alpha:1];
                
        }
    }
    else{//other
        
        switch (i) {
            case 0:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
            case 1:
                return [UIColor colorWithRed:71/255.0 green:183/255.0 blue:73/255.0 alpha:1];
            case 2:
                return [UIColor colorWithRed:151/255.0 green:209/255.0 blue:187/255.0 alpha:1];
            case 3:
                return [UIColor colorWithRed:20/255.0 green:121/255.0 blue:189/255.0 alpha:1];
            case 4:
                return [UIColor colorWithRed:43/255.0 green:50/255.0 blue:124/255.0 alpha:1];
            case 5:
                return [UIColor colorWithRed:62/255.0 green:23/255.0 blue:36/255.0 alpha:1];
            case 6:
                return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
            case 7:
                return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
            case 8:
                return [UIColor colorWithRed:228/255.0 green:77/255.0 blue:139/255.0 alpha:1];
            case 9:
                return [UIColor colorWithRed:217/255.0 green:27/255.0 blue:85/255.0 alpha:1];
            case 10:
                return [UIColor colorWithRed:204/255.0 green:32/255.0 blue:46/255.0 alpha:1];
            case 11:
                return [UIColor colorWithRed:118/255.0 green:28/255.0 blue:86/255.0 alpha:1];
            case 12:
                return [UIColor colorWithRed:252/255.0 green:244/255.0 blue:129/255.0 alpha:1];
            case 13:
                return [UIColor colorWithRed:195/255.0 green:99/255.0 blue:40/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
                
        }
    }
}

@end
