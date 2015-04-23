//
//  DXSearchHotTagsHeader.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DXHotTagObject;

typedef void (^DXSearchHotTagAction)(UIViewController *visibleViewController, id<DXHotTagObject>hotTagObject);


@protocol DXHotTagObject <NSObject>

@property (nonatomic, copy) DXSearchHotTagAction action;
@property (nonatomic, copy) NSString *title;

@end



@interface DXSearchHotTagsHeader : UIView

- (id)initWithHotTags:(NSArray *)hotTags;
+ (CGFloat)heightForHotTagsCount:(NSUInteger)count;

@end

@interface DXSearchHotTagObject : NSObject<DXHotTagObject>

+ (instancetype)objectWithTitle:(NSString *)title action:(DXSearchHotTagAction)action;

@end

@interface DXSearchHotTagButton : UIButton

@end
