//
//  DXPopupViewController.h
//  UICategories
//
//  Created by xiekw on 12/1/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXPopupViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;

- (void)showInViewController:(UIViewController *)parent animated:(BOOL)animate;
- (void)dismissAnimated:(BOOL)animate;
- (void)dismiss;

+ (CGSize)suggestSize;

@end
