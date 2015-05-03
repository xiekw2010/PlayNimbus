//
//  DXCrossLayer.h
//  PlayNimbus
//
//  Created by xiekw on 15/5/3.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DXLineShaperLayer.h"

@interface DXCrossLayer : DXLineShaperLayer

@property (nonatomic, assign) CGFloat crossLineWidth;
// use 180, 45, 360
@property (nonatomic, assign) CGFloat crossLineAngle;
@property (nonatomic, assign) CGFloat crossLineCornerRadius;

@end
