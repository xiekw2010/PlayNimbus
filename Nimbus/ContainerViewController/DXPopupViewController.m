//
//  DXPopupViewController.m
//  UICategories
//
//  Created by xiekw on 12/1/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "DXPopupViewController.h"

static BOOL __isShowing;

@interface DXPopupViewController ()

@property (nonatomic, strong) UIControl *dimView;

@end

@implementation DXPopupViewController

+ (CGSize)suggestSize
{
    return CGSizeMake(300, 400);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dismissAnimated:(BOOL)animate
{
    __isShowing = NO;
    [self willMoveToParentViewController:Nil];
    if (animate) {
        [self _animateFlowOutCompletion:^{
            [self.view removeFromSuperview];;
            [self removeFromParentViewController];
        }];
    }else {
        [self.view removeFromSuperview];;
        [self removeFromParentViewController];
    }
}

- (void)dismiss
{
    [self dismissAnimated:YES];
}

- (void)showInViewController:(UIViewController *)parent animated:(BOOL)animate
{
    if (__isShowing) {
        return;
    }
    __isShowing = YES;
    
    UIViewController *tvc = parent;
    if (parent.navigationController) {
        tvc = parent.navigationController;
        self.navigationController.navigationBarHidden = YES;
    }
    [tvc addChildViewController:self];
    self.view.frame = tvc.view.bounds;
    [tvc.view addSubview:self.view];
    
    if (animate) {
        [self _animateDropIn:^{
            [self didMoveToParentViewController:tvc];
        }];
    }else {
        [self didMoveToParentViewController:tvc];
    }
}

CGFloat const angle = -M_PI/50;


- (void)_animateDropIn:(dispatch_block_t)block
{
    
    CGPoint center = self.contentView.center;
    center.y -= CGRectGetHeight(self.view.bounds);
    self.contentView.center = center;
    self.contentView.transform = CGAffineTransformMakeRotation(angle);

    [UIView animateWithDuration:0.4 animations:^{
        CGPoint dimCenter = self.dimView.center;
        dimCenter.y += 20;
        self.contentView.center = dimCenter;
        self.contentView.transform = CGAffineTransformMakeRotation(-angle/2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.center = self.dimView.center;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            block();
        }];
    }];
    
}

- (void)_animateFlowOutCompletion:(dispatch_block_t)block
{
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.transform = CGAffineTransformMakeRotation(angle*2);
        CGPoint dimCenter = self.dimView.center;
        dimCenter.y += CGRectGetHeight(self.view.bounds);
        self.contentView.center = dimCenter;
        self.dimView.alpha = 0.2;
    } completion:^(BOOL finished) {
        block();
    }];
}

- (void)back
{
    [self dismissAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dimView = [[UIControl alloc] initWithFrame:self.view.bounds];
    self.dimView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.dimView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dimView];
    
    self.contentView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, [[self class] suggestSize]}];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.center = self.dimView.center;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
