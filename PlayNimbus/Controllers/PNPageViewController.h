//
//  PNPageViewController.h
//  PlayNimbus
//
//  Created by xiekw on 15/3/25.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNPageViewController : UIViewController

@property (nonatomic, assign) CGFloat pageMargin;
@property (nonatomic, strong) NSString *title;

- (void)showInContainer:(UIViewController *)container
               animated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;


@end
