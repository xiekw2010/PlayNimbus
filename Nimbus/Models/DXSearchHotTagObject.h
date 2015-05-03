//
//  DXSearchHotTagObject.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/30.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DXSearchBarAndControllerModel;
@protocol DXHotTagObject;

typedef void (^DXSearchHotTagAction)(UIViewController *visibleViewController,
                                     DXSearchBarAndControllerModel *searchModel,
                                     id<DXHotTagObject>hotTagObject);


@protocol DXHotTagObject <NSObject>

@property (nonatomic, copy) DXSearchHotTagAction action;
@property (nonatomic, copy) NSString *title;

@end

@interface DXSearchHotTagObject : NSObject<DXHotTagObject>

+ (instancetype)objectWithTitle:(NSString *)title action:(DXSearchHotTagAction)action;

@end

