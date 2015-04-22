//
//  DXBanner.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/21.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusCore.h"

@class DXBanner;

typedef void (^BannerAction)(NSUInteger index, DXBanner *banner);

@protocol DXBannerObject <NSObject>

@property (nonatomic, strong) BannerAction actionBlock;

@end


@interface DXBanner : UIView

@property (nonatomic, strong) NSArray *bannerObjects;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) UIEdgeInsets pageControlInsets;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL infinitScroll;

@end


@interface DXImageBannerObject : NSObject<NICollectionViewCellObject, DXBannerObject>

+ (instancetype)bannerObjectWithPlaceholder:(UIImage *)placeholder imageURL:(NSURL *)URL actionBlock:(BannerAction)action;

- (NSURL *)imageURL;
- (UIImage *)image;


@end

@interface DXBannerCell : UICollectionViewCell<NICollectionViewCell>

@property (nonatomic, strong) UIImageView *imageView;

@end