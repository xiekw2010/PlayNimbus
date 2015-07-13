//
//  PNAttributeLabelController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/25.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNAttributeLabelController.h"
#import "JUFLXNode.h"
#import "ALFLEXBOXUtils.h"

@implementation PNAttributeLabelController
{
    JUFLXNode *_rootNode;
    JUFLXNode *_box1;
    JUFLXNode *_box2;
    JUFLXNode *_box3;
    JUFLXNode *_box4;
    UITapGestureRecognizer *_tap;
    UIScrollView *_scv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scv];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:_tap];
    
    [self render];
}

- (void)tapped {
    _box1.flex --;
    _box2.flex ++;
    _box4.flex ++;
    _box3.flex --;
    [UIView animateWithDuration:0.5 animations:^{
        [_rootNode layoutAysnc:NO completionBlock:NULL];
    }];
}

- (void)render {
    _box1 = [[JUFLXNode alloc] initWithView:[ALFLEXBOXUtils randomColorBox] children:nil];
    [_box1 bindingInlineCSS:@"margin:20, flex:20"];
    
    _box2 = [_box1 copyNodeWithView:[ALFLEXBOXUtils randomColorBox] children:@[[JUFLXNode nodeWithView:[ALFLEXBOXUtils randomColorBox]],
                                                                               [JUFLXNode nodeWithView:[ALFLEXBOXUtils randomColorBox]],
                                                                               [JUFLXNode nodeWithView:[ALFLEXBOXUtils randomColorBox]]
                                                                               ]];
    [_box2 bindingInlineCSS:@"padding:20, margin:10, flex:15"];
    
    _box3 = [_box1 copyNodeWithView:[ALFLEXBOXUtils randomColorBox] children:nil];
    
    _box4 = [_box1 copyNodeWithView:[ALFLEXBOXUtils randomColorBox] children:nil];
    
    JUFLXNode *node = [[JUFLXNode alloc] initWithView:_scv children:@[_box1, _box2, _box3, _box4]];
    [node bindingInlineCSS:@"flex-direction:column"];
    
    [node setNeedsLayout];
    
    _rootNode = node;
}

@end
