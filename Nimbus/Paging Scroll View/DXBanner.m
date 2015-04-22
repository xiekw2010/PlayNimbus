//
//  DXBanner.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/21.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXBanner.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DXBanner ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DXBanner
{
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    CGRect bounds = self.bounds;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    _collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _autoScroll = YES;
    _infinitScroll = YES;
    [self addSubview:_collectionView];
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_pageControl];
}

- (void)setBannerObjects:(NSArray *)bannerObjects
{
    if ([bannerObjects isKindOfClass:[NSArray class]] && bannerObjects.count > 0) {
        _pageControl.numberOfPages = bannerObjects.count;
        if (_infinitScroll) {
            NSMutableArray *doubleObjs = [bannerObjects mutableCopy];
            [doubleObjs addObjectsFromArray:bannerObjects];
            _bannerObjects = doubleObjs;
        }else {
            _bannerObjects = bannerObjects;
            
        }
        [self setNeedsDisplay];
        [_collectionView reloadData];
        if (_infinitScroll) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_bannerObjects.count/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bannerObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id object = [_bannerObjects objectAtIndex:indexPath.row];
    Class cellClass = [UICollectionViewCell class];
    if ([object respondsToSelector:@selector(collectionViewCellClass)]) {
        cellClass = [object collectionViewCellClass];
    }
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [cell shouldUpdateCellWithObject:object];
    }
    _pageControl.currentPage = indexPath.row % (_bannerObjects.count/2);
    
//    if (_infinitScroll) {
//        NSUInteger half = _bannerObjects.count / 2;
//        NSUInteger currentPage = indexPath.row % half;
//        if (currentPage == half - 1 || currentPage == 1) { // to end now, move the preivous to the end
//            NSArray *pArray = [_bannerObjects subarrayWithRange:NSMakeRange(0, half)];
//            NSArray *eArray = [_bannerObjects subarrayWithRange:NSMakeRange(half, half)];
//            
//            NSMutableArray *result = [NSMutableArray array];
//            if (currentPage == half - 1) {
//                [result addObjectsFromArray:eArray];
//                [result addObjectsFromArray:pArray];
//            }else {
//                [result addObjectsFromArray:pArray];
//                [result addObjectsFromArray:eArray];
//            }
//            _bannerObjects = result;
//            [_collectionView reloadData];
//        }
//    }
    
    return cell;
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_bannerObjects objectAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self objectAtIndexPath:indexPath];
    if ([obj conformsToProtocol:@protocol(DXBannerObject)]) {
        id<DXBannerObject> dobj = obj;
        dobj.actionBlock(indexPath.row, self);
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _collectionView.frame = bounds;
    CGSize pagecontrolSize = [_pageControl sizeForNumberOfPages:_bannerObjects.count];
    _pageControl.frame = CGRectMake(NICenterX(bounds.size, pagecontrolSize), CGRectGetHeight(bounds) - pagecontrolSize.height, pagecontrolSize.width, pagecontrolSize.height);
}

@end


@implementation DXImageBannerObject
{
    NSURL *_imageURL;
    UIImage *_image;
    BannerAction _actionBlock;
}

@synthesize actionBlock = _actionBlock;

- (Class)collectionViewCellClass
{
    return [DXBannerCell class];
}

+ (instancetype)bannerObjectWithPlaceholder:(UIImage *)placeholder imageURL:(NSURL *)URL actionBlock:(BannerAction)action;
{
    DXImageBannerObject *obj = [DXImageBannerObject new];
    obj->_imageURL = URL;
    obj->_image = placeholder;
    obj->_actionBlock = action;
    return obj;
}

- (NSURL *)imageURL
{
    return _imageURL;
}

- (UIImage *)image
{
    return _image;
}

@end

@implementation DXBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ([object isKindOfClass:[DXImageBannerObject class]]) {
        DXImageBannerObject *obj = object;
        [_imageView sd_setImageWithURL:obj.imageURL placeholderImage:obj.image];
    }
    return YES;
}

@end