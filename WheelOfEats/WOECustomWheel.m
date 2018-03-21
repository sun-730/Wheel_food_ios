//
//  WOECustomWheel.m
//  WheelOfEats
//
//  Created by Admin on 5/18/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "WOECustomWheel.h"


@implementation WOECustomWheel
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize wheelData, numberOfSections, container, startTransform;
@synthesize sectorsTitle, sectorsComment;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del title:title withData:(NSMutableDictionary *)data {
    //1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        self.delegate = del;
        self.wheelTitle = title;
        self.wheelData = data;
        //2 - Set properties
        [self initWheelInfo];
        //3 - Draw wheel
        [self drawWheel];
        
    }
    return self;
}

- (void) drawWheel {
    // 1
    container = [[UIView alloc] initWithFrame:self.frame];
    // 2
    CGFloat angleSize = 2 * M_PI / numberOfSections;
    // 3 - Create the sectors
    for (int i = 0; i < numberOfSections; i++) {
        // 4 - Create image view
        int containerWidth = container.bounds.size.width;
        int containerHeight = container.bounds.size.height;
        UIView *sectorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth / 2, [self getSectorViewHeight:containerHeight / 2])];
        [self addPieShapeToView:sectorView withColor:[self getSectorColr:i]];
        sectorView.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sectorView.layer.position = CGPointMake(containerWidth / 2.0 - container.frame.origin.x, containerHeight / 2.0 - container.frame.origin.y);
        sectorView.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorView];
        
        UILabel *sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, containerWidth / 2 - 10, [self getSectorViewHeight:containerHeight / 2] - 10)];
        [sectorLabel setNumberOfLines:0];
        [sectorLabel setTextAlignment:NSTextAlignmentLeft];
        [sectorLabel setTextColor:[UIColor whiteColor]];
        sectorLabel.text = self.sectorsTitle[i];
        if (numberOfSections > 12)
            sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:9];//7
        else
            sectorLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];//12
        sectorLabel.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sectorLabel.layer.position = CGPointMake(containerWidth / 2.0 - container.frame.origin.x, containerHeight / 2.0 - container.frame.origin.y);
        sectorLabel.transform = CGAffineTransformMakeRotation(angleSize * i + M_PI_2);
        [container addSubview:sectorLabel];
    }
    
    // 7
    container.userInteractionEnabled = NO;
    [self addSubview:container];
}

- (void)addPieShapeToView:(UIView *) view withColor:(UIColor *)color {
    int x = view.bounds.size.width;
    int y = view.bounds.size.height / 2;
    int thickness = x - 5;
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
    thickness = 5;
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

- (int) getSectorViewHeight:(int) r {
    return r * sinf(M_PI / numberOfSections) * 2;
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
                if ([sectorsTitle[i] length] > 5)
                    sectorsTitle[i] = [sectorsTitle[i] substringToIndex:5];
                i++;
                
            }
        }
    }
    self.numberOfSections = i;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.delegate wheelDidTouched:self.wheelTitle];
}

@end
