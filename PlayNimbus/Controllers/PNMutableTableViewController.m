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

@interface PNMutableTableViewController ()<NIMutableTableViewModelDelegate, DXSearchModelDelegate>

@end

@implementation PNMutableTableViewController
{
    UIBarButtonItem *_edit;
    UIBarButtonItem *_add;
    NIMutableTableViewModel *_model;
    DXSearchBarAndControllerModel *_searchModel;
    NSArray *_searchScopes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
        _model = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        [_model setSectionIndexType:NITableViewModelSectionIndexDynamic showsSearch:YES showsSummary:NO];
        
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEdit)];
        _add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAdd)];
        self.navigationItem.rightBarButtonItems = @[_edit, _add];
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


- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText
         scopeField:(NSString *)field
        resultBlock:(DXSearchResultBlock)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *result = nil;
        if ([currentText rangeOfString:@"aaa"].location != NSNotFound) {
            NITitleCellObject *titleObjc = [NITitleCellObject objectWithTitle:@"aaa"];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        if ([currentText rangeOfString:@"bbb"].location != NSNotFound) {
            NITitleCellObject *titleObjc = [NITitleCellObject objectWithTitle:@"go"];
            result = @[titleObjc, titleObjc, titleObjc];
        }
        if ([field isEqualToString:@"Apple"]) {
            NITitleCellObject *titleObjc = [NITitleCellObject objectWithTitle:@"Apple"];
            result = @[titleObjc, titleObjc, titleObjc, titleObjc, titleObjc];
        }
        if ([field isEqualToString:@"Google"]) {
            NITitleCellObject *titleObjc = [NITitleCellObject objectWithTitle:@"Google"];
            result = @[titleObjc, titleObjc];
        }
        if ([field isEqualToString:@"Facebook"]) {
            NITitleCellObject *titleObjc = [NITitleCellObject objectWithTitle:@"Facebook"];
            result = @[titleObjc, titleObjc, titleObjc];
        }
        [_searchModel.displayTableViewActions attachToClass:[NITitleCellObject class] navigationBlock:NIPushControllerAction([self class])];
        
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

- (void)didTapEdit
{
    BOOL editing = self.tableView.editing == YES;
    if (editing) {
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEdit)];
    }else {
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapEdit)];
    }
    self.navigationItem.rightBarButtonItems = @[_edit, _add];
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
    UITableViewCell *cell = [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
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
