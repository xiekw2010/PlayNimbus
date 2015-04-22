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
#import <objc/runtime.h>

// Do the default delegate and forward the delegate

@interface DXSearchBarAndControllerModel ()



@end

@implementation DXSearchBarAndControllerModel

- (instancetype)initWithContentsViewController:(UIViewController *)contentsViewController searchScopes:(NSArray *)scopes predicateDelegate:(id)delegate
{
    if (self = [super init]) {
        _contentsViewController = contentsViewController;
        _searchPredicateDelegate = delegate;
        _displayTableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        _displayTableViewActions = [[NITableViewActions alloc] initWithTarget:contentsViewController];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenBounds), 44.0)];
    
        UISearchDisplayController *displayViewController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:contentsViewController];
        displayViewController.searchBar.scopeButtonTitles = scopes;
        displayViewController.searchBar.selectedScopeButtonIndex = 0;
        displayViewController.searchBar.showsScopeBar = scopes.count > 0;
        displayViewController.delegate = self;
        displayViewController.searchResultsDataSource = _displayTableViewModel;
        displayViewController.searchResultsDelegate = [_displayTableViewActions forwardingTo:(id)contentsViewController];
        _searchBar = searchBar;
        _displayController = displayViewController;
    }
    return self;
}

- (BOOL)shouldForwardSelector:(SEL)aSelector
{
    struct objc_method_description descprition;
    descprition = protocol_getMethodDescription(@protocol(UISearchDisplayDelegate), aSelector, NO, YES);
    return (descprition.name != nil && descprition.types != NULL);
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }else if ([self shouldForwardSelector:aSelector]) {
        return [self.searchPredicateDelegate respondsToSelector:aSelector];
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature == nil) {
        if ([self.searchPredicateDelegate respondsToSelector:selector]) {
            id obj = self.searchPredicateDelegate;
            signature = [obj methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    BOOL didForward = NO;
    
    if ([self shouldForwardSelector:invocation.selector]) {
        if ([self.searchPredicateDelegate respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:self.searchPredicateDelegate];
            didForward = YES;
        }
    }
    if (!didForward) {
        [super forwardInvocation:invocation];
    }
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
    [self.searchPredicateDelegate searchModel:self filterResultWithText:searchBar.text scopeField:[self currentSearchBarScope] resultBlock:^(NSArray *results, NSString *searchText, NSString *searchScope) {
        [self stopAnimating];
        if (([searchText isEqualToString:searchBar.text] && searchText.length > 0) && ([searchScope isEqualToString:[self currentSearchBarScope]] || !searchScope)) {
            [wself.displayTableViewModel addObjectsFromArray:results];
            [wself.displayController.searchResultsTableView reloadData];
        }
    }];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(searchModel:configDimmingView:)]) {
        UIView *dimmingView = [[_contentsViewController.view findRecursiveSubviewsIncludeSelf:NO specificPredicate:^BOOL(UIView *aView) {
            return [aView isKindOfClass:[NSClassFromString(@"_UISearchDisplayControllerDimmingView") class]];
        }] firstObject];
        [self.searchPredicateDelegate searchModel:self configDimmingView:dimmingView];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(searchModel:filterResultWithText:scopeField:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchBar:controller.searchBar];
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(searchModel:filterResultWithText:scopeField:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchBar:controller.searchBar];
    }
    return YES;
}

@end
