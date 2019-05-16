//
//  ViewController.m
//  ScrollImages111
//
//  Created by 面壁者 on 2019/5/14.
//  Copyright © 2019 ShanghaiZhongzhiElectronicCommerce. All rights reserved.
//

#import "ViewController.h"
#import "HJCarouselmgaesTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self addZLImageScrollView];
    [self setUp];
    
}
- (void)setUp{
    HJCarouselmgaesTool * tool = [HJCarouselmgaesTool carouselmgaesToolWithFrame:CGRectMake(10, 60,  [[UIScreen mainScreen] bounds].size.width - 20, 200) withScrollMode:AutomaticMode];
    tool.imagesNameArray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    tool.getClickIndexBlock = ^(NSInteger index) {
        NSLog(@"点击的是滴%ld张图片",index+1);
    };
    [self.view addSubview:tool];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
