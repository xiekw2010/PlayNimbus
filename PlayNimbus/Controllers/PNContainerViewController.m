//
//  PNContainerViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/27.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNContainerViewController.h"

@interface ChildVC : UIViewController
@end
@implementation ChildVC

- (void)viewDidAppear:(BOOL)animated
{
  
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    UIButton *center = [UIButton buttonWithType:UIButtonTypeCustom];
    center.frame = CGRectMake(0, 0, 100, 44.0);
    [center addTarget:self action:@selector(removeChild) forControlEvents:UIControlEventTouchUpInside];
    [center setTitle:@"Remove" forState:UIControlStateNormal];
    [center setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.view addSubview:center];

}

- (void)removeChild
{
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end


@implementation PNContainerViewController

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addChild)];
}

- (void)addChild
{
    ChildVC *cvc = [ChildVC new];
    [self addChildViewController:cvc];
    cvc.view.frame = CGRectInset(self.view.bounds, 100, 100);
    [self.view addSubview:cvc.view];
    cvc.view.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        cvc.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [cvc beginAppearanceTransition:YES animated:YES];
        [cvc didMoveToParentViewController:self];
    }];
    
}

@end
