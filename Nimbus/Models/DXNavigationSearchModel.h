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

@protocol DXHistorySearchDelegate <NSObject>

@end

@interface DXNavigationSearchModel : NSObject

@property (nonatomic, strong) UISearchBar *navSearchBar;
@property (nonatomic, weak) UIViewController *contentsViewController;
@property (nonatomic, weak) id<DXSearchModelDelegate> delegate;

- (instancetype)initWithTarget:(UIViewController *)vc;

@end


// use the Designated initializer sepcify the cell class
@interface DXSearchHistoryCellObject : NSObject<NSCoding, NICellObject>

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *name;


+ (NSArray *)historyObjects;
+ (void)enqueueObject:(DXSearchHistoryCellObject *)object;
+ (void)dequeueObject:(DXSearchHistoryCellObject *)object;

@end

@interface DXSearchHistoryCell : UITableViewCell<NICell>

@end