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
#import "DXSearchHistoryCellObject.h"
#import "DXSearchHotTagsHeader.h"

// Do the default delegate and forward the delegate

@interface DXSearchBarAndControllerModel ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NITableViewModel *historyModel;
@property (nonatomic, strong) NITableViewActions *historyActions;
@property (nonatomic, strong) NICellFactory *cellFactory;
@property (nonatomic, strong, readonly) NIMutableTableViewModel *displayTableViewModel;
@property (nonatomic, strong) UIImageView *blurBackImageView;

@end

@implementation DXSearchBarAndControllerModel


- (instancetype)initWithContentsViewController:(UIViewController *)contentsViewController searchScopes:(NSArray *)scopes predicateDelegate:(id)delegate
{
    if (self = [super init]) {
        self.usingHistory = YES;
        _contentsViewController = contentsViewController;
        _searchPredicateDelegate = delegate;
        _cellFactory = [NICellFactory new];
        _displayTableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:_cellFactory];
        _displayTableViewActions = [[NITableViewActions alloc] initWithTarget:contentsViewController];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenBounds), 44.0)];
    
        UISearchDisplayController *displayViewController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:contentsViewController];
        displayViewController.searchBar.scopeButtonTitles = scopes;
        displayViewController.searchBar.selectedScopeButtonIndex = 0;
        displayViewController.searchBar.showsScopeBar = scopes.count > 0;
        displayViewController.searchBar.delegate = self;
        displayViewController.delegate = self;
        displayViewController.searchResultsDataSource = _displayTableViewModel;
        [_displayTableViewActions forwardingTo:self];
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

- (void)refreshTheResultTableViewWithSearchText:(NSString *)sText
{
    [self startAnimating];
    __weak typeof(self) wself = self;
    [self.searchPredicateDelegate searchModel:self
                         filterResultWithText:sText
                                   scopeField:[self currentSearchBarScope]
                                  resultBlock:^(NSArray *results,
                                                NSString *searchText,
                                                NSString *searchScope)
    {
        [self stopAnimating];
        if (([searchText isEqualToString:sText] && searchText.length > 0)
            && ([searchScope isEqualToString:[self currentSearchBarScope]] || !searchScope)
            && self.contentsViewController != nil) {
            [wself.displayTableViewModel addObjectsFromArray:results];
            [wself.displayController.searchResultsTableView reloadData];
        }
    }];
}

#pragma -mark UISearchDisplayDelegate

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    if (self.isUsingHistory) {
        UIView *dimmingView = [[_contentsViewController.view
                                findRecursiveSubviewsIncludeSelf:NO
                                specificPredicate:^BOOL(UIView *aView)
        {
            return [aView isKindOfClass:[NSClassFromString(@"_UISearchDisplayControllerDimmingView") class]];
        }] firstObject];
        
        if (self.tableViewBackgroundImage) {
            if (!self.blurBackImageView) {
                self.blurBackImageView = [[UIImageView alloc] initWithFrame:dimmingView.bounds];
                self.blurBackImageView.image = self.tableViewBackgroundImage;
            }
            self.displayController.searchResultsTableView.backgroundColor = [UIColor colorWithPatternImage:self.tableViewBackgroundImage];
        }
        
        dimmingView.alpha = 1.0;
        self.historyTableView.frame = dimmingView.bounds;
        if (self.tableViewBackgroundImage) {
            self.historyTableView.backgroundView = self.blurBackImageView;
        }
        [dimmingView addSubview:self.historyTableView];
        [self setupTableView];
    }
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(searchModel:filterResultWithText:scopeField:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchText:controller.searchBar.text];
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([self.searchPredicateDelegate respondsToSelector:@selector(searchModel:filterResultWithText:scopeField:resultBlock:)]) {
        [self refreshTheResultTableViewWithSearchText:controller.searchBar.text];
    }
    return YES;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [self setupTableView];
}

#pragma -mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [self refreshTheResultTableViewWithSearchText:self.searchBar.text];
        if (self.isUsingHistory) {
            DXSearchHistoryCellObject *obj = [DXSearchHistoryCellObject new];
            obj.name = searchBar.text;
            [DXSearchHistoryCellObject enqueueObject:obj];
        }
    }
}

- (UITableView *)historyTableView
{
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _historyTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _historyTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _historyActions = [[NITableViewActions alloc] initWithTarget:self];
        _historyTableView.delegate = [self.historyActions forwardingTo:self];
    }
    return _historyTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView) {
        return [_cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.historyModel];
    }else if (tableView == self.displayController.searchResultsTableView) {
        return [_cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.displayTableViewModel];
    }else {
        return 44.0;
    }
}

- (void)setupTableView
{
    if (!self.isUsingHistory) {
        return;
    }
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    if (self.hotTagObjects.count) {
        NIDrawRectBlockCellObject *hotObject = [[NIDrawRectBlockCellObject alloc] initWithBlock:^CGFloat(CGRect rect, id object, UITableViewCell *cell) {
            NSArray *tags = object;
            DXSearchHotTagsHeader *header = [[DXSearchHotTagsHeader alloc] initWithHotTags:tags containerViewController:self];
            [cell addSubview:header];
            cell.backgroundColor = [UIColor clearColor];
            header.backgroundColor = [UIColor clearColor];
            return [DXSearchHotTagsHeader heightForHotTagsCount:tags.count];
        } object:self.hotTagObjects];
        [sectionArray addObject:@"热门搜索"];
        [sectionArray addObject:hotObject];
    }
    
    NSArray *historyObjects = [DXSearchHistoryCellObject historyObjects];
    for (DXSearchHistoryCellObject *hobj in historyObjects) {
        [_historyActions attachToObject:hobj tapBlock:^BOOL(DXSearchHistoryCellObject *object, id target, NSIndexPath *indexPath) {
            self.searchBar.text = object.name;
            return YES;
        }];
    }
    if (historyObjects.count) {
        [sectionArray addObject:NSLocalizedString(@"搜索历史", nil)];
        [sectionArray addObjectsFromArray:historyObjects];
        
        NICellDrawRectBlock drawingBlock =  ^(CGRect rect, NSString *objectText, UITableViewCell* cell) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:rect];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.text = objectText;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = [UIColor grayColor];
            textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:textLabel];
            return 44.0;
        };
        NIDrawRectBlockCellObject *drawClearHistoryObject = [[NIDrawRectBlockCellObject alloc] initWithBlock:drawingBlock object:NSLocalizedString(@"清除搜索记录", nil)];
        [sectionArray addObject:[_historyActions attachToObject:drawClearHistoryObject tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
            [DXSearchHistoryCellObject removeAll];
            [self setupTableView];
            return YES;
        }]];
    }
    
    _historyModel = [[NITableViewModel alloc] initWithSectionedArray:sectionArray delegate:_cellFactory];
    
    __weak typeof(self) wself = self;
    _historyModel.createCellBlock = ^UITableViewCell * (UITableView* tableView, NSIndexPath* indexPath, id object){
        if ([object isKindOfClass:[DXSearchHistoryCellObject class]]) {
            Class cellClass = [object cellClass];
            NSString *identifier = NSStringFromClass(cellClass);
            DXSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = [object name];
            cell.tapBlock = ^{
                [DXSearchHistoryCellObject dequeueObject:object];
                [wself setupTableView];
            };
            return cell;
        }else {
            return nil;
        }
    };
    
    
    _historyTableView.dataSource = _historyModel;
    [_historyTableView reloadData];
}


@end
