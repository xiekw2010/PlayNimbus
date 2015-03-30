//
//  DXUtilViews.h
//  DXPhotoSelectBrowser
//
//  Created by xiekw on 12/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"

@interface _ConfirmView : UIView

@property (nonatomic, strong) CAShapeLayer *checkLayer;

- (void)makeGreenAndCheck;
+ (CGSize)standSize;

@end

@interface DXAlbumCell : UITableViewCell<NICell>

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) _ConfirmView *confirmView;

+ (CGFloat)standHeight;

- (BOOL)shouldUpdateCellWithObject:(id)object;

@end

@interface TriangleButton : UIButton


- (instancetype)initWithFrame:(CGRect)frame themeColor:(UIColor *)color;

@end

@interface DXAlbumCellObject : NSObject<NICellObject>

+ (id)objectWithTitle:(NSString *)title placeholderImage:(UIImage *)image imageURL:(NSString *)imageURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, copy) NSString *imageURL;

@end

