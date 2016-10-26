//
//  ThemeImageView.m
//  SC_Weibo
//
//  Created by 丸子妈 on 16/10/2.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        
        _leftCapWidth = 0;
        _topCapHeight = 0;
        //监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
        
    }
    return self;
}

-(void)awakeFromNib{
    
    _leftCapWidth = 0;
    _topCapHeight = 0;
    
    //监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
    
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)setImageName:(NSString *)imageName{
    _imageName =imageName;
    [self themeChange];
}

-(void)themeChange{
    //获取管理器
    ThemeManager *manager =[ThemeManager shareManager];
    //从管理器得到图片
    UIImage *image =[manager themeImageWithName:self.imageName];
    //拉伸图片
    self.image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
}

-(void)setLeftCapWidth:(CGFloat)leftCapWidth{
    
    _leftCapWidth = leftCapWidth;
    [self themeChange];
}

-(void)setTopCapHeight:(CGFloat)topCapHeight{
    
    _topCapHeight = topCapHeight;
    [self themeChange];
}


@end
