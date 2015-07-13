//
//  PNMainTableViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/24.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNMainTableViewController.h"

// Attribute label
#import "PNAttributeLabelController.h"

// Badge view
#import "PNBadgeViewController.h"
#import "PNContainerViewController.h"

// Page Scroll View
#import "PNPageViewController.h"
#import "PNPageBannerViewController.h"

// TableView models
#import "PNFormTableViewController.h"
#import "PNPlusRowViewController.h"
#import "PNRadioViewController.h"
#import "PNMutableTableViewController.h"
#import "PNExploreScrollViewController.h"
#import "PNNavSearchViewController.h"

// CSS Layout
#import "PNCssLayoutViewController.h"

#import "NimbusModels.h"

@implementation PNMainTableViewController
{
    NITableViewModel *_model;
    NITableViewActions *_actions;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
        self.title = @"Play Catalog";
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        NSArray *sectionsArray = @[@"Attribute Label",
                                   
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"richLabel"
                                                                                         subtitle:@"show me the rich alebel"]
                                            navigationBlock:NIPushControllerAction([PNAttributeLabelController class])],
                                   
                                   [_actions attachToObject:[NITitleCellObject
                                                             objectWithTitle:@"imageLabel"]
                                            navigationBlock:NIPushControllerAction([PNAttributeLabelController class])],
                                   
                                   @"CssLayout",
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Css layout"
                                                             subtitle:@"use css do the layout"]
                                            navigationBlock:NIPushControllerAction([PNCssLayoutViewController class])],
                                   
                                   @"PageScrollView",
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Page scrollView"
                                                             subtitle:@"Use page scrollView to do the layout"]
                                            detailBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                                                PNPageViewController *pageVC = [PNPageViewController new];
                                                [pageVC showInContainer:self animated:YES];
                                                return YES;
                                            }],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Banner view"
                                                             subtitle:@"banner now"]
                                            navigationBlock:NIPushControllerAction([PNPageBannerViewController class])],
                                   
                                   @"Badge View",
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Badge View"
                                                             subtitle:@"use the badgeView"]
                                            navigationBlock:NIPushControllerAction([PNBadgeViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Container VC"
                                                             subtitle:@"appearence container"]
                                            navigationBlock:NIPushControllerAction([PNContainerViewController class])],

                                   @"TableView events",
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Scroll View"]
                                            navigationBlock:NIPushControllerAction([PNExploreScrollViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"tableViewPlus row"]
                                            navigationBlock:NIPushControllerAction([PNPlusRowViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Radio table"]
                                            navigationBlock:NIPushControllerAction([PNRadioViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Mutable table"]
                                            navigationBlock:NIPushControllerAction([PNMutableTableViewController class])],
                                   
                                   @"Search Model",
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"Default search"]
                                            navigationBlock:NIPushControllerAction([PNFormTableViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"nav search"]
                                            navigationBlock:NIPushControllerAction([PNNavSearchViewController class])],
                                   
                                   [_actions attachToObject:[NISubtitleCellObject
                                                             objectWithTitle:@"custom search"]
                                            navigationBlock:NIPushControllerAction([PNMutableTableViewController class])]
                                   ];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:sectionsArray delegate:(id)[NICellFactory class]];
        
        [_model setSectionIndexType:NITableViewModelSectionIndexDynamic
                        showsSearch:YES
                       showsSummary:YES];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = _model;
    self.tableView.delegate = _actions;
    
    
    NSString *path = @"http://online.store.com/storefront/";
    NSDictionary *params = @{@"request" : @"get-document", @"doi" : @"10.1175%2F1520-0426(2005)014%3C1157:DODADSS%3E2.0.CO%3B2"};
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@?", path];
    if ([[params allKeys] count] > 0){
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in [params allKeys]){
            NSString *value = [params[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        
        [urlString appendFormat:@"%@", [array componentsJoinedByString:@"&"]];
    }
    NSLog(@"normal string is %@", urlString);
    NSString *nim = NIStringByAddingQueryDictionaryToString(path, params);
    NSLog(@"nim string is %@", nim);

}


@end
