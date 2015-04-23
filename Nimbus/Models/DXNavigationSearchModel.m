//
//  DXNavigationSearchModel.m
//  Kwiki
//
//  Created by xiekw on 15/4/22.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXNavigationSearchModel.h"

@interface DXSearchViewController : UITableViewController

@property (nonatomic, strong) DXSearchBarAndControllerModel *searchModel;

@end

@implementation DXSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = _searchModel.searchBar;
    [_searchModel.displayController setActive:YES animated:NO];
    [_searchModel.searchBar becomeFirstResponder];
}

@end

@interface DXNavigationSearchModel ()<UISearchBarDelegate, DXSearchModelDelegate, UISearchDisplayDelegate, DXSearchModelHistoryDataSource>

@end

@implementation DXNavigationSearchModel
{
    DXSearchBarAndControllerModel *_searchModel;
}


- (instancetype)initWithTarget:(UIViewController *)vc
{
    if (self = [super init]) {
        self.contentsViewController = vc;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UISearchBar *navSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenBounds), 44)];
        navSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        navSearchBar.delegate = self;
        _navSearchBar = navSearchBar;
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == _navSearchBar) {
        DXSearchViewController *svc = [[DXSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
        DXSearchBarAndControllerModel *smodel = [[DXSearchBarAndControllerModel alloc] initWithContentsViewController:svc searchScopes:nil predicateDelegate:self];
        smodel.dataSource = self;
        svc.searchModel = smodel;
        [self.contentsViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:svc] animated:NO completion:nil];
        _searchModel = smodel;
        
        return NO;
    }
    return YES;
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText scopeField:(NSString *)field resultBlock:(DXSearchResultBlock)block
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate searchModel:sModel filterResultWithText:currentText scopeField:field resultBlock:block];
    }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.contentsViewController dismissViewControllerAnimated:NO completion:nil];
}

@end


@implementation DXSearchHotView
{
    id _target;
    NSArray *_hotTags;
    NSMutableArray *_buttons;
}

- (id)initWithTarget:(id)actionTarget hotTags:(NSArray *)hotTags
{
    if (self = [super initWithFrame:CGRectZero]) {
        
    }
    return self;
}

- (void)sizeToFit
{
    
}

@end

