//
//  HJCarouselmgaesTool.m
//  ScrollImages111
//
//  Created by 面壁者 on 2019/5/15.
//  Copyright © 2019 ShanghaiZhongzhiElectronicCommerce. All rights reserved.
//

#import "HJCarouselmgaesTool.h"

@interface HJCarouselmgaesTool()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *mainPageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *imageViewPageControl;

@property (nonatomic, assign) CGFloat widthOfView;
@property (nonatomic, assign) CGFloat heightView;
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@property (nonatomic, assign) NSInteger currentPage;
//滚动模式
@property (nonatomic, assign) HJScrollMode scrollMode;//当手动拖动达到分页时,可以根据拖动方向改变定时滚动方向
@property (nonatomic, assign, getter=isToLeft) BOOL toLeft;//是否向左滚动;


@end

@implementation HJCarouselmgaesTool
+ (instancetype)carouselmgaesToolWithFrame:(CGRect)frame withScrollMode:(HJScrollMode)scrollMode {
    return [[self alloc]initWithFrame:frame withScrollMode:scrollMode];
}

- (instancetype)initWithFrame:(CGRect)frame withScrollMode:(HJScrollMode)scrollMode {
    if(self = [super initWithFrame:frame]){
        //获取滚动视图的宽度
        _widthOfView = frame.size.width;
        //获取滚动视图的高度
        _heightView = frame.size.height;
        //默认定时间隔
        _timerInterval = 3;
        //默认动画时长
        _animationInterval = 0.6;
        //设置默认滚动模式
        _scrollMode = AutomaticMode;
        //当前显示页面
        _currentPage = 0;
        _scrollMode = scrollMode;
        if(scrollMode == RightScrollMode){
            _toLeft = NO;
        }else{
            _toLeft = YES;
        }
        [self setUp];
    }
    return self;
}
//添加视图
- (void)setUp {
    [self addSubview:self.mainScrollView];
    [self addSubview:self.imageViewPageControl];
}
//MARK:懒加载
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
        _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        [self addSubview:_mainScrollView];
        _imageViewsArray = [NSMutableArray arrayWithCapacity:3];
        for ( int i = 0; i < 3; i ++) {
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView)];
            //防止图片显示变形,多余部分切除
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = YES;
            [_mainScrollView addSubview:tempImageView];
            [_imageViewsArray addObject:tempImageView];
            tempImageView.userInteractionEnabled = YES;
            //这里也可以直接给中间的图片添加手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
            [tempImageView addGestureRecognizer:tap];
        }
    }
    return _mainScrollView;
}
- (UIPageControl *)imageViewPageControl {
    if (!_imageViewPageControl) {
        _imageViewPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
        //当前显示颜色
        _imageViewPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        //默认颜色
        _imageViewPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _imageViewPageControl;
}
- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor{
    _pageIndicatorColor = pageIndicatorColor;
    self.imageViewPageControl.pageIndicatorTintColor = pageIndicatorColor;
}
- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor{
    _currentPageIndicatorColor = currentPageIndicatorColor;
    self.imageViewPageControl.currentPageIndicatorTintColor = currentPageIndicatorColor;
}

//添加图片
- (void)setImagesNameArray:(NSArray *)imagesNameArray{
    _imagesNameArray = imagesNameArray;
    if (imagesNameArray.count >= 2) {
        _currentPage = 0;
        self.imageViewPageControl.numberOfPages = _imagesNameArray.count;
        self.imageViewPageControl.currentPage = _currentPage;
        self.mainScrollView.contentSize = CGSizeMake(_widthOfView * 3, _heightView);
        UIImageView *mainImageView = _imageViewsArray[1];
        [mainImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        self.mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
        if (!_timer) {//大于等于2张图片时才轮播,否则没有意义
            __weak typeof(self)weakSelf = self;
            _timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf changeOffset];
            }];
        }
    } else {
        if(_timer){
            [_timer invalidate];
            _timer = nil;
        }
        _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
        if(imagesNameArray.count){
            UIImageView *mainImageView = _imageViewsArray[0];
            [mainImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        }
    }
}

#pragma mark UIScrollViewDelegate

//手将要拽动的时候
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //由于此时还不知道是王左拖还是往右拖动,所以就把三个视图都设置上对应的图片
    UIImageView *leftImageView = _imageViewsArray[0] ;
    NSInteger leftIndex = _currentPage - 1;
    if (leftIndex < 0) {
        leftIndex = _imagesNameArray.count - 1;
    }
    [leftImageView setImage:[UIImage imageNamed:_imagesNameArray[leftIndex]]];
    
    UIImageView *rightImageView = _imageViewsArray[2] ;
    NSInteger rightIndex = _currentPage + 1;
    if (rightIndex >= _imagesNameArray.count) {
        rightIndex = 0;
    }
    [rightImageView setImage:[UIImage imageNamed:_imagesNameArray[rightIndex]]];
}

// 触摸屏幕并拖拽画面，再松开时调用
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//        NSLog(@"scrollViewDidEndDragging-End of Scrolling.");
//}

//手完成拽动,并停止滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%lf",scrollView.contentOffset.x);
     //往右边滑动,并且分页了
    if (scrollView.contentOffset.x == 0) {
        _currentPage--;
        if (_currentPage < 0) {
            _currentPage = _imagesNameArray.count-1;
        }
        //修改滚动方向
        if (self.scrollMode == AutomaticMode){
            self.toLeft = NO;
        }
    }
    //往左边滑动,并且分页了
    if (scrollView.contentOffset.x == _widthOfView * 2) {
        _currentPage++;
        if(_currentPage >= _imagesNameArray.count)
            _currentPage = 0;
        if (self.scrollMode == AutomaticMode){
            self.toLeft = YES;
        }
    }
    UIImageView *mainImagev = _imageViewsArray[1];
    [mainImagev setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
    self.mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    _imageViewPageControl.currentPage = _currentPage;
    [self resumeTimer];
    
}

#pragma mark : 事件处理
//点击图片事件
- (void)imageClick {
    if (self.getClickIndexBlock) {
        self.getClickIndexBlock(_currentPage);
    }
}
//定时器事件
- (void)changeOffset {
    switch (self.scrollMode) {
        case LeftScrollMode: {
            [self scrollToLeft];
        }
            break;
        case RightScrollMode:
            [self scrollToRight];
            break;
            
        default:
            [self scrollWithAutomaticMode];
            break;
    }
    
}
- (void)scrollWithAutomaticMode{
    //获取ScrollView的offset.x
    if(self.isToLeft){
        [self scrollToLeft];
    }else{
        [self scrollToRight];
    }
}
//往左滚
- (void)scrollToLeft {
    _currentPage ++;
    //如果是最后一个图片，让其成为第一个
    if (_currentPage >= _imagesNameArray.count) {
        _currentPage = 0;
    }
    //给右边的视图设置下一张图片
    UIImageView *rightImageView = _imageViewsArray[2] ;
    [rightImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
    //滑动的过程中是设置到右边的视图上,滑动完成够设置到第一个视图上,造成一个无限滑动的假象
    [UIView animateWithDuration:_animationInterval animations:^{
          _mainScrollView.contentOffset = CGPointMake(_widthOfView*2, 0);
    } completion:^(BOOL finished) {
        //位移动画完成时,迅速的将图片设置到中间视图,并修改偏移量显示中间视图
        UIImageView * mainImageView = _imageViewsArray[1];
        [mainImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    }];
     _imageViewPageControl.currentPage = _currentPage;
}
//往右滚
- (void)scrollToRight {
    _currentPage --;
    if (_currentPage < 0) {
        _currentPage = _imagesNameArray.count-1;
    }
    UIImageView *leftImageView = _imageViewsArray[0] ;
    [leftImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
    [UIView animateWithDuration:_animationInterval animations:^{
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        //位移动画完成时,迅速的将图片设置到中间视图,并修改偏移量显示中间视图
        UIImageView * mainImageView = _imageViewsArray[1];
        [mainImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    }];
     _imageViewPageControl.currentPage = _currentPage;
}
#pragma 暂停定时器
-(void)resumeTimer{
    //如定时器已经失效,就返回
    if (![_timer isValid]) {
        _timer = nil;
        return ;
    }
    //暂停一个定时器时间
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow: self.timerInterval]];
}

@end
