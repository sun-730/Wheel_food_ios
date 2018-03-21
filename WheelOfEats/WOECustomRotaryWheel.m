//
//  WOECustomRotaryWheel.m
//  WheelOfEats
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "WOECustomRotaryWheel.h"
#import "SharingData.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface WOECustomRotaryWheel()
{
    float rotateV;
    NSTimer* timer;
    float initAngle;
    float lastAngle;
    NSTimeInterval initTime;
    NSTimeInterval lastTime;
    float initW;
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayer1;
    BOOL ISARROUNDME;
}

- (void) drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorEven;
- (void) buildSectorOdd;
- (void) initWheelInfo;
- (NSString *) getSectorTitle:(int)position;
- (NSString *) getSectorComment:(int)position;
- (NSString *) getSectorIconName:(int)position;
- (int) getSectorViewHeight:(int) r;
- (UIColor *)lighterColorForColor:(UIColor *)c;
- (UIColor *)darkerColorForColor:(UIColor *)c;
- (void)addPieShapeToView:(UIView *) view withColor:(UIColor *)color;
- (UIColor *)getSectorColr:(int) i;

@end

static float deltaTime = 0.03;
static float deltaAngle = 0.001;



@implementation WOECustomRotaryWheel{
    AppDelegate *appDel;
}
@synthesize delegate, container, numberOfSections, wheelTitle, wheelData, sectorsTitle, sectorsComment, currentSector, sectors, startTransform;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del title:title withData:(NSMutableDictionary *)data {
    //1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        self.delegate = del;
        self.wheelTitle = title;
        self.wheelData = data;
        //2 - Set properties
        if([title isEqualToString:@"aroundme123!@#"]){
            ISARROUNDME = YES;
            [self initWheelInfoArroundMe];
        }else{
            ISARROUNDME = NO;
            [self initWheelInfo];
        }
        //3 - Draw wheel
        [self drawWheel];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"GameShowWheelSpinSound" ofType:@"mp3"];
        NSURL* file = [NSURL fileURLWithPath:path];
        // thanks @gebirgsbaerbel
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer prepareToPlay];
        audioPlayer.numberOfLoops=-1;
        
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
    int wheelRadius1 = 150;
    int wheelRadius2 = 150;
    int spinpointY = -30;
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
        [self addPieShapeToView:sectorView withColor:[self getSectorColr:i]];
        sectorView.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sectorView.layer.position = CGPointMake(container.bounds.size.width / 2.0 - container.frame.origin.x, container.bounds.size.height / 2.0 - container.frame.origin.y);
        sectorView.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorView];
        
        UILabel *sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, wheelRadius2, [self getSectorViewHeight:wheelRadius2] - 20)];
        [sectorLabel setNumberOfLines:0];
        [sectorLabel setTextAlignment:NSTextAlignmentCenter];
        [sectorLabel setTextColor:[UIColor whiteColor]];
        sectorLabel.text = sectorsTitle[i];
        if (numberOfSections > 12)
            sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];//10
        else
            sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];//15
        sectorLabel.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sectorLabel.layer.position = CGPointMake(container.bounds.size.width / 2.0 - container.frame.origin.x, container.bounds.size.height / 2.0 - container.frame.origin.y);
        sectorLabel.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorLabel];
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
    
    
//    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(container.bounds.size.width / 2 - 35, container.bounds.size.height / 2 - 35, 70, 70)];
//    centerImage.image = [UIImage imageNamed:@"spin_center.png"];
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
        initW -= deltaAngle;
        if(appDel.isMute == false){
        [audioPlayer play];
        }
        
    } else if (initW < 0) {
        initW += deltaAngle;
        if(appDel.isMute == false){
            [audioPlayer play];
        }
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
        
        if(appDel.isMute == false){
            [audioPlayer stop];
            [audioPlayer1 play];
        }
        
        [self.delegate wheelDidChangeSector:currentSector];
        [self.delegate wheelDidChangeTitle:[self getSectorTitle:currentSector]];
        [self getSectorComment:currentSector];
//        [self.delegate wheelDidChangeComment:[self getSectorComment:currentSector]];
//        [self.delegate wheelDidChangeIconName:[self getSectorIconName:currentSector]];
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
    NSLog(@"Began Tracking with touch");
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
- (NSString *) getArroundMeTitle:(int)position{
    return sectorsComment[position];
}
- (NSString *) getSectorComment: (int)position {
    NSString *comment = self.wheelData[@"wheeldescription"];
    
    return comment;
}

- (NSString *) getSectorComment1: (int)position {
    SharingData *sharingData = [SharingData getInstance];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", sharingData.TOKEN_TYPE, sharingData.ACCESS_TOKEN] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"term": sectorsTitle[position],
                             @"latitude": @"37.77493",
                             @"longitude": @"-122.419415"};
    [manager GET:sharingData.YELP_API_SEARCH_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        NSLog(@"Yelp Search API Result==>>JSON: %@", responseObject);
        
        NSDictionary *searchData = (NSDictionary *)responseObject;
        //        NSLog(@"SearchData====%@", searchData);
        NSString *matchNames = @"";
        NSDictionary *item;
        NSString *name;
        for (item in searchData[@"businesses"]) {
            name = item[@"name"];
            matchNames = [NSString stringWithFormat:@"%@, %@", matchNames, name];
            NSLog(@"name==%@", name);
        }
        NSLog(@"match name===%@", matchNames);
        [self.delegate wheelDidChangeComment: matchNames];
        //        return matchNames;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Yelp Search API Error: %@", error);
        
        //        return @"";
    }];
    
    return @"";
}
- (NSString *) getSectorIconName: (int)position {
    return @"sample.png";
}
- (void) initWheelInfoArroundMe {
    sectorsTitle = [[NSMutableArray alloc] init];
    sectorsComment = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [wheelData objectForKey:@"around"];
    self.sectorsTitle = [arr mutableCopy];
    self.sectorsComment = [arr mutableCopy];
    for(int i = 0; i < arr.count; i++){
        sectorsTitle[i] = [sectorsTitle[i] stringByReplacingOccurrencesOfString:@"Restaurant" withString:@""];
        if ([sectorsTitle[i] length] > 10)
            sectorsTitle[i] = [sectorsTitle[i] substringToIndex:10];
//        sectorsTitle[i] = [NSString stringWithFormat:@"%@...", sectorsTitle[i]];
    }
    self.numberOfSections = arr.count;
}
- (void) initWheelInfo {
    NSString *entryId = nil;
    int i = 0;
    sectorsTitle = [[NSMutableArray alloc] init];
    sectorsComment = [[NSMutableArray alloc] init];
    
    for (entryId in wheelData) {
        if([wheelData[entryId] isEqualToString:@""]){
            
        }else if([entryId isEqualToString:@"wheeldescription"]){
            
        }
        else{
            NSString *tmp = wheelData[entryId];
            NSString *title = nil;
            Boolean is = false;
            for(title in sectorsTitle){
                if([tmp isEqualToString:title]){
                    is = true;
                    break;
                }
            }
            if(!is){
                [self.sectorsTitle addObject:[NSString stringWithFormat:@"%@", wheelData[entryId]]];
                if ([sectorsTitle[i] length] > 25)
                    sectorsTitle[i] = [sectorsTitle[i] substringToIndex:25];
                i++;
                
            }
        }
    }
    self.numberOfSections = i;
    
//    SharingData *sharingData = [SharingData getInstance];
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", sharingData.TOKEN_TYPE, sharingData.ACCESS_TOKEN] forHTTPHeaderField:@"Authorization"];
//
//    NSDictionary *params = @{@"term": @"food",
//                             @"latitude": @"37.77493",
//                             @"longitude": @"-122.419415"};
//    [manager GET:sharingData.YELP_API_SEARCH_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
////        NSLog(@"Yelp Search API Result==>>JSON: %@", responseObject);
//        
//        NSDictionary *searchData = (NSDictionary *)responseObject;
////        NSLog(@"SearchData====%@", searchData);
//        NSString *matchNames = @"";
//        NSDictionary *item;
//        NSString *name;
//        for (item in searchData[@"businesses"]) {
//            name = item[@"name"];
//            matchNames = [NSString stringWithFormat:@"%@, %@", matchNames, name];
//            NSLog(@"name==%@", name);
//        }
//        NSLog(@"match name===%@", matchNames);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Yelp Search API Error: %@", error);
//
//    }];

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
    if(!ISARROUNDME){
        switch (i) {
            case 0:
            case 4:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
            case 1:
            case 5:
                return [UIColor colorWithRed:151/255.0 green:209/255.0 blue:187/255.0 alpha:1];
            case 2:
            case 6:
                return [UIColor colorWithRed:20/255.0 green:121/255.0 blue:189/255.0 alpha:1];
            case 3:
            case 7:
                return [UIColor colorWithRed:62/255.0 green:23/255.0 blue:36/255.0 alpha:1];
            default:
                return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
        }
    }else{
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
//    switch (i) {
//        case 0:
//        case 4:
//            return [UIColor colorWithRed:71/255.0 green:183/255.0 blue:73/255.0 alpha:1];
//        case 1:
//        case 5:
//            return [UIColor colorWithRed:43/255.0 green:50/255.0 blue:124/255.0 alpha:1];
//        case 2:
//        case 6:
//            return [UIColor colorWithRed:233/255.0 green:225/255.0 blue:191/255.0 alpha:1];
//        case 3:
//        case 7:
//            return [UIColor colorWithRed:247/255.0 green:224/255.0 blue:40/255.0 alpha:1];
//
//        default:
//            return [UIColor colorWithRed:235/255.0 green:118/255.0 blue:49/255.0 alpha:1];
//
//    }
}

@end
