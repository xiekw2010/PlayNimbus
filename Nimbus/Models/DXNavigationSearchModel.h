//
//  DXNavigationSearchModel.h
//  Kwiki
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 PC Modudu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSearchBarAndControllerModel.h"
#import "NimbusCore.h"


@interface DXNavigationSearchModel : NSObject

@property (nonatomic, strong, readonly) UISearchBar *navSearchBar;
@property (nonatomic, weak) UIViewController *contentsViewController;
@property (nonatomic, weak) id<DXSearchModelDelegate> delegate;
@property (nonatomic, weak) id<DXSearchModelHistoryDataSource> dataSource;

- (instancetype)initWithTarget:(UIViewController *)vc;

@end


@protocol DXSearchHotView <NSObject>

@optional
- (NSString *)title;

@end

@interface DXSearchHotView : UIView<DXSearchHotView>

- (id)initWithTarget:(id)actionTarget hotTags:(NSArray *)hotTags title:(NSString *)title;

- (NSString *)title;

@end