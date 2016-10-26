//
//  RightViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "RightViewController.h"
#import "SendWeiboViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtons];
    //设置背景图片
    ThemeImageView *bgImageView =[[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"mask_bg.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    
    
    
}

-(void)createButtons{
    CGFloat buttonWidth = 50;
    CGFloat space = 15;
    for ( int i = 0; i <5; i++) {
        CGRect frame = CGRectMake(space, (space + buttonWidth)*i, buttonWidth, buttonWidth);
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        NSString *string = [NSString stringWithFormat:@"newbar_icon_%i.png",i+1];
        btn.imageName = string;
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    //底下两个按钮
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [mapBtn setImage:[UIImage imageNamed:@"btn_map_location"] forState:UIControlStateNormal];
    [self.view addSubview:mapBtn];
    
    UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qrBtn.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [qrBtn setImage:[UIImage imageNamed:@"qr_btn"] forState:UIControlStateNormal];
    [self.view addSubview:qrBtn];
    
    qrBtn.bottom = kScreenHeight -64 -space;
    mapBtn.bottom = qrBtn.top;
}

-(void)buttonAction:(UIButton *)btn{
    if (btn.tag == 0) {
        //发微博
        //创建界面
        SendWeiboViewController *sendWeiboVC = [[SendWeiboViewController alloc]init];
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:sendWeiboVC];
        
        [self presentViewController:navi animated:YES completion:^{
            //获取MMDrawerController
            MMDrawerController *mmd = self.mm_drawerController;
            //关闭侧边栏
            [mmd closeDrawerAnimated:YES completion:nil];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
