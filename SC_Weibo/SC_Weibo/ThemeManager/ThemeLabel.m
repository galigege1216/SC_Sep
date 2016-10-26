//
//  ThemeLabel.m
//  SC_Weibo
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
    }
    return self;
}

-(void)awakeFromNib{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)themeChange{
    //设置字体颜色
    UIColor *color = [[ThemeManager shareManager]themeColorWithName:_colorName];
    
    self.textColor = color;
}

-(void)setColorName:(NSString *)colorName{
    _colorName = [colorName copy];
    
    [self themeChange];
}



@end
