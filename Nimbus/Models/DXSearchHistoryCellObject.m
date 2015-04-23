//
//  DXSearchHistoryCellObject.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchHistoryCellObject.h"

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

+ (void)removeAll
{
    [[self historyObjectDictionary] removeAllObjects];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor randomColor] cropSize:CGSizeMake(30.0, 30.0)] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30.0, 30.0);
        self.accessoryView = btn;
        [btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnTap
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    DXSearchHistoryCellObject *obj = object;
    self.textLabel.text = obj.name;
    return YES;
}

@end
