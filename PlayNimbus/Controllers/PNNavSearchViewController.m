//
//  PNNavSearchViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNNavSearchViewController.h"
#import "DXNavigationSearchModel.h"
#import "NimbusCore.h"

@interface PNNavSearchViewController ()<DXSearchModelDelegate, DXSearchModelHistoryDataSource>
{
    DXNavigationSearchModel *_navSearchModel;
}

@end

@implementation PNNavSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"navSearch";
    _navSearchModel = [[DXNavigationSearchModel alloc] initWithTarget:self];
    _navSearchModel.delegate = self;
    self.navigationItem.titleView = _navSearchModel.navSearchBar;
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText scopeField:(NSString *)field resultBlock:(DXSearchResultBlock)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = @[[NITitleCellObject objectWithTitle:@"a"],
                           [NITitleCellObject objectWithTitle:@"b"],
                           [NITitleCellObject objectWithTitle:@"c"]];
        block(array, currentText, field);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
