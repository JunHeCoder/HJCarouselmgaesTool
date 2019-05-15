# HJCarouselmgaesTool
* iOS无限轮播,有三种模式可以设定往左滚动,往右滚动,或者根据手动滑屏的方向随意改变其滚动的方向.并且不仅考虑到三张以上的图片轮播,也考虑了三张一下或者没有图片的情况.
* 导入`#import "HJCarouselmgaesTool.h"`轮播工具类即可
* 包括三种模式
  1. `AutomaticMode`是默认模式,可以根据拖拽方向分页后来自动向左滚动还是向右滚动,也就是可以人为改变滚动方向
  2. `LeftScrollMode`往左滚动,不可以人为改变滚动方向
  3. `RightScrollMode`往右滚动,不可变方向
* 如果想改变定时器时长`timerInterval`属性必须要在设置`imagesNameArray`属性之前设置,不设置默认是3秒.
* 为了更加灵活, `imagesNameArray`属性是专门用于设置图片的.
* 适用于0到N张图片.
