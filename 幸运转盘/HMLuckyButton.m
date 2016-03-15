//
//  HMLuckyButton.m
//  幸运转盘
//
//  Created by HM on 16/1/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "HMLuckyButton.h"

@implementation HMLuckyButton
#pragma mark - 用来调整按钮自身图片的大小
- (CGRect)imageRectForContentRect:(CGRect)contentRect {

    CGFloat width = 40;
    CGFloat heigth = 47;
    CGFloat x = (contentRect.size.width - width) * 0.5;
    CGFloat y = 20;
    
    return CGRectMake(x, y, width, heigth);
}


#pragma mark - 高亮显示效果 
// 屏蔽系统高亮时按钮为灰色的效果
- (void)setHighlighted:(BOOL)highlighted {
}


@end
