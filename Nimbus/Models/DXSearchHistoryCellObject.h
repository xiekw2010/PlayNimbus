//
//  DXSearchHistoryCellObject.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimbusCore.h"

// use the Designated initializer sepcify the cell class
@interface DXSearchHistoryCellObject : NSObject<NSCoding, NICellObject>

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *name;


+ (NSArray *)historyObjects;
+ (void)enqueueObject:(DXSearchHistoryCellObject *)object;
+ (void)dequeueObject:(DXSearchHistoryCellObject *)object;
+ (void)removeAll;

@end

@interface DXSearchHistoryCell : UITableViewCell<NICell>

@property (nonatomic, strong) dispatch_block_t tapBlock;

@end