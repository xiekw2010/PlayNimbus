//
//  JUFLXCSSParser.m
//  all_layouts
//
//  Created by xiekw on 15/7/8.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "JUFLXCSSParser.h"
#import "JUFLXNode.h"

#define SetValueWithDefaultValue(A, B) ((A) = (A) > 0 ? (A) : (B));

NSString * const kHRCSSDirection = @"flex-direction";
NSString * const kHRCSSDirectionRow = @"row";
NSString * const kHRCSSDirectionRowReverse = @"row-reverse";
NSString * const kHRCSSDirectionColumn = @"column";
NSString * const kHRCSSDirectionColumnReverse = @"column-reverse";

NSString * const kHRCSSAlignItems = @"align-items";
NSString * const kHRCSSAlignContent = @"align-content";
NSString * const kHRCSSAlignSelf = @"align-self";
NSString * const kHRCSSAlignAuto = @"auto";
NSString * const kHRCSSAlignStart = @"flex-start";
NSString * const kHRCSSAlignCenter = @"center";
NSString * const kHRCSSAlignEnd = @"flex-end";
NSString * const kHRCSSAlignStretch = @"stretch";

NSString * const kHRCSSjustifyContent = @"justify-content";
NSString * const kHRCSSjustifyContentStart = @"flex-start";
NSString * const kHRCSSjustifyContentCenter = @"center";
NSString * const kHRCSSjustifyContentEnd = @"flex-end";
NSString * const kHRCSSjustifyContentBetween = @"space-between";
NSString * const kHRCSSjustifyContentAround = @"space-around";

NSString * const kHRCSSFlex = @"flex";
NSString * const kHRCSSFlexWrap = @"flex-wrap";

NSString * const kHRCSSDimensionWidth = @"width";
NSString * const kHRCSSDimensionHeight = @"height";

NSString * const kHRCSSMinDimensionWidth = @"min-width";
NSString * const kHRCSSMinDimensionHeight = @"min-height";

NSString * const kHRCSSMaxDimensionWidth = @"max-width";
NSString * const kHRCSSMaxDimensionHeight = @"max-height";

NSString * const kHRCSSMargin = @"margin";
NSString * const kHRCSSMarginLeft = @"margin-left";
NSString * const kHRCSSMarginTop = @"margin-top";
NSString * const kHRCSSMarginBottom = @"margin-bottom";
NSString * const kHRCSSMarginRight = @"margin-right";

NSString * const kHRCSSPadding = @"padding";
NSString * const kHRCSSPaddingLeft = @"padding-left";
NSString * const kHRCSSPaddingTop = @"padding-top";
NSString * const kHRCSSPaddingBottom = @"padding-bottom";
NSString * const kHRCSSPaddingRight = @"padding-right";

@implementation JUFLXCSSParser

/**
 *  Stand is @"diretion:row;alignitems:auto;justifyContent:start"
 */
+ (NSDictionary *)transferInlineCSS:(NSString *)inlineCSS {
    if ([inlineCSS hasPrefix:@"{"]) inlineCSS = [inlineCSS substringFromIndex:1];
    if ([inlineCSS hasSuffix:@"}"]) inlineCSS = [inlineCSS substringToIndex:inlineCSS.length - 1];

    
    NSArray *inlineArray = [inlineCSS componentsSeparatedByString:@","];
    if (inlineArray.count == 0) {
        if (inlineCSS.length > 0) {
            NSLog(@"===>JUFLXNode inlineCSS string maybe be wrong, check it %@", inlineCSS);
            return nil;
        }
    };
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSCharacterSet *whiteAndNewLine = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for (NSString *kv in inlineArray) {
        NSArray *kvArray = [kv componentsSeparatedByString:@":"];
        if (kvArray.count == 2) {
            NSString *key = kvArray[0];
            NSString *value = kvArray[1];
            if ([key isKindOfClass:[NSString class]]
                && key.length > 0
                && [value isKindOfClass:[NSString class]]
                && value.length > 0) {
                
                key = [[key stringByTrimmingCharactersInSet:whiteAndNewLine] lowercaseString];
                value = [[value stringByTrimmingCharactersInSet:whiteAndNewLine] lowercaseString];
                result[key] = value;
            }
        }
    }
    
    return result;
}

+ (NSSet *)validInlineCssKeys {
    static dispatch_once_t onceToken;
    static NSSet *set;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:
               kHRCSSDirection,
               kHRCSSAlignItems,
               kHRCSSAlignContent,
               kHRCSSjustifyContent,
               kHRCSSFlexWrap,
               kHRCSSAlignSelf,
               kHRCSSFlex,
               kHRCSSDimensionWidth,
               kHRCSSDimensionHeight,
               kHRCSSMinDimensionWidth,
               kHRCSSMinDimensionHeight,
               kHRCSSMaxDimensionWidth,
               kHRCSSMaxDimensionHeight,
               kHRCSSMargin,
               kHRCSSMarginTop,
               kHRCSSMarginLeft,
               kHRCSSMarginBottom,
               kHRCSSMarginRight,
               kHRCSSPadding,
               kHRCSSPaddingTop,
               kHRCSSPaddingLeft,
               kHRCSSPaddingBottom,
               kHRCSSPaddingRight,
               nil];
    });
    return set;

}

+ (NSDictionary *)validDirections {
    static dispatch_once_t onceToken;
    static NSDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = @{kHRCSSDirectionColumn : @(JUFLXLayoutDirectionColumn),
                kHRCSSDirectionRow : @(JUFLXLayoutDirectionRow),
                kHRCSSDirectionRowReverse : @(JUFLXLayoutDirectionRowReverse),
                kHRCSSDirectionColumnReverse : @(JUFLXLayoutDirectionColumnReverse)};
    });
    return dic;
}

+ (NSDictionary *)validAlignments {
    static dispatch_once_t onceToken;
    static NSDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = @{kHRCSSAlignAuto : @(JUFLXLayoutAlignmentAuto),
                kHRCSSAlignStart : @(JUFLXLayoutAlignmentStart),
                kHRCSSAlignCenter : @(JUFLXLayoutAlignmentCenter),
                kHRCSSAlignEnd : @(JUFLXLayoutAlignmentEnd),
                kHRCSSAlignStretch : @(JUFLXLayoutAlignmentStretch)};
    });
    return dic;
}

+ (NSDictionary *)validjustifyContents {
    static dispatch_once_t onceToken;
    static NSDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = @{kHRCSSjustifyContentStart : @(JUFLXLayoutJustifyContentStart),
                kHRCSSjustifyContentCenter : @(JUFLXLayoutJustifyContentCenter),
                kHRCSSjustifyContentEnd : @(JUFLXLayoutJustifyContentEnd),
                kHRCSSjustifyContentBetween : @(JUFLXLayoutJustifyContentBetween),
                kHRCSSjustifyContentAround : @(JUFLXLayoutJustifyContentAround),
                };
    });
    return dic;

}

+ (NSInteger)mappedEnumValueInDictionary:(NSDictionary *)dic withKey:(NSString *)key {
    NSString *value = [dic objectForKey:key];
    if (!value) {
        NSLog(@"%@ isn't a valid key in valid Dic %@", key, dic);
        NSUInteger initialValue = 0;
        if ([key isEqualToString:kHRCSSDirection]) {
            initialValue = JUFLXLayoutDirectionRow;
            
        } else if ([key isEqualToString:kHRCSSAlignItems]) {
            initialValue = JUFLXLayoutAlignmentStretch;
            
        } else if ([key isEqualToString:kHRCSSjustifyContent]) {
            initialValue = JUFLXLayoutJustifyContentStart;
            
        } else if ([key isEqualToString:kHRCSSAlignSelf]) {
            initialValue = JUFLXLayoutAlignmentAuto;
            
        } else if ([key isEqualToString:kHRCSSAlignContent]) {
            initialValue = JUFLXLayoutAlignmentStretch;
        }
            
        return initialValue;
    }
    
    return [value integerValue];
}

+ (void)parseInlineCSS:(NSString *)inlineCSS toNode:(JUFLXNode *)node {
    NSDictionary *inlineDic = [self transferInlineCSS:inlineCSS];

    //filter the invalid key and log
#if DEBUG
    id predicateBlock = ^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![[self validInlineCssKeys] containsObject:evaluatedObject];
    };
    NSArray *invalidKeys = [inlineDic.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:predicateBlock]];
    if (invalidKeys.count) {
        NSLog(@"===>JUFLXNode valid keys %@ doesn't contain these keys %@ \n Please check -> JUFLXNode.h", [self validInlineCssKeys], invalidKeys);
    }
#endif
    
    NSString *direction = inlineDic[kHRCSSDirection];
    if (direction) node.direction = [self mappedEnumValueInDictionary:[self validDirections] withKey:direction];
    
    NSString *alignItems = inlineDic[kHRCSSAlignItems];
    if (alignItems) node.alignItems = [self mappedEnumValueInDictionary:[self validAlignments] withKey:alignItems];
    
    NSString *alignSelf = inlineDic[kHRCSSAlignSelf];
    if (alignSelf) node.alignSelf = [self mappedEnumValueInDictionary:[self validAlignments] withKey:alignSelf];
    
    NSString *alignContent = inlineDic[kHRCSSAlignContent];
    if (alignContent) node.alignContent = [self mappedEnumValueInDictionary:[self validAlignments] withKey:alignContent];
    
    NSString *justifyContent = inlineDic[kHRCSSjustifyContent];
    if (justifyContent) node.justifyContent = [self mappedEnumValueInDictionary:[self validjustifyContents] withKey:justifyContent];
    
    NSString *flex = inlineDic[kHRCSSFlex];
    if (flex) {
        if ([flex integerValue] != NSNotFound) {
            node.flex = ABS([flex integerValue]);
        }
    }
    
    NSString *flexwarp = inlineDic[kHRCSSFlexWrap];
    if (flexwarp) {
        node.flexWrap = [flexwarp boolValue];
    }
    
    CGFloat width = [inlineDic[kHRCSSDimensionWidth] floatValue];
    SetValueWithDefaultValue(width, node.dimensions.width)
    CGFloat height = [inlineDic[kHRCSSDimensionHeight] floatValue];
    SetValueWithDefaultValue(height, node.dimensions.height)
    node.dimensions = CGSizeMake(width, height);
    
    CGFloat minWidth = [inlineDic[kHRCSSMinDimensionWidth] floatValue];
    SetValueWithDefaultValue(minWidth, node.minDimensions.width)
    CGFloat minHeight = [inlineDic[kHRCSSMinDimensionHeight] floatValue];
    SetValueWithDefaultValue(minHeight, node.minDimensions.height)
    node.minDimensions = CGSizeMake(minWidth, minHeight);

    CGFloat maxWidth = [inlineDic[kHRCSSMaxDimensionWidth] floatValue];
    SetValueWithDefaultValue(maxWidth, node.maxDimensions.width)
    CGFloat maxHeight = [inlineDic[kHRCSSMaxDimensionHeight] floatValue];
    SetValueWithDefaultValue(maxHeight, node.maxDimensions.height)
    node.maxDimensions = CGSizeMake(maxWidth, maxHeight);

    CGFloat margin = [inlineDic[kHRCSSMargin] floatValue];
    if (margin > 0) node.margin = UIEdgeInsetsMake(margin, margin, margin, margin);
    CGFloat marginTop = [inlineDic[kHRCSSMarginTop] floatValue];
    SetValueWithDefaultValue(marginTop, node.margin.top)
    CGFloat marginLeft = [inlineDic[kHRCSSMarginLeft] floatValue];
    SetValueWithDefaultValue(marginLeft, node.margin.left)
    CGFloat marginBottom = [inlineDic[kHRCSSMarginBottom] floatValue];
    SetValueWithDefaultValue(marginBottom, node.margin.bottom)
    CGFloat marginRight = [inlineDic[kHRCSSMarginRight] floatValue];
    SetValueWithDefaultValue(marginRight, node.margin.right);
    node.margin = UIEdgeInsetsMake(marginTop, marginLeft, marginBottom, marginRight);
    
    CGFloat padding = [inlineDic[kHRCSSPadding] floatValue];
    if (padding > 0) node.padding = UIEdgeInsetsMake(padding, padding, padding, padding);
    CGFloat paddingTop = [inlineDic[kHRCSSPaddingTop] floatValue];
    SetValueWithDefaultValue(paddingTop, node.padding.top)
    CGFloat paddingLeft = [inlineDic[kHRCSSPaddingLeft] floatValue];
    SetValueWithDefaultValue(paddingLeft, node.padding.left)
    CGFloat paddingBottom = [inlineDic[kHRCSSPaddingBottom] floatValue];
    SetValueWithDefaultValue(paddingBottom, node.padding.bottom)
    CGFloat paddingRight = [inlineDic[kHRCSSPaddingRight] floatValue];
    SetValueWithDefaultValue(paddingRight, node.padding.right)
    node.padding = UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight);
}


@end
