//
//  DXADBanner.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "NIPagingScrollView.h"
#import "NIPagingScrollViewPage.h"

@class DXADBanner;

typedef void (^DXBannerAction)(NSUInteger index, DXADBanner *banner);


@protocol DXADBannerItem <NSObject>

@optional
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) DXBannerAction action;
@property (nonatomic, strong) UIImage *placeholder;

@end



@interface DXADBanner : UIView

@property (nonatomic, strong) NSArray *adItems;
@property (nonatomic, assign) BOOL autoSroll;

@end


@interface DXADBannerPage : NIPagingScrollViewPage

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface DXImageBannerItem : NSObject<DXADBannerItem>

+ (id)bannerObjectWithPlaceholder:(UIImage *)placeholder imageURL:(NSURL *)imageURL actionBlock:(DXBannerAction)action;


@end