//
//  DXUtilViews.m
//  DXPhotoSelectBrowser
//
//  Created by xiekw on 12/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "DXUtilViews.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation _ConfirmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetHeight(frame)*0.5;
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        CGFloat const checkInset = 8.0;
        CGRect shaperFrame = CGRectInset(self.bounds, checkInset, checkInset);
        self.checkLayer = [CAShapeLayer layer];
        self.checkLayer.frame = shaperFrame;
        self.checkLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.checkLayer];
        
        [self makeGreenAndCheck];
    }
    return self;
}

- (void)makeGreenAndCheck
{
    CGRect shaperFrame = self.checkLayer.frame;
    UIBezierPath *checkPath = [UIBezierPath new];
    CGFloat const width = shaperFrame.size.width;
    CGFloat const height = shaperFrame.size.height;
    [checkPath moveToPoint:CGPointMake(0, height*0.65)];
    [checkPath addLineToPoint:CGPointMake(width*0.36, height)];
    [checkPath addLineToPoint:CGPointMake(width, height*0.2)];
    
    self.checkLayer.path = checkPath.CGPath;
    self.checkLayer.lineWidth = 3.0;
    [self.checkLayer strokeEnd];
}

+ (CGSize)standSize
{
    return CGSizeMake(32.0, 30.0);
}

@end;

@implementation DXAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.confirmView = [[_ConfirmView alloc] initWithFrame:(CGRect){CGPointZero, [_ConfirmView standSize]}];
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.contentView addSubview:self.confirmView];
//        [self.confirmView makeGreenAndCheck];
    }else {
        [self.confirmView removeFromSuperview];
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.confirmView.checkLayer.strokeColor = _normalColor.CGColor;
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ([object isKindOfClass:[DXAlbumCellObject class]]) {
        DXAlbumCellObject *obj = object;
        self.textLabel.text = obj.title;
        self.detailTextLabel.text = @"hello";
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:obj.imageURL] placeholderImage:nil];
        return YES;
    }
    return NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.contentView.frame = bounds;
    CGSize imageSize = CGSizeMake(bounds.size.height * 0.7, bounds.size.height * 0.7);
    CGFloat const imageLeft = 18.0;
    self.imageView.frame = CGRectMake(imageLeft, (bounds.size.height - imageSize.height) * 0.5, imageSize.width, imageSize.height);
    CGFloat const labelLeft = 12.0;
    CGFloat labelHeight = CGRectGetHeight(self.imageView.frame) * 0.5;
    self.textLabel.frame = CGRectMake(labelLeft + CGRectGetMaxX(self.imageView.frame), CGRectGetMinY(self.imageView.frame), bounds.size.width * 0.8, labelHeight);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame), CGRectGetMaxY(self.textLabel.frame), CGRectGetWidth(self.textLabel.frame), labelHeight);
    CGSize confirmViewSize = self.confirmView.bounds.size;
    self.confirmView.frame = CGRectMake(bounds.size.width - confirmViewSize.width - 15, (bounds.size.height - confirmViewSize.height) * 0.5, confirmViewSize.width, confirmViewSize.height);
}

+ (CGFloat)standHeight
{
    return 50.0;
}

@end

@interface TriangleLayer : CAShapeLayer

- (UIImage *)tImage;

@end

@implementation TriangleLayer

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    UIBezierPath *path = [UIBezierPath new];
    CGSize const triangleSize = bounds.size;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(triangleSize.width * 0.5, triangleSize.height)];
    [path addLineToPoint:CGPointMake(triangleSize.width, 0)];
    self.path = path.CGPath;
}

- (UIImage *)tImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, 0, 0);
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end

@interface TriangleButton ()

@end

@implementation TriangleButton

- (instancetype)initWithFrame:(CGRect)frame themeColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        TriangleLayer *triangleShaper = [TriangleLayer layer];
        triangleShaper.fillColor = color.CGColor;
        triangleShaper.bounds = CGRectMake(0, 0, 8, 5);
        self.imageView.bounds = triangleShaper.bounds;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self setImage:[triangleShaper tImage] forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize = [[self titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    CGFloat const betweenTextAndTriangle = 4.0;
    CGFloat wholeWidth = betweenTextAndTriangle + self.imageView.bounds.size.width + textSize.width;
    self.titleLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - wholeWidth) * 0.5, (CGRectGetHeight(self.bounds) - textSize.height) * 0.5, textSize.width, textSize.height);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + betweenTextAndTriangle, (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.imageView.bounds)) * 0.5 + 1.0, CGRectGetWidth(self.imageView.bounds), CGRectGetHeight(self.imageView.bounds));
}

@end

@implementation DXAlbumCellObject

+ (id)objectWithTitle:(NSString *)title placeholderImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    DXAlbumCellObject *obj = [[self class] new];
    obj.title = title;
    obj.placeholder = image;
    obj.imageURL = imageURL;
    return obj;
}

- (Class)cellClass
{
    return [DXAlbumCell class];
}

@end

