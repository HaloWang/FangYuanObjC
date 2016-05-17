//
//  FYDTableViewCell.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "FYDTableViewCell.h"
#import <HaloObjC.h>
#import <FangYuanObjC/UIView+FangYuan.h>

@implementation FYDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.itemPriceLabel = [[UILabel new] addToSuperview:self];
        self.itemTitleLabel = [[UILabel new] addToSuperview:self];
        
        self.itemPriceLabel.backgroundColor = [UIColor redColor];
        self.itemTitleLabel.backgroundColor = [UIColor greenColor];
    
        self.itemPriceLabel
        .fy_top(5)
        .fy_right(5)
        .fy_bottom(5)
        .fy_width(80);
        
        self.itemTitleLabel
        .fy_top(5)
        .fy_right(self.itemPriceLabel.chainLeft + 5)
        .fy_bottom(5)
        .fy_width(80);
    }
    return self;
}

- (void)setItemPriceShow:(BOOL)show {
    // TODO: ⚠️BUG
    self.itemPriceLabel.hidden = !show;
    self.itemTitleLabel.fy_right(show ? self.itemPriceLabel.chainLeft + 5 : 5);
}

@end
