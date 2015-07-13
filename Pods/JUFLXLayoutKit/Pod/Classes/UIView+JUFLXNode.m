//
//  UIView+JUFLXNode.m
//  all_layouts
//
//  Created by xiekw on 15/7/8.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "UIView+JUFLXNode.h"
#import <objc/runtime.h>

NSString * const JUFLXNodeUIViewNodeKey = @"hrnode.JUFLXNodeUIViewNodeKey";
NSString * const JUFLXNodeUIViewDidFinishBlockKey = @"hrnode.JUFLXNodeUIViewDidFinishBlockKey";

@implementation UIView (JUFLXNodeGetter)

- (JUFLXNode *)ju_flxNode {
    return objc_getAssociatedObject(self, &JUFLXNodeUIViewNodeKey);
}

- (NodeDidFinishLayout)ju_flxNodeDidFinishLayoutBlock {
    return objc_getAssociatedObject(self, &JUFLXNodeUIViewDidFinishBlockKey);
}

- (void)setJu_flxNodeDidFinishLayoutBlock:(NodeDidFinishLayout)block {
    objc_setAssociatedObject(self, &JUFLXNodeUIViewDidFinishBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
