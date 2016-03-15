//
//  HMLuckyRotateView.m
//  幸运转盘
//
//  Created by HM on 16/1/12.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "HMLuckyRotateView.h"
#import "HMLuckyButton.h"

@interface HMLuckyRotateView ()

/** 轮盘图片框 */
@property (weak, nonatomic) IBOutlet UIImageView *rotateWheel;

/** 定义个变量保存选中的按钮 */
@property (nonatomic, weak) HMLuckyButton *selectBtn;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation HMLuckyRotateView

+ (instancetype)luckyRotateView {

    return [[[NSBundle mainBundle] loadNibNamed:@"HMLuckyRotateView" owner:nil options:nil] lastObject];

}

#pragma mark - 开始选号
- (IBAction)chooseNumber {
    
    // 1.结束定时器刷新
    [_link invalidate];
    _link = nil;
    
    // 1.2 禁止用户交互
    self.userInteractionEnabled = NO;
    
    // 2.开启核心动画让转盘快速旋转
    // 2.1 创建基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 2.2 设置关键值
    // 2.2.1 少少旋转的角度
    CGFloat angle = self.selectBtn.tag * (M_PI * 2 / 12);
    
    anim.toValue = @(M_PI * 2 * 7 - angle);
    anim.duration = 3;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // 不要闪回去
//    anim.fillMode = kCAFillModeForwards;
//    anim.removedOnCompletion = NO;
    
    anim.delegate = self;
    
    // 2.3 添加
    [self.rotateWheel.layer addAnimation:anim forKey:nil];
    
    
}

#pragma mark - 当核心动画结束后让轮转真实的transform返回去
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // 1.按钮偏移的角度
    CGFloat angle = self.selectBtn.tag * (M_PI * 2 / 12);
    // 2.让转盘被选中的按钮回到最顶端
    self.rotateWheel.transform = CGAffineTransformMakeRotation(-angle);
    
    // 3.给用户提示 用代理 [A拥有B] [控制器拥有转盘]
    if ([self.delegate respondsToSelector:@selector(didFinishChooseNumber:)]) {
        [self.delegate didFinishChooseNumber:self];
    }
    

}


#pragma mark - 开始旋转
- (void)startRotate {

    // 1.开启定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotating)];
    
    // 2.添加到运行循环
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // 3.引用
    _link = link;
}

#pragma mark - 开始转动
- (void)rotating {
    
    // 1.修改轮子的transform开始旋转
    self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, M_PI_4 * 0.01);

}


#pragma mark - 添加按钮
- (void)awakeFromNib {

    // 添加按钮
    // 1.通过for循环添加按钮
    for (int i = 0; i < 12; i++) {
        
        // 2.创建按钮并添加
        // 2.1 创建按钮
        HMLuckyButton *btn = [HMLuckyButton buttonWithType:UIButtonTypeCustom];
        
        // 2.2 增加标记
        btn.tag = i;
        
        
        // 随机色测试
//        btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

        
        // 2.2 设置按钮的一些图片
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        
        // 2.3 设置星座图片
        // 2.3.1 裁剪图片
        UIImage *normalImg = [self clipImageWithImageName:@"LuckyAstrology" andIndex:i];
        UIImage *selectImg = [self clipImageWithImageName:@"LuckyAstrologyPressed" andIndex:i];
        
        // 2.3.3 设置给按钮
        [btn setImage:normalImg forState:UIControlStateNormal];
        [btn setImage:selectImg forState:UIControlStateSelected];
        
        
        // 2.4 添加
        [self.rotateWheel addSubview:btn];
        
        // 2.5 添加按钮点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

#pragma mark - 点击按钮时调用
- (void)btnClick:(HMLuckyButton *)btn {
    
    // 1.将已经存储的选中按钮设置NO
    self.selectBtn.selected = NO;
    
    // 2.将选中按钮设置为YES
    btn.selected = YES;
    
    // 3.将当前选中的按钮存起来
    self.selectBtn = btn;
    
}

#pragma mark - 裁剪图片的方法
/**
 把图片拿出去
 */
- (UIImage *)clipImageWithImageName:(NSString *)imgName andIndex:(int)idx {

    // 2.3.1 加载图片
    UIImage *img = [UIImage imageNamed:imgName];
    
    // 宽/高/x/y
    CGFloat width = img.size.width / 12;
    CGFloat height = img.size.height;
    CGFloat y = 0;
    CGFloat x = idx * width;
    
    NSLog(@"前面===%@", NSStringFromCGRect(CGRectMake(x, y, width, height)));
    
    // 点坐标 320 320个点
        // 如果是非retina 屏幕 一个点有一个像素
        // retina            一个点对应两个像素
        // 6 plus            一个点对应3个像素
    
    // 裁剪图片里面 rect 他说的是像素
    CGFloat scale = [UIScreen mainScreen].scale; // 获取屏幕的缩放比
   
    
    width *= scale;
    height *= scale;
    x *= scale;
    y *= scale;
    
    NSLog(@"后面===%@", NSStringFromCGRect(CGRectMake(x, y, width, height)));
    
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    // 2.3.2 裁剪图片
    // 是按照像素进行裁切的, 需要乘以缩放比  2
    CGImageRef cgImg = CGImageCreateWithImageInRect(img.CGImage, rect);
    
    // 2.3.3 转为UIImage类型
    UIImage *clipImg = [UIImage imageWithCGImage:cgImg];
    
#warning 注意释放资源
    // 2.3.4 释放资源
    CGImageRelease(cgImg);
    
    return clipImg;

}

#pragma mark - 布局子控件
- (void)layoutSubviews {

    [super layoutSubviews];
    
    // 设置按钮的尺寸和位置
    // 1.按钮的宽高
    CGFloat width = 68;
    CGFloat height = 143;
    
    
    // 2.设置所有按钮的尺寸位置
    // 计算单位旋转角度
    CGFloat angle = M_PI * 2 / 12;
    [self.rotateWheel.subviews enumerateObjectsUsingBlock:^(__kindof HMLuckyButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2.1 设置按钮尺寸
        obj.bounds = CGRectMake(0, 0, width, height);
        
        // 2.2 设置按钮位置
        obj.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        // 2.3 让按钮偏移
        obj.layer.anchorPoint = CGPointMake(0.5, 1);
        
        // 2.4 让按钮旋转
        obj.transform = CGAffineTransformMakeRotation(idx * angle);
    }];



}






















@end
