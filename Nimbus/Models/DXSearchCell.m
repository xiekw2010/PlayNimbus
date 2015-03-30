//
//  DXSearchCell.m
//  PlayNimbus
//
//  Created by xiekw on 15/3/27.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "DXSearchCell.h"

@implementation DXSearchObjcet

+ (instancetype)objectWithSearchText:(NSString *)text
{
    DXSearchObjcet *obj = [DXSearchObjcet new];
    obj.searchPlaceholder = [NSString stringWithFormat:NSLocalizedString(@"searching \"%@\"...", nil), text];
    return obj;
}

- (Class)cellClass
{
    return [DXSearchCell class];
}

@end


@implementation DXSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_indicatorView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ([object isKindOfClass:[DXSearchObjcet class]]) {
        DXSearchObjcet *obj = object;
        self.textLabel.text = obj.searchPlaceholder;
        [_indicatorView startAnimating];
        return YES;
    }
    return NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect indicatroFrame = _indicatorView.frame;
    indicatroFrame.origin.x = 12.0;
    indicatroFrame.origin.y = (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(indicatroFrame)) * .5;
    _indicatorView.frame = indicatroFrame;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(indicatroFrame) + 10.0;
    self.textLabel.frame = textLabelFrame;
}


@end
