//
//  MoreViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //图片名
    _icon1.imageName =@"more_icon_theme.png";
    _icon2.imageName =@"more_icon_account.png";
    _icon3.imageName =@"more_icon_draft.png";
    _icon4.imageName =@"more_icon_feedback.png";
    //字体颜色名
    _label1.colorName = kMoreItemTextColor;
    _label2.colorName = kMoreItemTextColor;
    _label3.colorName = kMoreItemTextColor;
    _label4.colorName = kMoreItemTextColor;
    _cacheLabel.colorName = kMoreItemTextColor;
    _themeLabel.colorName = kMoreItemTextColor;
    
}

-(void)viewWillAppear:(BOOL)animated{
    ThemeManager *manager =[ThemeManager shareManager];
    _themeLabel.text =manager.currentThemeName;
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
