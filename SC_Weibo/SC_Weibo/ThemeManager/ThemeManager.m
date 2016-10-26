//
//  ThemeManager.m
//  SC_Weibo
//
//  Created by 丸子妈 on 16/10/1.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "ThemeManager.h"
#define KCurrentThemeNameKey @"KCurrentThemeNameKey"

@implementation ThemeManager

+(instancetype)shareManager{
    static ThemeManager *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager ==nil) {
            manager =[[super allocWithZone:nil]init];
        }
    });
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareManager];
}

-(instancetype)copy{
    return self;
}

-(instancetype)init{
    
    if (self =[super init]) {
        //初始化赋值
        //读取本地文件夹中的主题名
        _currentThemeName =[[NSUserDefaults standardUserDefaults]objectForKey:KCurrentThemeNameKey];
        //设置默认主题
        if (_currentThemeName ==nil) {
            _currentThemeName =@"猫爷";
        }
        
        NSString *filePath =[[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        _allThemes =[NSDictionary dictionaryWithContentsOfFile:filePath];
        
        [self loadColorConfigFile];
    }
    return self;
}

#pragma mark - 主题改变

-(void)setCurrentThemeName:(NSString *)currentThemeName{
    
    //没有对应的主题
    if (!_allThemes[currentThemeName]) {
        return;
    }
    //主题发生变化
    if (![_currentThemeName isEqualToString:currentThemeName]) {
        _currentThemeName =[currentThemeName copy];
        
        //切换主题，重新加载颜色文件
        [self loadColorConfigFile];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:KThemeChangeNotificationName object:nil];
        //存储主题名到本地文件
        [[NSUserDefaults standardUserDefaults]setObject:_currentThemeName forKey:KCurrentThemeNameKey];
    }
}

#pragma mark - 获取图片
-(UIImage *)themeImageWithName:(NSString *)imageName{
    
    NSString *imgName =[NSString stringWithFormat:@"%@/%@",_allThemes[_currentThemeName],imageName];
    UIImage *image =[UIImage imageNamed:imgName];
    return image;
}

#pragma mark - 字体颜色

//加载配置文件
-(void)loadColorConfigFile{
    
    //程序文件包的根路径
    NSString *bundlePath =[[NSBundle mainBundle]resourcePath];
    NSLog(@"%@",bundlePath);
    
    //根据根路径和主题名拼接目标文件路径
    NSString *filePath =[NSString stringWithFormat:@"%@/%@/config.plist",bundlePath,_allThemes[_currentThemeName]];
    
    //加载文件
    _colorConfigDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    
}

//获取某个特定的颜色
-(UIColor *)themeColorWithName:(NSString *)colorName{
    NSDictionary *colorDic = _colorConfigDic[colorName];
    if (colorDic == nil) {
        return [UIColor blackColor];
    }
    CGFloat red = [colorDic[@"R"] doubleValue];
    CGFloat green = [colorDic[@"G"] doubleValue];
    CGFloat blue = [colorDic[@"B"] doubleValue];
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}


@end
