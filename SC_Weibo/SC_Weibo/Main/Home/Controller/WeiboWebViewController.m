//
//  WeiboWebViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboWebViewController.h"

@interface WeiboWebViewController ()

@end

@implementation WeiboWebViewController


-(instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64)];
    [self.view addSubview:webView];
    //创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
    //加载网络数据
    [webView loadRequest:request];
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
