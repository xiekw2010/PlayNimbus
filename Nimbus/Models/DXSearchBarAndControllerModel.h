//
//  DXSearchBarAndControllerModel.h
//  PlayNimbus
//
//  Created by xiekw on 15/3/26.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NIMutableTableViewModel;
@class NITableViewActions;
@class DXSearchBarAndControllerModel;

typedef void (^DXSearchResultBlock)(NSArray *results, NSString *searchText, NSString *searchScope);

@protocol DXSearchBarDelegate <NSObject>

@required
/**
 *  The search logic by the viewcontroller
 *
 *  @param currentText using search text
 *  @param field       using search scope
 *  @param searchBar   the search obj
 *  @param block       reuslts must imp the - (id)cellClass method, and use displayTableViewActions to attach the actions from the result.
 */
- (void)filteredResultWithText:(NSString *)currentText
                    scopeField:(NSString *)field
                     searchBar:(UISearchBar *)searchBar
                   resultBlock:(DXSearchResultBlock)block;

@optional
- (BOOL)shouldCongfigSearchDimmingView:(UIView *)dimmingView;

@end

@interface DXSearchBarAndControllerModel : NSObject<UISearchBarDelegate, UISearchDisplayDelegate>

- (instancetype)initWithContentsViewController:(UIViewController *)contentsViewController searchScopes:(NSArray *)scopes predicateDelegate:(id<DXSearchBarDelegate>)delegate;

@property (nonatomic, weak) id<DXSearchBarDelegate> searchPredicateDelegate;
@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UISearchDisplayController *displayController;
@property (nonatomic, weak, readonly) UIViewController *contentsViewController;
@property (nonatomic, strong, readonly) NIMutableTableViewModel *displayTableViewModel;
@property (nonatomic, strong, readonly) NITableViewActions *displayTableViewActions;

@end
