//
//  DXPagingScrollView.m
//  PlayNimbus
//
//  Created by xiekw on 15/5/10.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXPagingScrollView.h"

@implementation DXPagingScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // This allows for touch handling outside of the scroll view's bounds.
    
    CGPoint parentLocation = [self convertPoint:point toView:self.superview];
    
    CGRect responseRect = self.frame;
    responseRect.origin.x -= _previewInsets.left;
    responseRect.origin.y -= _previewInsets.top;
    responseRect.size.width += (_previewInsets.left + _previewInsets.right);
    responseRect.size.height += (_previewInsets.top + _previewInsets.bottom);
    
    return CGRectContainsPoint(responseRect, parentLocation);
}


@end
