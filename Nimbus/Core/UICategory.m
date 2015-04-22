//
//  UICategory.m
//  MoreLikers
//
//  Created by xiekw on 14-1-20.
//  Copyright (c) 2014年 周和生. All rights reserved.
//

#import "UICategory.h"
#import <float.h>
#import <Accelerate/Accelerate.h>

@implementation UIView (ScreenShot)

- (UIImage *)screenShotImageWithBounds:(CGRect)selfBounds
{
    UIGraphicsBeginImageContextWithOptions(selfBounds.size, NO, 0);
    [self drawViewHierarchyInRect:CGRectMake(-selfBounds.origin.x, -selfBounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)screenShotImage;
{
    return [self screenShotImageWithBounds:self.bounds];
}

@end

@implementation UIView (MotionEffect)

- (void)centerX_addMotionEffectWithMin:(CGFloat)min max:(CGFloat)max
{
    if (![self respondsToSelector:@selector(addMotionEffect:)]) {
        return;
    }
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.minimumRelativeValue = @(min);
    effectX.maximumRelativeValue = @(max);
    [self addMotionEffect:effectX];
}

- (void)centerY_addMotionEffectWithMin:(CGFloat)min max:(CGFloat)max
{
    if (![self respondsToSelector:@selector(addMotionEffect:)]) {
        return;
    }
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.minimumRelativeValue = @(min);
    effectY.maximumRelativeValue = @(max);
    [self addMotionEffect:effectY];
}

@end

@implementation UIView (SearchViews)

- (NSArray *)findRecursiveSubviewsIncludeSelf:(BOOL)include
                            specificPredicate:(BOOL(^)(UIView *aView))block
{
    NSMutableArray *mArray = [NSMutableArray array];
    if (include && block(self)) {
        [mArray addObject:self];
    }
    [mArray addObjectsFromArray:[[self allRecursiveSubviews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]]];
    return mArray;
}

// FLEX: https://github.com/Flipboard/FLEX FLEXExplorerViewController.m
- (NSArray *)allRecursiveSubviews
{
    NSMutableArray *subviews = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        [subviews addObject:subview];
        [subviews addObjectsFromArray:[subview allRecursiveSubviews]];
    }
    return subviews;
}

- (NSArray *)allViewsInHierarchy
{
    NSMutableArray *allViews = [NSMutableArray array];
    NSArray *windows = [[self class] allWindows];
    for (UIWindow *window in windows) {
        if (window != self.window) {
            [allViews addObject:window];
            [allViews addObjectsFromArray:[window allRecursiveSubviews]];
        }
    }
    return allViews;
}

+ (NSArray *)allWindows
{
    NSMutableArray *windows = [[[UIApplication sharedApplication] windows] mutableCopy];
    UIWindow *statusWindow = [self statusWindow];
    if (statusWindow) {
        // The windows are ordered back to front, so default to inserting the status bar at the end.
        // However, it there are windows at status bar level, insert the status bar before them.
        NSInteger insertionIndex = [windows count];
        for (UIWindow *window in windows) {
            if (window.windowLevel >= UIWindowLevelStatusBar) {
                insertionIndex = [windows indexOfObject:window];
                break;
            }
        }
        [windows insertObject:statusWindow atIndex:insertionIndex];
    }
    return windows;
}

+ (UIWindow *)statusWindow
{
    NSString *statusBarString = [NSString stringWithFormat:@"%@arWindow", @"_statusB"];
    return [[UIApplication sharedApplication] valueForKey:statusBarString];
}

@end

@implementation UIImage (ImageEffects)


- (UIImage *)thumbnailForSize:(CGSize)thumbnailSize contentMode:(UIViewContentMode)mode
{
    if (self.size.width == self.size.height) {
        mode = UIViewContentModeScaleAspectFill;
    }
    UIImage *resultImage;
    CGRect bounds = CGRectZero;
    bounds.size = thumbnailSize;
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, 0);

    if (mode == UIViewContentModeScaleAspectFill) {
        [self drawInRect:bounds];
    }else {
        CGFloat minSize = MIN(self.size.width, self.size.height);
        CGRect cropRect = CGRectZero;
        cropRect.size = CGSizeMake(minSize, minSize);
        if (self.size.width >= self.size.height) {
            cropRect.origin.x = (self.size.width - minSize)*0.5;
        }else {
            cropRect.origin.y = (self.size.height - minSize)*0.5;
        }
        
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [croppedImage drawInRect:bounds];
    }
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return resultImage;
}

- (UIImage *)thumbnailForSize:(CGSize)thumbnailSize;
{
    return [self thumbnailForSize:thumbnailSize contentMode:UIViewContentModeScaleAspectFit];
}

- (UIImage *)thumbnailForScale:(CGFloat)scale
{
    return [self thumbnailForSize:CGSizeMake(self.size.width*scale, self.size.height*scale) contentMode:UIViewContentModeScaleAspectFill];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color cropSize:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color cropSize:(CGSize)targetSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, targetSize.width, targetSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)isLight
{
    BOOL imageIsLight = NO;
    
    CGImageRef imageRef = [self CGImage];
    CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
    NSData *pixelData = (__bridge_transfer NSData *)CGDataProviderCopyData(dataProviderRef);
    
    if ([pixelData length] > 0) {
        const UInt8 *pixelBytes = [pixelData bytes];
        
        
        // Whether or not the image format is opaque, the first byte is always the alpha component, followed by RGB.
        UInt8 pixelR = pixelBytes[1];
        UInt8 pixelG = pixelBytes[2];
        UInt8 pixelB = pixelBytes[3];
        
        // Calculate the perceived luminance of the pixel; the human eye favors green, followed by red, then blue.
        double percievedLuminance = 1 - (((0.299 * pixelR) + (0.587 * pixelG) + (0.114 * pixelB)) / 255);
        
        imageIsLight = percievedLuminance < 0.5;
    }
    
    return imageIsLight;
}

@end

@implementation NSArray (RandomIt)

- (NSArray *)shortIt:(NSInteger)expectCount
{
    NSRange limitRange;
    limitRange.location = 0;
    limitRange.length = MIN(expectCount, self.count);
    return [self subarrayWithRange:limitRange];
}

@end

@implementation UIColor (Colorful)

+ (UIColor *)randomColor
{
    return [self randomColorWithAlpha:1.0];
}

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha
{
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

CGRect CenterFrameWithContainerAndContentSize(CGSize containerSize, CGSize imageSize)
{
    CGSize bigImageSize = imageSize;
    CGFloat imageWidth = MIN(containerSize.width, bigImageSize.width);
    bigImageSize.height = imageWidth/bigImageSize.width*bigImageSize.height;
    bigImageSize.width = imageWidth;
    CGRect bigImageTargetFrame = CGRectMake((containerSize.width-bigImageSize.width)*0.5, (containerSize.height-bigImageSize.height)*0.5, bigImageSize.width, bigImageSize.height);
    return bigImageTargetFrame;
}

CGFloat RandomFloatBetweenLowAndHigh(CGFloat low, CGFloat high)
{
    CGFloat diff = high - low;
    return (((CGFloat) rand() / RAND_MAX) * diff) + low;
}
