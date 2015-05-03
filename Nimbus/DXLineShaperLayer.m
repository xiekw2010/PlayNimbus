//
//  DXShaperImageLayer.m
//  PlayNimbus
//
//  Created by xiekw on 15/5/3.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXLineShaperLayer.h"

@implementation DXLineShaperLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalColor = [UIColor darkGrayColor];
        self.highlightedColor = [UIColor lightGrayColor];
        self.selectedColor = [UIColor grayColor];
    }
    return self;
}

- (UIImage *)toImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, 0, 0);
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

- (UIImage *)normalImage
{
    return nil;
}

- (UIImage *)highlightedImage
{
    return nil;
}

- (UIImage *)selectedImage
{
    return nil;
}

@end
