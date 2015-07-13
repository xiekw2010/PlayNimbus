//
//  UICategory.h
//  MoreLikers
//
//  Created by xiekw on 14-1-20.
//  Copyright (c) 2014年 周和生. All rights reserved.
//

#import <UIKit/UIKit.h>

// ios7 api to get the label text size
#define TextSizeWithTextAndFontConstrainedWidth(text, font, width) \
[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) \
options:NSStringDrawingUsesLineFragmentOrigin \
attributes:@{NSFontAttributeName:font} context:nil].size

#define LabelTextSizeWithConstrainedWidth(label, width) \
TextSizeWithTextAndFontConstrainedWidth(label.text, label.font, width)

#define LabelTextSize(label) LabelTextSizeWithConstrainedWidth(label, CGFLOAT_MAX)

//change anchor point and change position
#define DX_ChangeLayerAnchorPointAndAjustPositionToStayFrame(layer, nowAnchorPoint) \
CGPoint DX_lastAnchor = layer.anchorPoint;\
layer.anchorPoint = nowAnchorPoint;\
layer.position = CGPointMake(layer.position.x+(nowAnchorPoint.x-DX_lastAnchor.x)*layer.bounds.size.width, layer.position.y+(nowAnchorPoint.y-DX_lastAnchor.y)*layer.bounds.size.height);\


@interface UIView (ScreenShot)

//target frame should in self coordinator system, so you may use the [self convertRect:targetFrame to:nil] to get the targetFrame
- (UIImage *)screenShotImageWithBounds:(CGRect)targetFrame;
- (UIImage *)screenShotImage;

@end

@interface UIView (MotionEffect)

- (void)centerX_addMotionEffectWithMin:(CGFloat)min max:(CGFloat)max;
- (void)centerY_addMotionEffectWithMin:(CGFloat)min max:(CGFloat)max;

@end

@interface UIView (SearchViews)

- (NSArray *)findRecursiveSubviewsIncludeSelf:(BOOL)include
                            specificPredicate:(BOOL(^)(UIView *aView))block;
- (NSArray *)allRecursiveSubviews;
- (NSArray *)allViewsInHierarchy;
+ (NSArray *)allWindows;
+ (UIWindow *)statusWindow;

@end


@interface UIImage (ImageEffects)

- (BOOL)isLight;

//crop images, supports only aspectFit and UIViewContentModeScaleToFill, default is UIViewContentModeScaleAspectFit
- (UIImage *)thumbnailForSize:(CGSize)thumbnailSize contentMode:(UIViewContentMode)mode;
- (UIImage *)thumbnailForSize:(CGSize)thumbnailSize;
- (UIImage *)thumbnailForScale:(CGFloat)scale;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color cropSize:(CGSize)targetSize;

@end


@interface NSArray (RandomIt)

- (NSArray *)shortIt:(NSInteger)expectCount;
- (NSArray *)shuffle;

@end

@interface UIColor (Colorful)

+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

@end

extern CGRect CenterFrameWithContainerAndContentSize(CGSize containerSize, CGSize contentSize);
extern CGFloat RandomFloatBetweenLowAndHigh(CGFloat low, CGFloat high);


