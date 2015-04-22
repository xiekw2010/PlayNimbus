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
    self.view.backgroundColor = [UIColor blueColor];
    
    self.tableView.tableHeaderView = _searchModel.searchBar;
    [_searchModel.displayController setActive:YES animated:NO];
    [_searchModel.searchBar becomeFirstResponder];
}


@end


@interface DXNavigationSearchModel ()<UISearchBarDelegate, DXSearchModelDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NITableViewModel *model;
@property (nonatomic, strong) NITableViewActions *actions;

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
        svc.searchModel = smodel;
        svc.searchModel.searchBar.delegate = self;
        [self.contentsViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:svc] animated:NO completion:nil];
        svc.searchModel.searchBar.delegate = self;
        _searchModel = smodel;
        
        return NO;
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [_searchModel refreshTheResultTableViewWithSearchBar:_searchModel.searchBar];
        DXSearchHistoryCellObject *obj = [DXSearchHistoryCellObject new];
        obj.name = searchBar.text;
        [DXSearchHistoryCellObject enqueueObject:obj];
    }
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel configDimmingView:(UIView *)dimmingView
{
    dimmingView.alpha = 1.0;
    self.historyTableView.frame = dimmingView.bounds;
    [dimmingView addSubview:self.historyTableView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate searchModel:sModel configDimmingView:dimmingView];
    }
}

- (UITableView *)historyTableView
{
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _historyTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _historyTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    [self setupTableView];
    return _historyTableView;
}

- (void)setupTableView
{
    NSMutableArray *sectionArray = [@[@"hello", [NITitleCellObject objectWithTitle:@"hi"], [NITitleCellObject objectWithTitle:@"go"], @"say"] mutableCopy];
    [sectionArray addObjectsFromArray:[DXSearchHistoryCellObject historyObjects]];
    
    NSLog(@"timeStamp is %@", [[DXSearchHistoryCellObject historyObjects] valueForKey:@"timestamp"]);
    
    _model = [[NITableViewModel alloc] initWithSectionedArray:sectionArray delegate:(id)[NICellFactory class]];

    _historyTableView.dataSource = self.model;
    _historyTableView.delegate = self.actions;
    [_historyTableView reloadData];
}

- (void)searchModel:(DXSearchBarAndControllerModel *)sModel filterResultWithText:(NSString *)currentText scopeField:(NSString *)field resultBlock:(DXSearchResultBlock)block
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate searchModel:sModel filterResultWithText:currentText scopeField:field resultBlock:block];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [self setupTableView];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.contentsViewController dismissViewControllerAnimated:NO completion:nil];
}

@end

@implementation DXSearchHistoryCellObject

- (Class)cellClass
{
    return [DXSearchHistoryCell class];
}

+ (NSMutableDictionary *)historyObjectDictionary
{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *set = nil;
    dispatch_once(&onceToken, ^{
        set = [[self readFromDisk] mutableCopy];
    });
    return set;
}

+ (NSArray *)historyObjects
{
    NSArray *values = [self historyObjectDictionary].allValues;
    return [values sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(DXSearchHistoryCellObject *obj1, DXSearchHistoryCellObject *obj2) {
        if ([obj1.timestamp timeIntervalSinceDate:obj2.timestamp] >= 0) {
            return NSOrderedAscending;
        }else {
            return NSOrderedDescending;
        };
    }];
}

+ (void)enqueueObject:(DXSearchHistoryCellObject *)object
{
    object.timestamp = [NSDate date];
    NSMutableDictionary *hisDic = [self historyObjectDictionary];
    DXSearchHistoryCellObject *other = hisDic[object.name];
    if (other) {
        DXSearchHistoryCellObject *obj = other;
        obj.timestamp = object.timestamp;
    }else {
        hisDic[object.name] = object;
    }
    [self saveToDisk];
}

+ (void)dequeueObject:(DXSearchHistoryCellObject *)object
{
    [[self historyObjectDictionary] removeObjectForKey:object.name];
    [self saveToDisk];
}

+ (void)saveToDisk
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self historyObjectDictionary]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"DXNavigationSearchModel-history"];
}

+ (NSDictionary *)readFromDisk
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DXNavigationSearchModel-history"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!dic) {
        dic = @{};
    }
    return dic;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.timestamp forKey:@"timestamp"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.timestamp = [coder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

@end

@implementation DXSearchHistoryCell

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    DXSearchHistoryCellObject *obj = object;
    self.textLabel.text = obj.name;
    return YES;
}

@end

