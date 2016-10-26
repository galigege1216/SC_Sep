//
//  AppDelegate.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigationController.h"

@class MMDrawerController;
@class LeftViewController;
@class RightViewController;
@class BaseNavigationController;


#define KWeiboAuthDataKey @"KWeiboAuthDataKey"

@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //标签控制器
    MainTabBarController *tabBarCtrl =[[MainTabBarController alloc]init];
    
    
    //左边
    LeftViewController *leftVC =[[LeftViewController alloc]init];
    
    //右边
    RightViewController *rightVC =[[RightViewController alloc]init];
    
    //导航
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc]initWithRootViewController:leftVC];
    BaseNavigationController *rightNavi = [[BaseNavigationController alloc]initWithRootViewController:rightVC];
    
    //创建MMDrawer
    MMDrawerController *mmd =[[MMDrawerController alloc]initWithCenterViewController:tabBarCtrl leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    
    //设置侧滑宽度
    mmd.maximumLeftDrawerWidth = 180;
    mmd.maximumRightDrawerWidth = 80;
    //设置打开关闭方式
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [mmd setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        //动画要执行的内容
        //每一次需要执行的滑动动画时，到manager中获取相应的bolck
        MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
        //获取block
        MMDrawerControllerDrawerVisualStateBlock block1 = [manager drawerVisualStateBlockForDrawerSide:drawerSide];
        //执行block
        if (block1) {
            block1(drawerController,drawerSide,percentVisible);
        }
    }];
    
    
    self.window.rootViewController =mmd;
    
    
    //初始化微博SDK
    _sinaWeibo =[[SinaWeibo alloc]initWithAppKey:kAPPKey
                                       appSecret:kAPPSecret
                                  appRedirectURI:kAppRedirectURI
                                     andDelegate:self];
    
    BOOL isAuth =[self readAuthData];
    if (isAuth ==NO) {
        [self.sinaWeibo logIn];
        NSLog(@"没有登录信息，请登录微博");
    }else{
        NSLog(@"已登录微博:%@",self.sinaWeibo.accessToken);
    }
    
    return YES;
}

//登录成功
-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    NSLog(@"登录成功:%@",_sinaWeibo.accessToken);
    [self saveAuthData];
    
//    NSLog(@"%@",NSHomeDirectory());
}
//注销
-(void)logoutWeibo{
    [_sinaWeibo logOut];
}
//注销之后删除信息
-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"注销成功");
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KWeiboAuthDataKey];
    
}
//登录失败
-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"登录失败");
}
//登陆后保存
-(void)saveAuthData{
    NSString *token =_sinaWeibo.accessToken;
    NSString *uid =_sinaWeibo.userID;
    NSDate *date =_sinaWeibo.expirationDate;
    //数据持久化 使用属性列表
    NSUserDefaults *userDefau =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic =@{@"accessToken" : token,
                         @"userID" : uid,
                         @"expirationDate" :date
                         };
    [userDefau setObject:dic forKey:KWeiboAuthDataKey];
    
    [userDefau synchronize];
    
}

-(BOOL)readAuthData{
    NSUserDefaults *userdefau =[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic =[userdefau objectForKey:KWeiboAuthDataKey];
    if (dic ==nil) {
        return NO;
    }
    NSString *token =dic[@"accessToken"];
    NSString *uid =dic[@"userID"];
    NSDate *date =dic[@"expirationDate"];
    if (token ==nil ||uid ==nil||date == nil) {
        //之前登陆过，但是保存的登录数据有误
        //移除错误的登录数据，重新登录
        [userdefau removeObjectForKey:KWeiboAuthDataKey];
        return NO;
    }
    _sinaWeibo.accessToken =token;
    _sinaWeibo.userID =uid;
    _sinaWeibo.expirationDate =date;
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
