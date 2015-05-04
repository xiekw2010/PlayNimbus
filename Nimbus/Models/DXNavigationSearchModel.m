//
//  DXNavigationSearchModel.m
//  Kwiki
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXNavigationSearchModel.h"
#import "DXSearchHistoryCellObject.h"

@interface DXSearchViewController : UITableViewController

@property (nonatomic, strong) DXSearchBarAndControllerModel *searchModel;


@end

@implementation DXSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = _searchModel.searchBar;
    [_searchModel.displayController setActive:YES animated:NO];
    [_searchModel.searchBar becomeFirstResponder];
}

@end

@interface DXNavigationSearchModel ()<UISearchBarDelegate, DXSearchModelDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) UIViewController *contentsViewController;
@property (nonatomic, strong, readonly) DXSearchBarAndControllerModel *searchModel;

@end

@implementation DXNavigationSearchModel
{
    
}

- (instancetype)initWithTarget:(UIViewController *)vc
{
    if (self = [super init]) {
        self.contentsViewController = vc;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UISearchBar *navSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenBounds), 44)];
        navSearchBar.delegate = self;
        _navSearchBar = navSearchBar;
        self.delegate = (id)vc;
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == _navSearchBar) {
        DXSearchViewController *svc = [[DXSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
        DXSearchBarAndControllerModel *smodel = [[DXSearchBarAndControllerModel alloc] initWithContentsViewController:svc searchScopes:nil predicateDelegate:self];
        svc.searchModel = smodel;
        [self.contentsViewController.navigationController pushViewController:svc animated:NO];
        _searchModel = smodel;
        _searchModel.hotTagObjects = self.hotTagObjects;
        _searchModel.searchBar.delegate = self;
        _searchModel.tableViewBackgroundImage = self.tableViewBackgroundImage;
        return NO;
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == _searchModel.searchBar) {
        if (searchBar.text.length > 0) {
            [_searchModel refreshTheResultTableViewWithSearchText:searchBar.text];
            DXSearchHistoryCellObject *obj = [DXSearchHistoryCellObject new];
            obj.name = searchBar.text;
            [DXSearchHistoryCellObject enqueueObject:obj];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == _searchModel.searchBar) {
        [_searchModel.displayController setActive:NO animated:NO];
        [self.contentsViewController.navigationController popViewControllerAnimated:NO];
    }
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText scopeField:(NSString *)field resultBlock:(DXSearchResultBlock)block
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate searchModel:sModel filterResultWithText:currentText scopeField:field resultBlock:block];
    }
}

@end


