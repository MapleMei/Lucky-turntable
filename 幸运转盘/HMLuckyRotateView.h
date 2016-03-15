//
//  HMLuckyRotateView.h
//  幸运转盘
//
//  Created by HM on 16/1/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMLuckyRotateView;
@protocol HMLuckyRotateViewDelegate <NSObject>

@optional
- (void)didFinishChooseNumber:(HMLuckyRotateView *)rotateView;

@end

@interface HMLuckyRotateView : UIView

/** 创建转盘界面的方法 */
+ (instancetype)luckyRotateView;


- (void)startRotate;


@property (nonatomic, assign) id<HMLuckyRotateViewDelegate> delegate;

@end
