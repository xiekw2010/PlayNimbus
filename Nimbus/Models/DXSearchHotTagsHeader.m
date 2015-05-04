//
//  DXSearchHotTagsHeader.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchHotTagsHeader.h"
#import "DXSearchBarAndControllerModel.h"
#import "DXSearchHotTagObject.h"

static CGFloat const buttonHeight = 40.0;
static CGFloat const buttonMargin = 7.0;
static CGFloat const lineSpacing = 5.0;
static NSUInteger const column = 3;

static inline UIEdgeInsets contentInset() {
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
}

static inline NSUInteger calLineCount(NSUInteger objsCount) {
    return (NSUInteger)ceilf((CGFloat)objsCount / (CGFloat)column);
}

@implementation DXSearchHotTagsHeader
{
    NSArray *_hotTags;
    __weak DXSearchBarAndControllerModel *_searchModel;
    CGFloat _buttonWidth;
}

- (id)initWithHotTags:(NSArray *)hotTags containerViewController:(DXSearchBarAndControllerModel *)searchModel
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat height = [[self class] heightForHotTagsCount:hotTags.count];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, height)]) {
        _buttonWidth = (screenSize.width - contentInset().left - contentInset().right - (column - 1) * buttonMargin) / column;
        _searchModel = searchModel;
        _hotTags = hotTags;
        NSUInteger lc = calLineCount(_hotTags.count);
        for (int i = 0; i < lc; i ++) {
            NSUInteger cm = (_hotTags.count - i * column);
            for (int j = 0; j < cm; j ++) {
                DXSearchHotTagButton *btn = [DXSearchHotTagButton new];
                NSUInteger currentIndex = i * column + j;
                btn.tag = currentIndex;
                id<DXHotTagObject> obj = _hotTags[currentIndex];
                [btn setTitle:obj.title forState:UIControlStateNormal];
                btn.frame = [self tagButtonFrameForLine:i column:j];
                [self addSubview:btn];
                [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

- (void)btnTapped:(DXSearchHotTagButton *)btn
{
    DXSearchHotTagObject *tagObj = _hotTags[btn.tag];
    if (tagObj.action) {
        tagObj.action(_searchModel.contentsViewController, _searchModel, tagObj);
    }
}

- (CGRect)tagButtonFrameForLine:(NSUInteger)line column:(NSUInteger)column
{
    CGRect result = CGRectZero;
    result.origin.x = contentInset().left + column * (_buttonWidth + buttonMargin);
    result.origin.y = contentInset().top + line * (buttonHeight + lineSpacing);
    result.size = CGSizeMake(_buttonWidth, buttonHeight);
    return result;
}

+ (CGFloat)heightForHotTagsCount:(NSUInteger)count
{
    NSUInteger lineCount = calLineCount(count);
    CGFloat result = contentInset().top + contentInset().bottom + (buttonHeight * lineCount) + lineSpacing * (lineCount - 1);
    return result;
}

@end

@implementation DXSearchHotTagButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}

@end