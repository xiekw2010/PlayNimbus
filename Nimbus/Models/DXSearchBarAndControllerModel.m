//
//  DXSearchBarAndControllerModel.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/26.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchBarAndControllerModel.h"
#import "NIMutableTableViewModel.h"
#import "NITableViewActions.h"
#import "NICellFactory.h"
#import "NIMutableTableViewModel+Private.h"
#import "DXSearchCell.h"

// Do the default delegate and forward the delegate

@implementation DXSearchBarAndControllerModel


- (instancetype)initWithContentsViewController:(UIViewController *)contentsViewController searchScopes:(NSArray *)scopes predicateDelegate:(id)delegate
{
    if (self = [super init]) {
        _displayTableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        _displayTableViewActions = [[NITableViewActions alloc] initWithTarget:contentsViewController];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentsViewController.view.bounds), 44.0)];
    
        UISearchDisplayController *displayViewController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:contentsViewController];
        displayViewController.searchBar.scopeButtonTitles = scopes;
        displayViewController.searchBar.selectedScopeButtonIndex = 0;
        displayViewController.searchBar.showsScopeBar = scopes.count > 0;
        displayViewController.delegate = self;
        displayViewController.searchResultsDataSource = _displayTableViewModel;
        displayViewController.searchResultsDelegate = [_displayTableViewActions forwardingTo:(id)contentsViewController];
        _searchBar = searchBar;
        _displayController = displayViewController;
        _searchPredicateDelegate = delegate;
    }
    return self;
}

- (NSString *)currentSearchBarScope
{
    if (_searchBar.scopeButtonTitles.count) {
        return _searchBar.scopeButtonTitles[_searchBar.selectedScopeButtonIndex];
    }
    return nil;
}

- (void)startAnimating
{
    [_displayTableViewModel _resetCompiledData];
    [_displayTableViewModel addObject:[DXSearchObjcet objectWithSearchText:_searchBar.text]];
    [self.displayController.searchResultsTableView reloadData];
}

- (void)stopAnimating
{
    [_displayTableViewModel _resetCompiledData];
    [self.displayController.searchResultsTableView reloadData];
}

- (void)refreshTheResultTableViewWithSearchBar:(UISearchBar *)searchBar
{
    [self startAnimating];
    __weak typeof(self) wself = self;
    [self.searchPredicateDelegate filteredResultWithText:searchBar.text scopeField:[self currentSearchBarScope] searchBar:searchBar resultBlock:^(NSArray *results, NSString *searchText, NSString *searchScope) {
        if ([searchText isEqualToString:searchBar.text] && [searchScope isEqualToString:[self currentSearchBarScope]]) {
            [self stopAnimating];
            [wself.displayTableViewModel addObjectsFromArray:results];
            [wself.displayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(filteredResultWithText:scopeField:searchBar:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchBar:controller.searchBar];
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(filteredResultWithText:scopeField:searchBar:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchBar:controller.searchBar];
    }
    return YES;
}

@end
