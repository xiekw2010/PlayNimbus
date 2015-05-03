//
//  DXGridLayoutDefines.h
//  PlayNimbus
//
//  Created by xiekw on 15/4/27.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef struct {
    NSUInteger columnCount;
    NSUInteger lineCount;
}DXGrid;

typedef struct {
    CGFloat lineSpacing;
    CGFloat columnSpacing;
    UIEdgeInsets contentInset;
    CGRect containerSize;
    DXGrid grid;
}DXGridLayout;


NS_INLINE DXGridLayout DXGridLayoutWith(CGFloat lineSpacing, CGFloat columnSpacing, UIEdgeInsets contentInset, CGRect containerSize, DXGrid grid)
{
    DXGridLayout layout;
    layout.lineSpacing = lineSpacing;
    layout.columnSpacing = columnSpacing;
    layout.contentInset = contentInset;
    layout.containerSize = containerSize;
    layout.grid = grid;
    return layout;
}


@protocol DXGridNeedConainterSizeObject <NSObject>

- (CGSize)viewSize;

@end

@protocol DXGridNeedConainterSizeObject <NSObject>


@end
