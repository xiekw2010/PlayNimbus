//
//  PNFormTableViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/25.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNFormTableViewController.h"
#import "NimbusModels.h"

@interface PNFormTableViewController ()<DXSearchModelDelegate>


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PNFormTableViewController
{
    NITableViewModel *_model;
    DXSearchBarAndControllerModel *_searchModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = @[[NISubtitleCellObject objectWithTitle:@"ok" subtitle:@"ok"],
                           [NISubtitleCellObject objectWithTitle:@"good" subtitle:@"good"],
                           [NISubtitleCellObject objectWithTitle:@"please" subtitle:@"please"]];
        _model = [[NITableViewModel alloc] initWithListArray:array delegate:(id)[NICellFactory class]];
    }
    return self;
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText scopeField:(NSString *)field resultBlock:(DXSearchResultBlock)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = @[[NITitleCellObject objectWithTitle:@"a"],
                           [NITitleCellObject objectWithTitle:@"b"],
                           [NITitleCellObject objectWithTitle:@"c"]];
        [sModel.displayTableViewActions attachToClass:[NITitleCellObject class] navigationBlock:NIPushControllerAction([self class])];
        block(array, currentText, field);
    });
}

- (void)viewDidLoad
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    tableView.dataSource = _model;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    _searchModel = [[DXSearchBarAndControllerModel alloc] initWithContentsViewController:self searchScopes:nil predicateDelegate:self];
    _searchModel.usingHistory = NO;
    self.tableView.tableHeaderView = _searchModel.searchBar;
}

@end
