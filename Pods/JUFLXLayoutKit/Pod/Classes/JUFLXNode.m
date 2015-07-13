//
//  JUFLXNode.m
//  all_layouts
//
//  Created by xiekw on 15/7/5.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "JUFLXNode.h"
#import "UIView+JUFLXNode.h"
#import <objc/runtime.h>
#import "JUFLXCSSParser.h"

@interface UIView (JUFLXNodeSetter)

- (void)setJu_flxNode:(JUFLXNode *)node;

@end

CGFloat const JUFLXLayoutFloatUnDefined = CSS_UNDEFINED;

static bool alwaysDirty(void *context) {
    JUFLXNode *self = (__bridge JUFLXNode *)context;
    return self->_dirty;
}

static css_node_t * getChild(void *context, int i) {
    JUFLXNode *self = (__bridge JUFLXNode *)context;
    JUFLXNode *child = self.childNodes[i];
    return child.node;
}

static css_dim_t measureNode(void *context, float width) {
    JUFLXNode *self = (__bridge JUFLXNode *)context;
    CGSize size = self.measure(width);
    return (css_dim_t){ size.width, size.height };
}

@implementation JUFLXNode {
    UIView *_view;
    css_node_t *_node;
    NSArray *_childNodes;
    CGPoint _viewOrigin;
}

@synthesize node = _node, dimensions = _dimensions;

- (void)dealloc {
    free_css_node(_node);
}

- (instancetype)init {
    return [self initWithView:[UIView new]];
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithView:view children:nil];
}

- (instancetype)initWithView:(UIView *)view children:(NSArray *)childNodes {
    if (self = [super init]) {
        _dirty = YES;
        _node = new_css_node();
        _node->context = (__bridge void *)self;
        _node->is_dirty = alwaysDirty;
        _node->get_child = getChild;
        
        //as container initial
        self.direction = JUFLXLayoutDirectionRow;
        self.alignItems = JUFLXLayoutAlignmentStretch;
        self.alignContent = JUFLXLayoutAlignmentStretch;
        self.justifyContent = JUFLXLayoutJustifyContentStart;
        self.flexWrap = NO;
        
        //as child initial
        self.alignSelf = JUFLXLayoutAlignmentAuto;
        self.margin = UIEdgeInsetsZero;
        self.padding = UIEdgeInsetsZero;
        self.flex = 1;

        _view = view;
        _viewOrigin = view.frame.origin;
        [_view setJu_flxNode:self];

        self.childNodes = childNodes;
        [self generateViewTreeWithView:_view childNodes:_childNodes];
    }
    return self;
}

+ (instancetype)nodeWithView:(UIView *)view {
    return [[[self class] alloc] initWithView:view];
}

+ (instancetype)nodeWithView:(UIView *)view children:(NSArray *)childNodes {
    return [[[self class] alloc] initWithView:view children:(NSArray *)childNodes];
}

- (instancetype)copyNodeWithView:(UIView *)view {
    return [self copyNodeWithView:view children:nil];
}

- (instancetype)copyNodeWithView:(UIView *)view
                        children:(NSArray *)childNodes {
    JUFLXNode *node = [[self class] nodeWithView:view children:childNodes];
    node.direction = self.direction;
    node.alignItems = self.alignItems;
    node.alignContent = self.alignContent;
    node.justifyContent = self.justifyContent;
    node.flexWrap = self.flexWrap;
    node.alignSelf = self.alignSelf;
    node.flex = self.flex;
    node.dimensions = self.dimensions;
    node.minDimensions = self.minDimensions;
    node.maxDimensions = self.maxDimensions;
    node.margin = self.margin;
    node.padding = self.padding;
    node.measure = [self.measure copy];

    return node;
}

- (void)setChildNodes:(NSArray *)childNodes {
    _childNodes = [childNodes copy];
    
    _node->children_count = (int)_childNodes.count;
}

- (void)generateViewTreeWithView:(UIView *)view childNodes:(NSArray *)childNodes {
    for (JUFLXNode *childNode in childNodes) {
        [view addSubview:childNode.view];
        // only generate the node has child nodes
        if ([childNode isContainer]) {
            [self generateViewTreeWithView:childNode.view childNodes:childNode.childNodes];
        }
    }
}

- (BOOL)isContainer {
    return _childNodes.count > 0;
}

- (CGRect)frame {
    return (CGRect) {
        .origin.x = self.node->layout.position[CSS_LEFT] + _viewOrigin.x,
        .origin.y = self.node->layout.position[CSS_TOP] + _viewOrigin.y,
        .size.width = self.node->layout.dimensions[CSS_WIDTH],
        .size.height = self.node->layout.dimensions[CSS_HEIGHT]
    };
}

- (void)_layoutWithNode {
    [self _resetNode];
    layoutNode(_node, self.dimensions.width, _node->style.direction);
}

- (void)_assignNodeFrame {
    self.view.frame = self.frame;
    
    if (self.view.ju_flxNodeDidFinishLayoutBlock) {
        self.view.ju_flxNodeDidFinishLayoutBlock(self);
    }
    
    for (JUFLXNode *subNode in _childNodes) {
        if ([subNode isContainer]) {
            [subNode _assignNodeFrame];
        } else {
            subNode.view.frame = subNode.frame;
            
            if (subNode.view.ju_flxNodeDidFinishLayoutBlock) {
                subNode.view.ju_flxNodeDidFinishLayoutBlock(subNode);
            }
        }
    }
}

- (void)_resetNode {
    for (JUFLXNode *subNode in _childNodes) {
        [subNode _resetNode];
    }

    self.node->layout.position[CSS_LEFT] = 0;
    self.node->layout.position[CSS_TOP] = 0;
    self.node->layout.position[CSS_RIGHT] = 0;
    self.node->layout.position[CSS_BOTTOM] = 0;
    
    self.node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    self.node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
}

- (void)layoutAysnc:(BOOL)aysnc completionBlock:(dispatch_block_t)block {
    _dirty = YES;
    if (aysnc) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self _layoutWithNode];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _assignNodeFrame];
                _dirty = NO;
                if (block) {
                    block();
                }
            });
        });
    } else {
        [self _layoutWithNode];
        [self _assignNodeFrame];
        _dirty = NO;
        if (block) {
            block();
        }
    }
}

- (void)layout {
    [self layoutAysnc:NO completionBlock:NULL];
}

- (void)setNeedsLayout {
    if (_dirty) {
        [self layout];
    }
}

- (CGSize)dimensions {
    if (CGSizeEqualToSize(_dimensions, CGSizeZero)) {
        _dimensions = self.view.bounds.size;
        _node->style.dimensions[CSS_WIDTH] = _dimensions.width;
        _node->style.dimensions[CSS_HEIGHT] = _dimensions.height;
    }
    return _dimensions;
}

- (void)setDimensions:(CGSize)size {
    if (CGSizeEqualToSize(_dimensions, size)) return;
    _dimensions = size;
    _node->style.dimensions[CSS_WIDTH] = size.width;
    _node->style.dimensions[CSS_HEIGHT] = size.height;
    _dirty = YES;
}

- (void)setMinDimensions:(CGSize)size {
    if (CGSizeEqualToSize(_minDimensions, size)) return;
    _minDimensions = size;
    _node->style.minDimensions[CSS_WIDTH] = size.width;
    _node->style.minDimensions[CSS_HEIGHT] = size.height;
    _dirty = YES;
}

- (void)setMaxDimensions:(CGSize)size {
    if (CGSizeEqualToSize(_maxDimensions, size)) return;
    _maxDimensions = size;
    _node->style.maxDimensions[CSS_WIDTH] = size.width;
    _node->style.maxDimensions[CSS_HEIGHT] = size.height;
    _dirty = YES;
}

- (void)setMargin:(UIEdgeInsets)margin {
    if (UIEdgeInsetsEqualToEdgeInsets(_margin, margin)) return;
    _margin = margin;
    _node->style.margin[CSS_LEFT] = margin.left;
    _node->style.margin[CSS_TOP] = margin.top;
    _node->style.margin[CSS_RIGHT] = margin.right;
    _node->style.margin[CSS_BOTTOM] = margin.bottom;
    _dirty = YES;
}

- (void)setPadding:(UIEdgeInsets)padding {
    if (UIEdgeInsetsEqualToEdgeInsets(_padding, padding)) return;
    _padding = padding;
    _node->style.padding[CSS_LEFT] = padding.left;
    _node->style.padding[CSS_TOP] = padding.top;
    _node->style.padding[CSS_RIGHT] = padding.right;
    _node->style.padding[CSS_BOTTOM] = padding.bottom;
    _dirty = YES;
}

- (void)setDirection:(JUFLXLayoutDirection)direction {
    if (_direction == direction) return;
    _direction = direction;
    _node->style.flex_direction = (int)_direction;
    _dirty = YES;
}

- (void)setAlignContent:(JUFLXLayoutAlignment)alignContent {
    if (_alignContent == alignContent) return;
    _alignContent = alignContent;
    _node->style.align_content = (int)alignContent;
    _dirty = YES;
}

- (void)setAlignItems:(JUFLXLayoutAlignment)alignItems {
    if (_alignItems == alignItems) return;
    _alignItems = alignItems;
    _node->style.align_items = (int)_alignItems;
    _dirty = YES;
}

- (void)setJustifyContent:(JUFLXLayoutJustifyContent)justifyContent {
    if (_justifyContent == justifyContent) return;
    _justifyContent = justifyContent;
    _node->style.justify_content = (int)_justifyContent;
    _dirty = YES;
}

- (void)setFlexWrap:(BOOL)flexWrap {
    if (_flexWrap == flexWrap) return;
    _flexWrap = flexWrap;
    _node->style.flex_wrap = _flexWrap;
    _dirty = YES;
}

- (void)setAlignSelf:(JUFLXLayoutAlignment)alignSelf {
    if (_alignSelf == alignSelf) return;
    _alignSelf = alignSelf;
    _node->style.align_self = (int)_alignSelf;
    _dirty = YES;
}

- (void)setFlex:(CGFloat)flex {
    if (_flex == flex) return;
    _flex = flex;
    _node->style.flex = _flex;
    _dirty = YES;
}

- (void)setMeasure:(CGSize (^)(CGFloat))measure {
    if (measure) {
        _measure = [measure copy];
        _node->measure = (_measure != nil ? measureNode : NULL);
        
        // since we have a measured size, the flex grow is no need;
        self.flex = 0;
    }
}

- (void)bindingInlineCSS:(NSString *)inlineCSS {
    [JUFLXCSSParser parseInlineCSS:inlineCSS toNode:self];
}

- (NSString *)description {
    NSString *selfDescription = [NSString stringWithFormat:@"{node's view is %@ and child nodes is \n %@", self.view, self.childNodes];
    print_css_node(_node, CSS_PRINT_STYLE | CSS_PRINT_CHILDREN | CSS_PRINT_LAYOUT);
    return selfDescription;
}

@end

@implementation UIView (JUFLXNodeSetter)

- (void)setJu_flxNode:(JUFLXNode *)node {
    if (node.view == self) {
        objc_setAssociatedObject(self, &JUFLXNodeUIViewNodeKey, node, OBJC_ASSOCIATION_ASSIGN);
    } else {
        NSLog(@"You're trying to set a different node with self %@", self);
    }
}


@end
