//
//  SMRotaryProtocol.h
//  RotaryWheel
//
//  Created by Admin on 4/28/17.
//  Copyright © 2017 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOERotaryProtocol <NSObject>

- (void) wheelDidChangeSector:(int)newValue;
- (void) wheelDidChangeTitle:(NSString *)newValue;
- (void) wheelDidChangeComment:(NSString *)newValue;
- (void) wheelDidChangeLink:(NSString *)newValue;
- (void) wheelDidChangeIconName:(NSString *)newValue;
- (void) wheelDidTouched:(NSString *)title;

@end
