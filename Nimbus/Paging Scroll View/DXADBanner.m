//
//  DXADBanner.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXADBanner.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DXADBanner ()<NIPagingScrollViewDataSource, NIPagingScrollViewDelegate>

@property (nonatomic, strong) NIPagingScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation DXADBanner

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _scrollView = [[NIPagingScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
    _scrollView.pageMargin = 0.0;
    _scrollView.type = NIPagingScrollViewHorizontal;
    
    [self addSubview:_scrollView];
    
    // page control
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPage:)];
    [_scrollView addGestureRecognizer:tap];
}

- (void)didTapPage:(id)sender
{
    NSUInteger currentIndex = _scrollView.centerPageIndex - 1;
    id item = self.adItems[currentIndex - 1];
    NSLog(@"didTap %ld and item is %@", currentIndex, item);
}

- (void)setAdItems:(NSArray *)adItems
{
    _adItems = adItems;
    _pageControl.numberOfPages = _adItems.count;
    [_scrollView reloadData];
    [_scrollView moveToPageAtIndex:1 animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _scrollView.frame = bounds;
    
    CGSize pageSize = [_pageControl sizeForNumberOfPages:_adItems.count];
    _pageControl.frame = CGRectMake(NICenterX(bounds.size, pageSize), bounds.size.height - pageSize.height, pageSize.width, pageSize.height);
}

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
    
    if (_adItems != nil) {
        return [_adItems count] > 1 ? [_adItems count] + 2 : [_adItems count];
    }
    return 0;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView
                                    pageViewForIndex:(NSInteger)pageIndex {
    
    static NSString *Identifier = @"Banner";
    DXADBannerPage *page = (DXADBannerPage *)[pagingScrollView dequeueReusablePageWithIdentifier:Identifier];
    if (page == nil) {
        page = [[DXADBannerPage alloc] initWithReuseIdentifier:Identifier];
    }
    
    // the image of AD may be changes at next time
    CGSize size = self.bounds.size;
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    if (!CGRectEqualToRect(page.bounds, rect)) {
        page.bounds = rect;
    }
    
    NSInteger dataSourceIndex = 0;
    if ([_adItems count] > 1) {
        if (pageIndex == 0) {
            dataSourceIndex = [_adItems count] -1;
        }else if (pageIndex == [_adItems count] + 1){
            dataSourceIndex = 0;
        }else{
            dataSourceIndex = pageIndex - 1;
        }
    }else{
        dataSourceIndex = pageIndex;
    }
    id<DXADBannerItem>item = _adItems[dataSourceIndex];
    [page.imageView sd_setImageWithURL:item.imageURL placeholderImage:item.placeholder];
    
    return page;
}


/////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark JMPagingScrollView delegate methods

- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView {
    if ([_adItems count] > 1) {
        if(pagingScrollView.centerPageIndex == 0){
            
            [pagingScrollView moveToPageAtIndex:[_adItems count]  animated:NO];
            
        }else if (pagingScrollView.centerPageIndex == [_adItems count] + 1){
            
            [pagingScrollView moveToPageAtIndex:1 animated:NO];
            
        }
        _pageControl.currentPage = pagingScrollView.centerPageIndex - 1;
        
    }else{
        _pageControl.currentPage = pagingScrollView.centerPageIndex;
    }
}


@end

@implementation DXADBannerPage

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end

@interface DXImageBannerItem ()

@end

@implementation DXImageBannerItem

@synthesize placeholder = _placeholder, imageURL = _imageURL, action = _action;

+ (id)bannerObjectWithPlaceholder:(UIImage *)placeholder imageURL:(NSURL *)imageURL actionBlock:(DXBannerAction)action
{
    DXImageBannerItem *item = [DXImageBannerItem new];
    item.placeholder = placeholder;
    item.imageURL = imageURL;
    item.action = action;
    return item;
}

@end
