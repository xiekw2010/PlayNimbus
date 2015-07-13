//
//  PNPageViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/25.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNPageViewController.h"
#import "NimbusPagingScrollView.h"
#import "UICategory.h"
#import "Page1.h"

typedef NS_ENUM(NSUInteger, PNPagingVCState) {
    PNPagingVCStateNormal,
    PNPagingVCStateFullDisplay,
    PNPagingVCStateFullDisplaying,
    PNPagingVCStateCenterDowning,
    PNPagingVCStateWholeDowning,
    PNPagingVCStateDismiss,
};


static BOOL __isShowing;

@interface PNPageViewController ()<
NIPagingScrollViewDataSource,
NIPagingScrollViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *parent;
@property (nonatomic, strong) UIControl *dimView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) PNPagingVCState state;

@end

@implementation PNPageViewController
{
    NIPagingScrollView *_pageScrollView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.pageMargin = 25.0;
    self.state = PNPagingVCStateNormal;
}

- (CGFloat)navBarHeight {
    return 64.0;
}

- (void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.dimView = [[UIControl alloc] initWithFrame:self.view.bounds];
    self.dimView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self.dimView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dimView];

    
    CGRect pageFrame = CGRectMake(self.pageMargin,
                                  [self navBarHeight],
                                  CGRectGetWidth(self.view.bounds) - self.pageMargin * 2,
                                  CGRectGetHeight(self.view.bounds) - [self navBarHeight]);
    
    _pageScrollView = [[NIPagingScrollView alloc] initWithFrame:pageFrame];
    _pageScrollView.clipsToBounds = NO;
    [_pageScrollView scrollView].clipsToBounds = NO;

    _pageScrollView.pageMargin = 8.0;
    _pageScrollView.dataSource = self;
    _pageScrollView.delegate = self;
    [self.view addSubview:_pageScrollView];
    [_pageScrollView reloadData];
    
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)panG {
    
    CGFloat translationY = [panG translationInView:self.view].y;
    CGFloat velocityY = [panG velocityInView:self.view].y;
    
    UIGestureRecognizerState state = panG.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            // the valide initial state
            if (_state != PNPagingVCStateNormal && _state != PNPagingVCStateFullDisplay) {
                return;
            }
            
            PNPagingVCState toState;
            
            if (translationY < 0) {
                toState = PNPagingVCStateFullDisplaying;
            }else {
                if (_state == PNPagingVCStateNormal) {
                    toState = PNPagingVCStateWholeDowning;
                }else{
                    toState = PNPagingVCStateCenterDowning;
                }
            }
            
            [self transitionFromState:_state toState:toState translationY:translationY velocityY:velocityY];

            NSLog(@"UIGestureRecognizerStateBegan translationY is %f and velocity is %f", translationY, velocityY);
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"UIGestureRecognizerStateChanged translationY is %f and velocity is %f", translationY, velocityY);
            switch (_state) {
                case PNPagingVCStateCenterDowning:
                    if (translationY > [self navBarHeight]) {
                        [self transitionFromState:_state toState:PNPagingVCStateNormal translationY:translationY velocityY:velocityY];
                    }else {
                        [self shrinkPageWithTranslationY:translationY];
                    }
                    
                    break;
                case PNPagingVCStateFullDisplaying:
                {
                    if (translationY < -[self navBarHeight]) {
                        [self transitionFromState:_state toState:PNPagingVCStateFullDisplay translationY:translationY velocityY:velocityY];
                    }else {
                        [self expandPageWithTranslationY:translationY];
                    }
                }
                    
                    break;
                case PNPagingVCStateWholeDowning:
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"UIGestureRecognizerStateEnded translationY is %f and velocity is %f", translationY, velocityY);
            PNPagingVCState toState;
            switch (_state) {
                case PNPagingVCStateCenterDowning:
                case PNPagingVCStateNormal:
                    toState = PNPagingVCStateNormal;
                    break;
                case PNPagingVCStateWholeDowning:
                    toState = PNPagingVCStateDismiss;
                    break;
                case PNPagingVCStateFullDisplaying:
                    toState = PNPagingVCStateFullDisplay;
                default:
                    break;
            }
            [self transitionFromState:_state toState:toState translationY:translationY velocityY:velocityY];
        }
            
            break;
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"UIGestureRecognizerStateCancelled translationY is %f and velocity is %f", translationY, velocityY);
        }
            break;
        default:
            break;
    }
}

- (CGFloat)pageScrollViewPageWidth {
    return CGRectGetWidth(_pageScrollView.bounds) - _pageScrollView.pageMargin * 2;
}

- (void)shrinkPageWithTranslationY:(CGFloat)translationY {
    Page1 *page = (Page1 *)_pageScrollView.centerPageView;

    translationY = MIN(ABS(translationY), [self navBarHeight]);
    CGFloat pageWidth = CGRectGetWidth(_pageScrollView.bounds);
    CGFloat selfViewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat movedX = (selfViewWidth - pageWidth) * translationY / [self navBarHeight];
    movedX = MIN(movedX, selfViewWidth - pageWidth);
    CGFloat resultWidth = selfViewWidth - movedX;
    
    CGFloat pageHeight = CGRectGetHeight(_pageScrollView.bounds);
    CGFloat selfViewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat movedY = (selfViewHeight - pageHeight) * translationY / [self navBarHeight];
    movedY = MIN(movedY, [self navBarHeight]);
    CGFloat resultHeight = selfViewHeight - movedY;

    CGRect pageFrame = [_pageScrollView frameForPageAtIndex:_pageScrollView.centerPageIndex];
    pageFrame.origin.x -= (movedX / 2);
    pageFrame.origin.y -= (movedY / 2);
    pageFrame.size.width = resultWidth;
    pageFrame.size.height = resultHeight;
    
    page.frame = pageFrame;

}

- (void)expandPageWithTranslationY:(CGFloat)translationY {
    Page1 *page = (Page1 *)_pageScrollView.centerPageView;
    
    translationY = MIN(ABS(translationY), [self navBarHeight]);
    CGFloat pageWidth = CGRectGetWidth(_pageScrollView.bounds);
    CGFloat selfViewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat targetWidth = (ABS(translationY) / [self navBarHeight]) * (selfViewWidth - pageWidth) + pageWidth;
    
    CGFloat pageHeight = CGRectGetHeight(_pageScrollView.bounds);
    CGFloat selfViewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat targetHeight = (ABS(translationY) / [self navBarHeight]) * (selfViewHeight - pageHeight) + pageHeight;
    
    CGRect pageFrame = [_pageScrollView frameForPageAtIndex:_pageScrollView.centerPageIndex];
    pageFrame.origin.x = pageFrame.origin.x - (targetWidth - pageWidth) / 2;
    pageFrame.origin.y = pageFrame.origin.y - (targetHeight - pageHeight);
    pageFrame.size.width = targetWidth;
    pageFrame.size.height = targetHeight;
    
    page.frame = pageFrame;

}

- (BOOL)transitionFromState:(PNPagingVCState)from
                    toState:(PNPagingVCState)to
               translationY:(CGFloat)translationY
                  velocityY:(CGFloat)velocityY {
    
    BOOL isValidTransition = NO;
    Page1 *page = (Page1 *)_pageScrollView.centerPageView;
    
    switch (from) {
        case PNPagingVCStateNormal:
            switch (to) {
                case PNPagingVCStateFullDisplaying:
                {
                    [page.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.panGesture];
//                    CGPoint pageCenter = page.center;
//                    pageCenter.y += translationY;
//                    page.center = pageCenter;
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateWholeDowning:
                {
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateNormal:
                case PNPagingVCStateFullDisplay:
                case PNPagingVCStateCenterDowning:
                case PNPagingVCStateDismiss:
                default:
                    isValidTransition = NO;
                    break;
            }
            break;
        case PNPagingVCStateFullDisplaying:
            switch (to) {
                case PNPagingVCStateFullDisplay:
                {
                    [self expandPageWithTranslationY:[self navBarHeight]];
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateNormal:
                {
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateFullDisplaying:
                case PNPagingVCStateCenterDowning:
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateDismiss:
                case PNPagingVCStateWholeDowning:
                default:
                    isValidTransition = NO;
                    break;
            }
            break;
        case PNPagingVCStateFullDisplay:
            switch (to) {
                case PNPagingVCStateCenterDowning:
                {
                    [self shrinkPageWithTranslationY:[self navBarHeight]];
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateNormal:
                case PNPagingVCStateFullDisplaying:
                case PNPagingVCStateDismiss:
                case PNPagingVCStateWholeDowning:
                case PNPagingVCStateFullDisplay:
                default:
                    isValidTransition = NO;
                    break;
            }
            break;
        case PNPagingVCStateCenterDowning:
            switch (to) {
                case PNPagingVCStateFullDisplay:
                {
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateNormal:
                case PNPagingVCStateFullDisplaying:
                case PNPagingVCStateDismiss:
                case PNPagingVCStateWholeDowning:
                case PNPagingVCStateCenterDowning:
                default:
                    isValidTransition = NO;
                    break;
            }
            break;
        case PNPagingVCStateWholeDowning:
            switch (to) {
                case PNPagingVCStateNormal:
                {
                    
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateDismiss:
                {
                    
                }
                    isValidTransition = YES;
                    break;
                case PNPagingVCStateFullDisplay:
                case PNPagingVCStateFullDisplaying:
                case PNPagingVCStateWholeDowning:
                case PNPagingVCStateCenterDowning:
                default:
                    isValidTransition = NO;
                    break;
            }
            break;
        default:
            break;
    }
    if (isValidTransition) _state = to;
    return isValidTransition;
}


- (void)presentCenterPage {
    Page1 *page = (Page1 *)_pageScrollView.centerPageView;
    page.center = self.view.center;
    CGFloat totalY = CGRectGetHeight(self.view.bounds) / CGRectGetHeight(page.frame);
    CGFloat totalX = CGRectGetWidth(self.view.bounds) / CGRectGetWidth(page.frame);

    page.transform = CGAffineTransformMakeScale(totalX, totalY);
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture
        && otherGestureRecognizer == _pageScrollView.scrollView.panGestureRecognizer) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _pageScrollView.scrollView.panGestureRecognizer) {
        if (_state == PNPagingVCStateNormal) {
            return NO;
        }
    }
    return YES;
}

- (Page1 *)currentPage {
    return (Page1 *)_pageScrollView.centerPageView;
}

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    return 10;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
    Page1 *page = (Page1 *)[pagingScrollView dequeueReusablePageWithIdentifier:@"gogo"];
    if (!page) {
        page = [[Page1 alloc] initWithReuseIdentifier:@"gogo"];
    }
    return page;
}

- (void)showInContainer:(UIViewController *)container animated:(BOOL)animated {
    if (__isShowing) {
        return;
    }
    __isShowing = YES;
    
    UIViewController *tvc = container;
    if (container.navigationController) {
        tvc = container.navigationController;
        self.navigationController.navigationBarHidden = YES;
    }
    [tvc addChildViewController:self];
    self.view.frame = tvc.view.bounds;
    [tvc.view addSubview:self.view];
    
    if (animated) {
        [self _animateDropIn:^{
            [self didMoveToParentViewController:tvc];
        }];
    }else {
        [self didMoveToParentViewController:tvc];
    }
}

- (void)_animateDropIn:(dispatch_block_t)block
{
    CGPoint center = self.view.center;
    center.y += CGRectGetHeight(self.view.bounds);
    self.view.center = center;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint dimCenter = self.view.center;
        dimCenter.y -= CGRectGetHeight(self.view.bounds);
        self.view.center = dimCenter;
    } completion:^(BOOL finished) {
        block();
    }];
}


- (void)dismissAnimated:(BOOL)animated {
    __isShowing = NO;
    [self willMoveToParentViewController:Nil];
    if (animated) {
        [self _animateFlowOutCompletion:^{
            [self.view removeFromSuperview];;
            [self removeFromParentViewController];
        }];
    }else {
        [self.view removeFromSuperview];;
        [self removeFromParentViewController];
    }
}

- (void)_animateFlowOutCompletion:(dispatch_block_t)block
{
    [UIView animateWithDuration:0.4 animations:^{
        CGPoint center = self.view.center;
        center.y += CGRectGetHeight(self.view.bounds);
        self.view.center = center;
        self.view.alpha = 0.2;
    } completion:^(BOOL finished) {
        block();
    }];
}

- (void)back
{
    [self dismissAnimated:YES];
}

@end
