/*
 * ---------------------------------------------------------------------------
 *  *  Build base on Facebook's css_layout https://github.com/facebook/css-layout
 *  *  css-layout based on http://www.w3.org/TR/css3-flexbox/
 * ---------------------------------------------------------------------------
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Layout.h"

FOUNDATION_EXTERN CGFloat const JUFLXLayoutFloatUnDefined;

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#flex-direction-property
 */
typedef NS_ENUM(NSInteger, JUFLXLayoutDirection){
    /**
     * inlineCSS -> row
     */
    JUFLXLayoutDirectionRow = CSS_FLEX_DIRECTION_ROW,
    /**
     * inlineCSS -> row-reverse
     */
    JUFLXLayoutDirectionRowReverse = CSS_FLEX_DIRECTION_ROW_REVERSE,
    /**
     * inlineCSS -> column
     */
    JUFLXLayoutDirectionColumn = CSS_FLEX_DIRECTION_COLUMN,
    /**
     * inlineCSS -> column-reverse
     */
    JUFLXLayoutDirectionColumnReverse = CSS_FLEX_DIRECTION_COLUMN_REVERSE,
};

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-items
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-content
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-self
 */
typedef NS_ENUM(NSInteger, JUFLXLayoutAlignment){
    /**
     * inlineCSS -> auto
     */
    JUFLXLayoutAlignmentAuto = CSS_ALIGN_AUTO,
    /**
     * inlineCSS -> flex-start
     */
    JUFLXLayoutAlignmentStart = CSS_ALIGN_FLEX_START,
    /**
     * inlineCSS -> center
     */
    JUFLXLayoutAlignmentCenter = CSS_ALIGN_CENTER,
    /**
     * inlineCSS -> flex-end
     */
    JUFLXLayoutAlignmentEnd = CSS_ALIGN_FLEX_END,
    /**
     * inlineCSS -> stretch
     */
    JUFLXLayoutAlignmentStretch = CSS_ALIGN_STRETCH
};

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-justify-content
 */
typedef NS_ENUM(NSInteger, JUFLXLayoutJustifyContent){
    /**
     * inlineCSS -> flex-start
     */
    JUFLXLayoutJustifyContentStart = CSS_JUSTIFY_FLEX_START,
    /**
     * inlineCSS -> center
     */
    JUFLXLayoutJustifyContentCenter = CSS_JUSTIFY_CENTER,
    /**
     * inlineCSS -> flex-end
     */
    JUFLXLayoutJustifyContentEnd = CSS_JUSTIFY_FLEX_END,
    /**
     * inlineCSS -> space-between
     */
    JUFLXLayoutJustifyContentBetween = CSS_JUSTIFY_SPACE_BETWEEN,
    /**
     * inlineCSS -> space-around
     */
    JUFLXLayoutJustifyContentAround = CSS_JUSTIFY_SPACE_AROUND
};



@interface JUFLXNode : NSObject {
@public
    BOOL _dirty;
}

/**
 *  layout.c's node, the model of css box.
 */
@property (nonatomic, assign, readonly) css_node_t *node;

/**
 *  The view initilized with.
 */
@property (nonatomic, strong, readonly) UIView *view;

/**
 *  After node layout, the node's frame of the whole calculation.
 */
@property (nonatomic, assign, readonly) CGRect frame;

/**
 *  The node's children node.
 */
@property (nonatomic, strong, readonly) NSArray *childNodes;


/*
 * ---------------------------------------------------------------------------
 * As Container's property
 * ---------------------------------------------------------------------------
 */

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#flex-direction-property
 *  inlineCSS -> flex-direction
 *  Default is row
 */
@property (nonatomic, assign) JUFLXLayoutDirection direction;

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-items
 *  inlineCSS -> align-items
 *  Default is stretch
 */
@property (nonatomic, assign) JUFLXLayoutAlignment alignItems;

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-content
 *  inlineCSS -> align-content
 *  Default is stretch
 *  Here we don't support the between and around
 */
@property (nonatomic, assign) JUFLXLayoutAlignment alignContent;

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-justify-content
 *  inlineCSS -> justify-content
 *  Default is start
 */
@property (nonatomic, assign) JUFLXLayoutJustifyContent justifyContent;

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#flex-wrap-property
 *  When the container size doesn't satisfy, if use a new depends on this.
 *  inlineCSS -> flex-wrap
 *  Here we don't support wrap-reverse
 */
@property (nonatomic, assign) BOOL flexWrap;


/*
 * ---------------------------------------------------------------------------
 * As Child's property
 * ---------------------------------------------------------------------------
 */

/**
 *  Check -> http://www.w3.org/TR/css3-flexbox/#propdef-align-self
 *  inlineCSS -> align-self
 *  Default is auto, means depend on containers' alignItems;
 */
@property (nonatomic, assign) JUFLXLayoutAlignment alignSelf;

/**
 *  Flex-grow, eg: A node has three children---a,b,c; a.flex = 1, b.flex = 2, c.flex = 1, then a's size will be 1 / (1 + 2 + 1),
 *  b is 2 / (1 + 2 + 1), c is 1 / (1 + 2 + 1)
 *  inlineCSS -> flex
 *  Here we only support flex-grow as flex, not include shrink.
 *  Default is 1
 */
@property (nonatomic, assign) CGFloat flex;

/*
 * ---------------------------------------------------------------------------
 * As box's property
 * ---------------------------------------------------------------------------
 */

/**
 *  The style dimensions, default is the view's size, if you set it to {nan, nan},
 *  The result frame depends on children's total size, so the children's size should be measured.
 *  inlineCSS -> width, height
 */
@property (nonatomic, assign) CGSize dimensions;

/**
 *  ensure the min dimension of the view size.
 *  inlineCSS -> min-width, min-height
 *  Default is {0,0}
 */
@property (nonatomic, assign) CGSize minDimensions;

/**
 *  ensure the max dimension of the view size.
 *  inlineCSS -> max-width, max-height
 *  Default is {0,0}
 */
@property (nonatomic, assign) CGSize maxDimensions;

/**
 *  The margin of the view.
 *  inlineCSS -> margin, margin-top, margin-left, margin-bottom, margin-right
 */
@property (nonatomic, assign) UIEdgeInsets margin;

/**
 *  The padding of the view.
 *  inlineCSS -> padding, padding-top, padding-left, padding-bottom, padding-right
 */
@property (nonatomic, assign) UIEdgeInsets padding;

/**
 *  When encouter the view size should be calculated like text size, use this block.
 *  If direction is row, then width is the parent's node's frame's width, otherwise is nan.
 */
@property (nonatomic, copy) CGSize (^measure)(CGFloat width);

+ (instancetype)nodeWithView:(UIView *)view;

/**
 *  Create a node
 *
 *  @param view       the root view
 *  @param childNodes an array of JUFLXNodes
 *
 *  @return node
 */
+ (instancetype)nodeWithView:(UIView *)view children:(NSArray *)childNodes;
- (instancetype)copyNodeWithView:(UIView *)view;
- (instancetype)copyNodeWithView:(UIView *)view
                        children:(NSArray *)childNodes;


- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view children:(NSArray *)childNodes;

/**
 *  Bind the node's property to inline css
 *
 *  @param inlineCSS
 *  @see JUFLXCSSParser to learn the writing rule;
 */
- (void)bindingInlineCSS:(NSString *)inlineCSS;

/**
 *  Manually layout the node
 *
 *  @param aysnc move the node calculation back thread
 *  @param block completion
 */
- (void)layoutAysnc:(BOOL)aysnc completionBlock:(dispatch_block_t)block;

/**
 *  layout the node on main thread if dirty == YES
 */
- (void)setNeedsLayout;

@end
