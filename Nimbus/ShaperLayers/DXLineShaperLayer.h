//
//  DXShaperImageLayer.h
//  PlayNimbus
//
//  Created by xiekw on 15/5/3.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface DXLineShaperLayer : CALayer

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) UIColor *selectedColor;


- (UIImage *)toImage;
- (UIImage *)normalImage;
- (UIImage *)highlightedImage;
- (UIImage *)selectedImage;

@end
