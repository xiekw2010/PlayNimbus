//
//  DXSearchHotTagsHeader.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/23.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXSearchBarAndControllerModel;

@interface DXSearchHotTagsHeader : UIView

- (id)initWithHotTags:(NSArray *)hotTags containerViewController:(DXSearchBarAndControllerModel *)searchModel;
+ (CGFloat)heightForHotTagsCount:(NSUInteger)count;

@end


@interface DXSearchHotTagButton : UIButton

@end
