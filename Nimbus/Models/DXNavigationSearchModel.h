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
@property (nonatomic, weak) id<DXSearchModelDelegate> delegate;
@property (nonatomic, strong) NSArray *hotTagObjects;
@property (nonatomic, strong) UIImage *tableViewBackgroundImage;

- (instancetype)initWithTarget:(UIViewController *)vc;

@end

