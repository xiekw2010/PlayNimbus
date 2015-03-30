//
//  DXSearchCell.h
//  PlayNimbus
//
//  Created by xiekw on 15/3/27.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NimbusModels.h"

@interface DXSearchObjcet : NSObject

+ (instancetype)objectWithSearchText:(NSString *)text;

@property (nonatomic, strong) NSString *searchPlaceholder;

@end

@interface DXSearchCell : UITableViewCell<NICell>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (BOOL)shouldUpdateCellWithObject:(id)object;

@end
