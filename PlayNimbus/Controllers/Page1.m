//
//  Page1.m
//  PlayNimbus
//
//  Created by xiekw on 15/5/10.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "Page1.h"

@implementation Page1
{
    UIScrollView *_scrollView;
    UILabel *_textLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * 2.0);
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = [UIFont boldSystemFontOfSize:50.0];
        _textLabel.backgroundColor = [UIColor randomColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_scrollView];
        [_scrollView addSubview:_textLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
    _textLabel.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * 2.0);
    [self setNeedsDisplay];
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    [super setPageIndex:pageIndex];
    _textLabel.text = [NSString stringWithFormat:@"%ld", (long)pageIndex];
}

@end
