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
#import "DXSearchHotTagObject.h"
#import "PNRadioViewController.h"

@interface PNNavSearchViewController ()<DXSearchModelDelegate>
{
    DXNavigationSearchModel *_navSearchModel;
}

@end

@implementation PNNavSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"navSearch";
    _navSearchModel = [[DXNavigationSearchModel alloc] initWithTarget:self];
    
    DXSearchHotTagAction action = ^(UIViewController *visibleViewController, DXSearchBarAndControllerModel *searchModel, id<DXHotTagObject>hotTagObject) {
        searchModel.searchBar.text = hotTagObject.title;
    };
    _navSearchModel.hotTagObjects = @[
                                      [DXSearchHotTagObject objectWithTitle:@"Good" action:action],
                                      [DXSearchHotTagObject objectWithTitle:@"cool" action:action],
                                      [DXSearchHotTagObject objectWithTitle:@"aa" action:action],
                                      [DXSearchHotTagObject objectWithTitle:@"dd" action:action],
                                      [DXSearchHotTagObject objectWithTitle:@"ee" action:action],
                                      [DXSearchHotTagObject objectWithTitle:@"aa" action:action]
                                      ];
    self.navigationItem.titleView = _navSearchModel.navSearchBar;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor randomColor];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pushSomething) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"go" style:UIBarButtonItemStylePlain target:nil action:NULL];
}

- (void)pushSomething
{
    PNRadioViewController *vc = [PNRadioViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _navSearchModel.tableViewBackgroundImage = [[self.view screenShotImage] applyExtraLightEffect];
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
