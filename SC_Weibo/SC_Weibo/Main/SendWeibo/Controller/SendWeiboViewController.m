//
//  SendWeiboViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/15.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MMDrawerController.h"
#import "LocationViewController.h"
#import "SinaWeibo+SendWeibo.h"
#import "EmoticonInputView.h"


#define kToolViewHeight 40
#define kSendWeiboAPI @"statuses/update.json"
#define kSendWeiboWithImageAPI @"statuses/upload.josn"
#define kLocationViewHeight 20

@interface SendWeiboViewController ()<SinaWeiboRequestDelegate>
{
    UITextView *_inputView;
    UIView *_toolView;
    
    //定位相关视图
    UIView *_locationView;
    UIImageView *_locationIconImageView;
    ThemeLabel *_locationTitleLabel;
    ThemeButton *_locationCancelButton;
    EmoticonInputView *_emoticonView;
}

@property(strong,nonatomic)NSDictionary *locationData;

@end

@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createInputView];
    [self createToolView];
    [self createLocationViews];
    //监听表情输入的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveEmoticonNotification:) name:kEmoticonViewTouchNotificationName object:nil];
    
}
//导航栏
-(void)createNavigationBar{
    
    //titlebar_button_9
    //取消发送
    ThemeButton *leftButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.backgroudImageName = @"titlebar_button_9";
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //发送
    ThemeButton *rightButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth - 60, 0, 60, 44);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.backgroudImageName = @"titlebar_button_9";
    [rightButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

//输入框
-(void)createInputView{
    
    _inputView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    _inputView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_inputView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    
}
//定位视图
-(void)createLocationViews{
    
    //父视图
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kLocationViewHeight)];
//    _locationView.backgroundColor = [UIColor orangeColor];
    _locationView.bottom = _toolView.top;
    [self.view addSubview:_locationView];
    //icon
    _locationIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight)];
//    _locationIconImageView.backgroundColor = [UIColor blueColor];
    [_locationView addSubview:_locationIconImageView];
    
    //label
    _locationTitleLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(kLocationViewHeight, 0, 200, kLocationViewHeight)];
    _locationTitleLabel.colorName = kHomeWeiboTextColor;
    _locationTitleLabel.text = @"杭州";
    [_locationView addSubview:_locationTitleLabel];
    
    //button
    _locationCancelButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    _locationCancelButton.frame = CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight);
    _locationCancelButton.left = _locationTitleLabel.right;
    _locationCancelButton.backgroudImageName = @"compose_toolbar_clear";
    [_locationView addSubview:_locationCancelButton];
    [_locationCancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    //默认隐藏
    _locationView.hidden = YES;
    
}
//取消定位操作
-(void)cancelAction:(UIButton *)button{
    self.locationData = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)createToolView{
    
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _inputView.bottom;
    _toolView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_toolView];
    ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth/5, kToolViewHeight);
    button.imageName =@"compose_toolbar_1.png";
    [_toolView addSubview:button];
    for (int i = 2; i < 6; i++) {
        
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i - 1) * kScreenWidth/5, 0, kScreenWidth/5, kToolViewHeight);
        button.imageName = [NSString stringWithFormat:@"compose_toolbar_%i.png",i+1];
        [_toolView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

//定位按钮点击事件
-(void)toolBarButtonAction:(UIButton *)button{
    if (button.tag == 4) {
        //打开定位界面
        LocationViewController *locationVC = [[LocationViewController alloc]init];
        //设置获取地理位置的block
        [locationVC addLocationResultBlock:^(NSDictionary *result) {
            //保留位置数据
            self.locationData = result;
        }];
        [self.navigationController pushViewController:locationVC animated:YES];
    }else if (button.tag == 5){
        //表情视图
        //懒加载
        if (_emoticonView == nil) {
            _emoticonView = [[EmoticonInputView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
        //获取输入框 将输入视图设置为表情视图，键盘切换
        if (_inputView.inputView) {
            _inputView.inputView = nil;
        }else{
            _inputView.inputView = _emoticonView;
        }
        //重新加载输入视图
        [_inputView reloadInputViews];
        //弹出键盘
        [_inputView becomeFirstResponder];
    }
}

#pragma mark - 键盘frame的改变

-(void)keyboardFrameChanged:(NSNotification *)noti{
    
//    NSLog(@"%@",noti.userInfo);
    NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frame = [value CGRectValue];
    _inputView.height = kScreenHeight - kToolViewHeight - 64 - frame.size.height;
    _toolView.top = _inputView.bottom;
    _locationView.bottom = _toolView.top;
}

-(void)keyboardHide:(NSNotification *)noti{
    
    _inputView.height = kScreenHeight - 64 - kToolViewHeight;
    _toolView.top = _inputView.bottom;
    _locationView.bottom = _toolView.top;
}

-(void)backAction{
    
    [_inputView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送微博
-(void)sendAction{
    //除去文本中的空白字符
    NSString *text = [_inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断输入框中是否有文字
    if (text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"没有输入微博正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view.window];
    //设置背景颜色 变暗效果
    hud.dimBackground = YES;
    //设置显示的文本
    hud.labelText = @"正在发送";
    //添加HUD到window中
    [self.view.window addSubview:hud];
    //显示HUD
    [hud show:YES];
    
    SinaWeibo *weibo = KSinaWeiboObject;
    NSMutableDictionary *params = [@{@"status" : text} mutableCopy];
    //如果有位置信息
    if (self.locationData) {
        NSString *lon = self.locationData[@"lon"];
        NSString *lat = self.locationData[@"lat"];
        [params setObject:lon forKey:@"long"];
        [params setObject:lat forKey:@"lat"];
    }
    
    [weibo sendWeiboWith:text image:nil params:params success:^(id result) {
        NSLog(@"发送成功");
        //收起键盘
        [_inputView resignFirstResponder];
        //返回前一页面
        [self dismissViewControllerAnimated:YES completion:^{
            //刷新微博
            UIApplication *app = [UIApplication sharedApplication];
            AppDelegate *deleget = (AppDelegate *)app.delegate;
            MMDrawerController *mmd = (MMDrawerController *)deleget.window.rootViewController;
            UITabBarController *tabCtrl = (UITabBarController *)mmd.centerViewController;
            UINavigationController *navi = (UINavigationController *)[tabCtrl.viewControllers firstObject];
            HomeViewController *homeVC = (HomeViewController *)navi.topViewController;
            
            [homeVC reloadNewWeibo];
            
            hud.labelText = @"发送成功";
            [hud hide:YES afterDelay:2];
        }];
    } fail:^(NSError *error) {
        hud.labelText = @"发送失败";
        [hud hide:YES afterDelay:2];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发送失败" message:@"发送失败请重新发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
    }];
    
}
#pragma  mark - SinaWeiboRequestDelegate
//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    if (httpResponse.statusCode == 200) {
//        NSLog(@"发送成功");
//        //收起键盘
//        [_inputView resignFirstResponder];
//        //返回前一页面
//        [self dismissViewControllerAnimated:YES completion:^{
//            //刷新微博
//            UIApplication *app = [UIApplication sharedApplication];
//            AppDelegate *deleget = (AppDelegate *)app.delegate;
//            MMDrawerController *mmd = (MMDrawerController *)deleget.window.rootViewController;
//            UITabBarController *tabCtrl = (UITabBarController *)mmd.centerViewController;
//            UINavigationController *navi = (UINavigationController *)[tabCtrl.viewControllers firstObject];
//            HomeViewController *homeVC = (HomeViewController *)navi.topViewController;
//            
//            [homeVC reloadNewWeibo];
//        }];
//    }
//    
//}

#pragma mark - 填充位置信息
-(void)setLocationData:(NSDictionary *)locationData{
    if (_locationData != locationData) {
        _locationData = [locationData copy];
        if (_locationData == nil) {
            _locationView.hidden = YES;
        }else{
            _locationView.hidden = NO;
            _locationTitleLabel.text = _locationData[@"title"];
            [_locationIconImageView sd_setImageWithURL:[NSURL URLWithString:_locationData[@"icon"]]];
            
           //改变label的宽度
            NSDictionary *attributes = @{NSFontAttributeName : _locationTitleLabel.font};
            CGRect rect = [_locationTitleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 10 -kLocationViewHeight*2, kLocationViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGFloat width = rect.size.width;
            _locationTitleLabel.width = width;
            //顺便更新取消按钮的frame
            _locationCancelButton.left = _locationTitleLabel.right;
        }
    }
}

#pragma mark - 收到表情通知
-(void)receiveEmoticonNotification:(NSNotification *)noti{
    //获取UserInfo
    NSDictionary *userInfo = noti.userInfo;
    //获取表情名
    NSString *chs = userInfo[@"chs"];
    
    if (chs) {
        //将获取到的字符串 拼接到文本输入框中
        _inputView.text = [_inputView.text stringByAppendingString:chs];
        
    }
}

@end
