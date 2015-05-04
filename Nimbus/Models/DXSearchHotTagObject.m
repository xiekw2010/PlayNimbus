//
//  DXSearchHotTagObject.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/30.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchHotTagObject.h"
#import "DXSearchBarAndControllerModel.h"

@implementation DXSearchHotTagObject

@synthesize action = _action;
@synthesize title = _title;

+ (instancetype)objectWithTitle:(NSString *)title action:(DXSearchHotTagAction)action
{
    DXSearchHotTagObject *obj = [DXSearchHotTagObject new];
    obj.title = title;
    if (!action) {
        DXSearchHotTagAction defaultAction = ^(UIViewController *visibleViewController, DXSearchBarAndControllerModel *searchModel, id<DXHotTagObject>hotTagObject) {
            searchModel.searchBar.text = hotTagObject.title;
        };

        action = defaultAction;
    }
    obj.action = action;
    return obj;
}

@end

