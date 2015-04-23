//
//  DXSearchHotTagsHeader.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchHotTagsHeader.h"

static CGFloat const buttonHeight = 40.0;
static CGFloat const buttonMargin = 7.0;
static NSUInteger const column = 3;

@implementation DXSearchHotTagsHeader
{
    NSArray *_hotTags;
}

- (id)initWithHotTags:(NSArray *)hotTags
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat height = [[self class] heightForHotTagsCount:hotTags.count];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, height)]) {
        _hotTags = hotTags;
        NSUInteger lineCount = floorl(_hotTags.count / column);
        for (int i = 0; i < lineCount; i ++) {
            for (int j = 0; j < column; j ++) {
                DXSearchHotTagButton *btn = [DXSearchHotTagButton new];
            }
        }
    }
    return self;
}

- (CGRect)tagButtonFrameForLine:(NSUInteger)line column:(NSUInteger)column
{
    return CGRectZero;
}

+ (CGFloat)heightForHotTagsCount:(NSUInteger)count
{
    return count > 3 ? buttonHeight * (buttonHeight * 2 + buttonMargin * 3) : (buttonHeight + buttonMargin * 2);
}

@end

@implementation DXSearchHotTagObject

+ (instancetype)objectWithTitle:(NSString *)title action:(DXSearchHotTagAction)action
{
    DXSearchHotTagObject *obj = [DXSearchHotTagObject new];
    obj.title = title;
    obj.action = action;
    return self;
}

@end

@implementation DXSearchHotTagButton


@end