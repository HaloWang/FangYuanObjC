//
//  FYDTableViewCell.h
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 王策. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYDTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UILabel *itemPriceLabel;

- (void)setItemPriceShow:(BOOL)show;

@end
