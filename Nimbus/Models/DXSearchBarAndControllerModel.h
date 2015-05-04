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

@protocol DXSearchModelDelegate <NSObject>

@required
/**
 *  The search logic by the viewcontroller
 *
 *  @param currentText using search text
 *  @param field       using search scope
 *  @param searchBar   the search obj
 *  @param block       reuslts must imp the - (id)cellClass method, and use displayTableViewActions to attach the actions from the result.
 */
- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText
         scopeField:(NSString *)field
        resultBlock:(DXSearchResultBlock)block;

@end



@interface DXSearchBarAndControllerModel : NSObject<UISearchDisplayDelegate, UISearchBarDelegate>

- (instancetype)initWithContentsViewController:(UIViewController *)contentsViewController searchScopes:(NSArray *)scopes predicateDelegate:(id<DXSearchModelDelegate>)delegate;

@property (nonatomic, weak) id<DXSearchModelDelegate> searchPredicateDelegate;
// default is YES;
@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, weak, readonly) UIViewController *contentsViewController;
@property (nonatomic, strong, readonly) UISearchDisplayController *displayController;
@property (nonatomic, strong, readonly) NITableViewActions *displayTableViewActions;
//uses for history tableview, searching tableview, result tableView, for these three.
@property (nonatomic, assign, getter=isUsingHistory) BOOL usingHistory;
@property (nonatomic, strong) UIImage *tableViewBackgroundImage;
//Must conforms to <DXHotTagObject>
@property (nonatomic, strong) NSArray *hotTagObjects;

- (void)refreshTheResultTableViewWithSearchText:(NSString *)sText;

@end
