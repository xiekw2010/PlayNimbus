//
//  PNPageViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/25.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNPageViewController.h"
#import "NimbusPagingScrollView.h"
#import "UICategory.h"

@interface Page1 : NIPagingScrollViewPage

@end

@implementation Page1
{
    UILabel *_textLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textLabel.font = [UIFont boldSystemFontOfSize:50.0];
        [self addSubview:_textLabel];
        _textLabel.backgroundColor = [UIColor randomColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    [super setPageIndex:pageIndex];
    _textLabel.text = [NSString stringWithFormat:@"%ld", (long)pageIndex];
}

@end

@interface PNPageViewController ()<NIPagingScrollViewDataSource, NIPagingScrollViewDelegate>

@end

@implementation PNPageViewController
{
    NIPagingScrollView *_pageScrollView;
}

- (void)viewDidLoad
{
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect pageFrame = CGRectInset(self.view.bounds, 50.0, 70);
    self.view.backgroundColor = [UIColor randomColorWithAlpha:1.0];
    _pageScrollView = [[NIPagingScrollView alloc] initWithFrame:pageFrame];
    _pageScrollView.clipsToBounds = NO;
    [_pageScrollView scrollView].clipsToBounds = NO;

    _pageScrollView.pageMargin = 8.0;
    _pageScrollView.dataSource = self;
    _pageScrollView.delegate = self;
    [self.view addSubview:_pageScrollView];
    [_pageScrollView reloadData];
}

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    return 10;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
    Page1 *page = (Page1 *)[pagingScrollView dequeueReusablePageWithIdentifier:@"gogo"];
    if (!page) {
        page = [[Page1 alloc] initWithReuseIdentifier:@"gogo"];
    }
    return page;
}

@end
