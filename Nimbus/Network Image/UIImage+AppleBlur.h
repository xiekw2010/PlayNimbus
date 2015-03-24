//
//  UIImage+AppleBlur.h
//  UIImage
//
//  Created by xiekw on 15/3/24.
//  Copyright (c) 2015年 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AppleBlur)

//apple wwdc session code for the blur
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
