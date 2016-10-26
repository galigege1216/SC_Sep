//
//  MainTabBarController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "MainTabBarController.h"


@interface MainTabBarController ()
{
    ThemeImageView *_selectedView;
}

@end

@implementation MainTabBarController


-(instancetype)init{
    self =[super init];
    if (self) {
        [self createSubVC];
        [self customTabBar];
    }
    return self;
}

-(void)createSubVC{
    
    NSArray *names =@[@"Home",@"Message",@"Discover",@"Profile",@"More"];
    NSMutableArray *viewControllers =[NSMutableArray array];
    for (NSString *name in names) {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        UINavigationController *navi =[storyboard instantiateInitialViewController];
        [viewControllers addObject:navi];
    }
    self.viewControllers =viewControllers;
    
}

-(void)customTabBar{
    //设置标签栏背景
    ThemeImageView *bgImageView =[[ThemeImageView alloc]initWithFrame:CGRectMake(0, -5, kScreenWidth, 54)];
    bgImageView.imageName =@"mask_navbar.png";
    [self.tabBar insertSubview:bgImageView atIndex:0];
    
    Class subClass =NSClassFromString(@"UITabBarButton");
    for (UIView *subView in self.tabBar.subviews) {
//        NSLog(@"%@",subView);
        if ([subView isKindOfClass:subClass]) {
            [subView removeFromSuperview];
        }
    }

    CGFloat buttonW =kScreenWidth/5.0;
    if (_selectedView ==nil) {
        _selectedView =[[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, buttonW, 49)];
        _selectedView.imageName =@"home_bottom_tab_arrow";
        [self.tabBar addSubview:_selectedView];
    }
    
    for (int i =0; i<5; i++) {
        ThemeButton *btn =[ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(i*buttonW, 0, buttonW, 49);
        
        NSString *str =[NSString stringWithFormat:@"home_tab_icon_%i",i+1];
        btn.imageName =str;
        
        btn.tag =i+100;
        if (i==0) {
            _selectedView.center =btn.center;
        }
        [btn addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
    }
    
    self.tabBar.shadowImage =[[UIImage alloc]init];
}

-(void)tabBarButtonAction:(UIButton *)btn{
    self.selectedIndex =btn.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        _selectedView.center =btn.center;
    }];
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
