//
//  PNMutableTableViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/26.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

// Do the following
// 1. add, delete, move, search
// 2. move support batch move
// 3. Ask alert when move or delete


#import "PNMutableTableViewController.h"
#import "NimbusModels.h"
#import "NITableViewModel+Private.h"
#import "PNPlusRowViewController.h"

@interface PNMutableTableViewController ()<NIMutableTableViewModelDelegate, DXSearchBarDelegate>

@end

@implementation PNMutableTableViewController
{
    UIBarButtonItem *_move;
    UIBarButtonItem *_edit;
    UIBarButtonItem *_add;
    UIBarButtonItem *_reload;
    NIMutableTableViewModel *_model;
    DXSearchBarAndControllerModel *_searchModel;
    NSArray *_searchScopes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
        _model = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        [_model setSectionIndexType:NITableViewModelSectionIndexDynamic showsSearch:YES showsSummary:NO];
        
        _reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(didTapReload)];
        _move = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(didTapMove)];
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEdit)];
        _add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAdd)];
        self.navigationItem.rightBarButtonItems = @[_reload, _move, _edit, _add];
        _searchScopes = @[@"Apple", @"Google", @"Microsoft", @"Facebook"];
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.dataSource = _model;
    
    _searchModel = [[DXSearchBarAndControllerModel alloc] initWithContentsViewController:self searchScopes:_searchScopes predicateDelegate:self];
    self.tableView.tableHeaderView = _searchModel.searchBar;
}

- (void)filteredResultWithText:(NSString *)currentText scopeField:(NSString *)field
                     searchBar:(UISearchBar *)searchBar resultBlock:(DXSearchResultBlock)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *result = nil;
        if ([currentText rangeOfString:@"aaa"].location != NSNotFound) {
            NITableViewActions *actions = _searchModel.displayTableViewActions;
            NITitleCellObject *titleObjc = [actions attachToObject:[NITitleCellObject objectWithTitle:@"aaa"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                PNPlusRowViewController *plus = [PNPlusRowViewController new];
                [self.navigationController pushViewController:plus animated:YES];
                return NO;
            }];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        if ([currentText rangeOfString:@"bbb"].location != NSNotFound) {
            result = @[[NITitleCellObject objectWithTitle:@"go"], [NITitleCellObject objectWithTitle:@"go"], [NITitleCellObject objectWithTitle:@"go"], [NITitleCellObject objectWithTitle:@"go"], [NITitleCellObject objectWithTitle:@"go"]];
        }
        if ([field isEqualToString:@"Apple"]) {
            NITableViewActions *actions = _searchModel.displayTableViewActions;
            NITitleCellObject *titleObjc = [actions attachToObject:[NITitleCellObject objectWithTitle:@"Apple"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                PNPlusRowViewController *plus = [PNPlusRowViewController new];
                [self.navigationController pushViewController:plus animated:YES];
                return NO;
            }];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        if ([field isEqualToString:@"Google"]) {
            NITableViewActions *actions = _searchModel.displayTableViewActions;
            NITitleCellObject *titleObjc = [actions attachToObject:[NITitleCellObject objectWithTitle:@"Google"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                PNPlusRowViewController *plus = [PNPlusRowViewController new];
                [self.navigationController pushViewController:plus animated:YES];
                return NO;
            }];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        if ([field isEqualToString:@"Facebook"]) {
            NITableViewActions *actions = _searchModel.displayTableViewActions;
            NITitleCellObject *titleObjc = [actions attachToObject:[NITitleCellObject objectWithTitle:@"Facebook"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                PNPlusRowViewController *plus = [PNPlusRowViewController new];
                [self.navigationController pushViewController:plus animated:YES];
                return NO;
            }];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        block(result, currentText, field);
    });
}

- (NSString *)randomName
{
    NSMutableString *ms = [NSMutableString new];
    for (u_int32_t i = 0; i < arc4random_uniform(10) + 5; ++i) {
        [ms appendFormat:@"%c", arc4random_uniform('z' - 'a') + 'a'];
    }
    return ms;
}

- (void)didTapReload
{
    [self.tableView reloadData];
}

- (void)didTapMove
{
}

- (void)didTapEdit
{
    BOOL editing = self.tableView.editing == YES;
    if (editing) {
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEdit)];
    }else {
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapEdit)];
    }
    self.navigationItem.rightBarButtonItems = @[_reload, _move, _edit, _add];
    [self.tableView setEditing:!editing animated:YES];
}

- (void)didTapAdd
{
    NSUInteger currentSecion = _model.sections.count;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(currentSecion > 0 ? currentSecion - 1 : 0)];
    indexSet = [_model addSectionWithTitle:[self randomName]];
    NSMutableArray *mrows = [NSMutableArray array];
    for (u_int32_t i = 0; i < arc4random_uniform(5) + 5; ++i) {
        [mrows addObject:[NITitleCellObject objectWithTitle:[self randomName]]];
    }
    NSArray *indexPaths = [_model addObjectsFromArray:mrows];
    
    [_model updateSectionIndex];
    
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
    return [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}

- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel canEditObject:(id)object atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    return YES;
}

- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel canMoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    return YES;
}

@end
