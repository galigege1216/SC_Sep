 //
//  BaseNavigationController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/22.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听主题切换
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:KThemeChangeNotificationName object:nil];
    
//    if (KSystemVersion>=7.0){
//        
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Skins/cat/mask_titlebar64@2x"] forBarMetrics:UIBarMetricsDefault];
//    }else{
//        
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Skins/cat/mask_titlebar@2x"] forBarMetrics:UIBarMetricsDefault];
//    }
    
    NSDictionary *attributes =@{
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                };
    self.navigationBar.titleTextAttributes =attributes;
    
    self.navigationBar.translucent =NO;
    [self themeChanged];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)themeChanged{
    //设置导航栏背景
    NSString *imageName = KSystemVersion >=7 ? @"mask_titlebar64@2x" :@"mask_titlebar@2x";
    UIImage *image =[[ThemeManager shareManager]themeImageWithName:imageName];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
