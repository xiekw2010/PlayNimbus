//
//  ALFLEXBOXUtils.h
//  all_layouts
//
//  Created by xiekw on 15/7/6.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALFLEXBOXUtils : NSObject

+ (NSString *)kContent;
+ (UIView *)randomColorBox;
+ (UILabel *)randomColorLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize;

+ (CGSize)textSizeWithLabel:(UILabel *)label constrainedSize:(CGSize)constrainedSize;

@end

@interface ItemModel : NSObject

@property (nonatomic, assign) NSUInteger currentPrice;
@property (nonatomic, assign) NSUInteger originPrice;
@property (nonatomic, assign) NSUInteger soldedCount;
@property (nonatomic, assign) NSTimeInterval beforeStart;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSArray *promises;
@property (nonatomic, strong) NSArray *comments;

+ (instancetype)randomModel;

@end