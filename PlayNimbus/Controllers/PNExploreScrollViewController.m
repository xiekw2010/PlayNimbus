//
//  PNExploreScrollViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/20.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNExploreScrollViewController.h"
#import "NimbusCore.h"

@interface ADTableView : UITableView

@end

@implementation ADTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
//        self.canCancelContentTouches = YES;
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
//    NSLog(@"view is %@", view);
//    BOOL should = [view isKindOfClass:[NSClassFromString(@"UITableViewCellContentView") class]];
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    BOOL superShould = [super touchesShouldCancelInContentView:view];
    return NO;
}

@end


@interface PNExploreScrollViewController ()

@property (nonatomic, strong) ADTableView *tableView;

@end

@implementation PNExploreScrollViewController
{
    NITableViewModel *_model;
    NITableViewActions *_actions;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[ADTableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 100; i ++) {
        [mArray addObject:[_actions attachToObject:[NITitleCellObject objectWithTitle:@"Go"] navigationBlock:NIPushControllerAction([self class])]];
    }
    _model = [[NITableViewModel alloc] initWithSectionedArray:mArray delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = _model;
    self.tableView.delegate = _actions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
