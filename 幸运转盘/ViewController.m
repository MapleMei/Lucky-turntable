//
//  ViewController.m
//  幸运转盘
//
//  Created by HM on 16/1/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ViewController.h"
#import "HMLuckyRotateView.h"

@interface ViewController () <HMLuckyRotateViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置背景
    self.view.layer.contents = (id)[UIImage imageNamed:@"LuckyBackground"].CGImage;
    
    // 2.1 加载转盘界面
    HMLuckyRotateView *luckyView = [HMLuckyRotateView luckyRotateView];
    
    // 2.2 设置中心点
    luckyView.center = self.view.center;
    
    // 2.3 设置代理
    luckyView.delegate = self;
    
    // 2.4 添加到控制器的view内
    [self.view addSubview:luckyView];
    
    
    // 3.让转盘开始旋转
    [luckyView startRotate];
    
}

- (void)didFinishChooseNumber:(HMLuckyRotateView *)rotateView {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"1,2,1,3,4,4,9" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 1.开始旋转
            [rotateView startRotate];
            
            // 2.开启用户交互
            rotateView.userInteractionEnabled = YES;
            
        }];
        
        [alertVc addAction:action];
        
        [self presentViewController:alertVc animated:YES completion:nil];
        
    });

}



// 2.设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}


@end
