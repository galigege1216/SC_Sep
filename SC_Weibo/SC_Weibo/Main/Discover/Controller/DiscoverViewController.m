//
//  DiscoverViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearbyUserViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController
- (IBAction)nearbyUser:(UIButton *)sender {
    
    NearbyUserViewController *nearbyVC = [[NearbyUserViewController alloc]init];
    nearbyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearbyVC animated:YES];
    
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
