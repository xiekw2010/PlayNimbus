//
//  PNRadioViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/26.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNRadioViewController.h"
#import "NimbusModels.h"
#import "DXUtilViews.h"

// Do the following
// 1. mix action with radio
// 2. another radio action
// 3. push navigation for radio
// 4. present for radio
// 5. custom the cell object


typedef NS_ENUM(NSUInteger, RadioOption) {
    RadioOption1,
    RadioOption2,
    RadioOption3,
    RadioOption4,
};

@interface PNRadioViewController ()<NIRadioGroupDelegate>

@end

@implementation PNRadioViewController
{
    NITableViewModel *_model;
    NITableViewActions *_actions;
    NIRadioGroup *_radioGroup1;
    NIRadioGroup *_radioGroup2;
    NIRadioGroup *_radioGroup3;
    NIRadioGroup *_radioGroup4;
    NIRadioGroup *_radioGroup5;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = @"Radio play";
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        _radioGroup1 = [[NIRadioGroup alloc] initWithController:self];
        _radioGroup2 = [[NIRadioGroup alloc] initWithController:self];
        _radioGroup3 = [[NIRadioGroup alloc] initWithController:self];
        _radioGroup4 = [[NIRadioGroup alloc] initWithController:self];
        _radioGroup5 = [[NIRadioGroup alloc] initWithController:self];
        
        _radioGroup1.delegate = self;
        _radioGroup2.delegate = self;
        _radioGroup3.delegate = self;
        _radioGroup4.delegate = self;
        _radioGroup5.delegate = self;
        
        _radioGroup4.controllerTitle = @"Make a selection";
        _radioGroup4.controllerTitle = @"Make a selection";

        
        [_radioGroup3 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup3 1"] toIdentifier:RadioOption1];
        [_radioGroup3 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup3 2"] toIdentifier:RadioOption2];
        [_radioGroup3 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup3 3"] toIdentifier:RadioOption3];
        [_radioGroup3 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup3 4"] toIdentifier:RadioOption4];
        
        [_radioGroup4 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup4 1"] toIdentifier:RadioOption1];
        [_radioGroup4 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup4 2"] toIdentifier:RadioOption2];
        [_radioGroup4 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup4 3"] toIdentifier:RadioOption3];
        [_radioGroup4 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup4 4"] toIdentifier:RadioOption4];
        
        NSArray *sections = @[@"Mixed radio",
                              [_actions attachToObject:[NITitleCellObject objectWithTitle:@"Tap me"] tapSelector:@selector(didTapFirstCell)],
                              [_radioGroup1 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup1 1"] toIdentifier:RadioOption1],
                              [_radioGroup1 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup1 2"] toIdentifier:RadioOption2],
                              [_radioGroup1 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup1 3"] toIdentifier:RadioOption3],
                              @"Another radio",
                              [_radioGroup2 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup2 1"] toIdentifier:RadioOption1],
                              [_radioGroup2 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup2 2"] toIdentifier:RadioOption2],
                              [_radioGroup2 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup2 3"] toIdentifier:RadioOption3],
                              [_radioGroup2 mapObject:[NITitleCellObject objectWithTitle:@"_radioGroup2 4"] toIdentifier:RadioOption4],
                              @"Push radio",
                              _radioGroup3,
                              @"present radio",
                              _radioGroup4,
                              @"Custom cell",
                              [_radioGroup5 mapObject:[DXAlbumCellObject objectWithTitle:@"_radioGroup5 1" placeholderImage:nil imageURL:@"http://img0.bdstatic.com/img/image/1%E8%A5%BF%E6%B8%B8%E8%AE%B0%E2%80%94%E2%80%94%E8%A5%BF%E7%8F%AD%E7%89%99.jpg"] toIdentifier:RadioOption1],
                              [_radioGroup5 mapObject:[DXAlbumCellObject objectWithTitle:@"_radioGroup5 2" placeholderImage:nil imageURL:@"http://img0.bdstatic.com/img/image/%E6%84%8F%E5%A4%A7%E5%88%A9%E2%80%94%E2%80%94%E5%8F%AA%E4%B8%80%E7%9C%BC%EF%BC%8C%E4%BE%BF%E6%B0%B8%E8%BF%9C.jpg"] toIdentifier:RadioOption2],
                              [_radioGroup5 mapObject:[DXAlbumCellObject objectWithTitle:@"_radioGroup5 3" placeholderImage:nil imageURL:@"http://img0.bdstatic.com/img/image/riben180180.jpg"] toIdentifier:RadioOption3],
                              [_radioGroup5 mapObject:[DXAlbumCellObject objectWithTitle:@"_radioGroup5 4" placeholderImage:nil imageURL:@"http://img0.bdstatic.com/img/image/%E7%91%9E%E5%A3%AB-%E5%BE%B7%E5%9B%BD%E8%87%AA%E7%94%B1%E8%A1%8C.jpg"] toIdentifier:RadioOption4],
];
     
        _radioGroup1.selectedIdentifier = RadioOption2;
        _radioGroup2.selectedIdentifier = RadioOption3;
        _radioGroup1.cellTitle = @"_radioGroup1";
        _radioGroup2.cellTitle = @"_radioGroup2";
        _radioGroup3.cellTitle = @"_radioGroup3";
        _radioGroup4.cellTitle = @"_radioGroup4";
        _radioGroup5.cellTitle = @"_radioGroup5";
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:sections delegate:(id)[NICellFactory class]];
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.dataSource = _model;
    [_actions forwardingTo:_radioGroup1];
    [_actions forwardingTo:_radioGroup2];
    [_actions forwardingTo:_radioGroup3];
    [_actions forwardingTo:_radioGroup4];
    [_actions forwardingTo:_radioGroup5];

    self.tableView.delegate = _actions;
}

- (void)radioGroup:(NIRadioGroup *)radioGroup didSelectIdentifier:(NSInteger)identifier
{
    NSString *ivarName = nil;
    if (radioGroup == _radioGroup1) {
        ivarName = @"1";
    }else if (radioGroup == _radioGroup2) {
        ivarName = @"2";
    }else if (radioGroup == _radioGroup3) {
        ivarName = @"3";
    }else if (radioGroup == _radioGroup4) {
        [self dismissViewControllerAnimated:YES completion:nil];
        ivarName = @"4";
    }else if (radioGroup == _radioGroup5) {
        ivarName = @"5";
    }
    
    NSLog(@"did select radio %@ with identifier %ld", ivarName, (long)identifier);
}

- (NSString *)radioGroup:(NIRadioGroup *)radioGroup textForIdentifier:(NSInteger)identifier {
    switch (identifier) {
        case RadioOption1:
            return @"Option 1";
        case RadioOption2:
            return @"Option 2";
        case RadioOption3:
            return @"Option 3";
        case RadioOption4:
            return @"Option 4";
    }
    return nil;
}

- (BOOL)radioGroup:(NIRadioGroup *)radioGroup radioGroupController:(NIRadioGroupController *)radioGroupController willAppear:(BOOL)animated
{
    if (radioGroup == _radioGroup4) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:radioGroupController];
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)didTapFirstCell
{
    NSLog(@"Tap me");
}

@end
