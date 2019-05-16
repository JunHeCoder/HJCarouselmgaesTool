//
//  HJCarouselmgaesTool.h
//  ScrollImages111
//
//  Created by 面壁者 on 2019/5/15.
//  Copyright © 2019 ShanghaiZhongzhiElectronicCommerce. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, HJScrollMode) {
    AutomaticMode = 0,//默认模式,根据d手动拖动达到分页效果后既可以往左滚动,也可以往右滚动
    LeftScrollMode = -1, //往左滚动,不可以变
    RightScrollMode = 1, //往右滚动,不可变
};

@interface HJCarouselmgaesTool : UIView
//定时时长,需在设置imagesNameArray之前设置
@property (nonatomic, assign) NSTimeInterval timerInterval;
//滚动动画时长
@property (nonatomic, assign) NSTimeInterval animationInterval;
//设置UIPageControl颜色
//默认白色
@property (nonatomic, strong) UIColor * pageIndicatorColor;
//默认红色
@property (nonatomic, strong) UIColor * currentPageIndicatorColor;
//获取图片数组,必须设置
@property (nonatomic, copy) NSArray * imagesNameArray;
//点击图片事件
@property (nonatomic, copy) void(^getClickIndexBlock)(NSInteger index);


+ (instancetype)carouselmgaesToolWithFrame:(CGRect)frame withScrollMode:(HJScrollMode)scrollMode;
- (instancetype)initWithFrame:(CGRect)frame withScrollMode:(HJScrollMode)scrollMode;
@end

NS_ASSUME_NONNULL_END

