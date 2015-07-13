//
//  DXCrossLayer.m
//  PlayNimbus
//
//  Created by xiekw on 15/5/3.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXCrossLayer.h"

static inline CGFloat radians(CGFloat degrees) {
    return ( degrees * M_PI ) / 180.0;
}

@implementation DXCrossLayer
{
    CALayer *_left;
    CALayer *_right;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.crossLineAngle = radians(45.0);
        self.crossLineWidth = 1.0;
        self.crossLineCornerRadius = 1.0;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    CGRect crossFrame = CGRectInset(bounds, (CGRectGetWidth(bounds) - self.crossLineWidth) * 0.5, 0.0);
    
    _left = [CALayer layer];
    _right = [CALayer layer];
    _left.backgroundColor = _right.backgroundColor = self.normalColor.CGColor;
    _left.frame = crossFrame;
    _right.frame = crossFrame;
    _left.transform = CATransform3DMakeRotation(-self.crossLineAngle, 0.0, 0.0, 1.0);
    _right.transform = CATransform3DMakeRotation(self.crossLineAngle, 0.0, 0.0, 1.0);
    [self addSublayer:_left];
    [self addSublayer:_right];
}

- (UIImage *)normalImage
{
    _left.backgroundColor = _right.backgroundColor = self.normalColor.CGColor;
    return [self toImage];
}

- (UIImage *)highlightedImage
{
    _left.backgroundColor = _right.backgroundColor = self.highlightedColor.CGColor;
    return [self toImage];
}

- (UIImage *)selectedImage
{
    _left.backgroundColor = _right.backgroundColor = self.selectedColor.CGColor;
    return [self toImage];
}



@end
