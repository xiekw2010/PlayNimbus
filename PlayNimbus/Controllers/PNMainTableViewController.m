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

// Page Scroll View
#import "PNPageViewController.h"

// TableView models
#import "PNFormTableViewController.h"
#import "PNPlusRowViewController.h"
#import "PNRadioViewController.h"
#import "PNMutableTableViewController.h"

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
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"richLabel" subtitle:@"show me the rich alebel"] navigationBlock:NIPushControllerAction([PNAttributeLabelController class])],
                                   [_actions attachToObject:[NITitleCellObject objectWithTitle:@"imageLabel"] navigationBlock:NIPushControllerAction([PNAttributeLabelController class])],
                                   @"CssLayout",
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"Css layout" subtitle:@"use css do the layout"] navigationBlock:NIPushControllerAction([PNCssLayoutViewController class])],
                                   @"PageScrollView",
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"Page scrollView" subtitle:@"Use page scrollView to do the layout"] navigationBlock:NIPushControllerAction([PNPageViewController class])],
                                   @"Badge View",
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"Badge View" subtitle:@"use the badgeView"] navigationBlock:NIPushControllerAction([PNBadgeViewController class])],
                                   @"TableView events",
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"tableViewPlus row"] navigationBlock:NIPushControllerAction([PNPlusRowViewController class])],
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"tableView form data"] navigationBlock:NIPushControllerAction([PNFormTableViewController class])],
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"Radio table"] navigationBlock:NIPushControllerAction([PNRadioViewController class])],
                                   [_actions attachToObject:[NISubtitleCellObject objectWithTitle:@"Mutable table"] navigationBlock:NIPushControllerAction([PNMutableTableViewController class])]

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
}

@end
