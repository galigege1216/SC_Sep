//
//  MessageViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
- (IBAction)catAction:(UIButton *)sender {
    
    [ThemeManager shareManager].currentThemeName =@"cat";
    
}
- (IBAction)blueMoonAction:(UIButton *)sender {
    
    [ThemeManager shareManager].currentThemeName =@"bluemoon";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
