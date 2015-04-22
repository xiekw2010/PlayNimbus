//
//  PNPageBannerViewController.m
//  PlayNimbus
//
//  Created by xiekw on 15/4/20.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "PNPageBannerViewController.h"
#import "NimbusPagingScrollView.h"
#import "DXADBanner.h"

@interface PNPageBannerViewController ()

@end

@implementation PNPageBannerViewController
{
    DXADBanner *_banner;
    DXADBanner *_banner1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    _banner = [[DXADBanner alloc] initWithFrame:NIRectContract(CGRectOffset(self.view.bounds, 0, 200), 0, 350)];
    [self.view addSubview:_banner];
    
    CGSize bannerSize = _banner.bounds.size;
    DXBannerAction action = ^(NSUInteger index, DXADBanner *banner) {
        NSLog(@"did select at %ld", (long)index);
    };
    NSArray *bannerobjs = @[
                            [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://gtms03.alicdn.com/tps/i3/TB1HKGsHFXXXXXHXXXXTdm96pXX-1190-40.jpg"] actionBlock:action],
                            [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://gtms01.alicdn.com/tps/i1/TB1Ki8FHFXXXXc8XXXXvKyzTVXX-520-280.jpg"] actionBlock:action],
                            [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://i.mmcdn.cn/simba/img/TB1BfBYHpXXXXa9XpXXSutbFXXX.jpg"] actionBlock:action],
                            [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://i.mmcdn.cn/simba/img/TB1WqBtFpXXXXaeeXXXSutbFXXX.jpg"] actionBlock:action]
                            ];
    _banner.adItems = bannerobjs;
    
    
    
    _banner1 = [[DXADBanner alloc] initWithFrame:CGRectOffset(_banner.frame, 0, -CGRectGetHeight(_banner.frame) - 10)];
    [self.view addSubview:_banner1];
    
    NSArray *bannerobjs1 = @[
                             [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://i.mmcdn.cn/simba/img/TB1BfBYHpXXXXa9XpXXSutbFXXX.jpg"] actionBlock:action],
                             [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://gtms03.alicdn.com/tps/i3/TB1HKGsHFXXXXXHXXXXTdm96pXX-1190-40.jpg"] actionBlock:action],
                             [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://i.mmcdn.cn/simba/img/TB1WqBtFpXXXXaeeXXXSutbFXXX.jpg"] actionBlock:action],
                             [DXImageBannerItem bannerObjectWithPlaceholder:[UIImage imageWithColor:[UIColor randomColor] cropSize:bannerSize] imageURL:[NSURL URLWithString:@"http://gtms01.alicdn.com/tps/i1/TB1Ki8FHFXXXXc8XXXXvKyzTVXX-520-280.jpg"] actionBlock:action]
                            ];
    _banner1.adItems = bannerobjs1;


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
