//
//  BaseViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片
    ThemeImageView *bgImageView =[[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"bg_detail.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    
    [self _createButton];
    
}

//创建导航栏返回按钮
-(void)_createButton{
    //判断导航控制器栈中是否有超过一个视图控制器
    if (self.navigationController.viewControllers.count>=2) {
        ThemeButton *backButton =[ThemeButton buttonWithType:UIButtonTypeCustom];
        backButton.frame =CGRectMake(0, 0, 60, 44);
        backButton.backgroudImageName =@"titlebar_button_back_9";
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem =leftItem;
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
