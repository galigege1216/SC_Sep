//
//  ThemeButton.m
//  SC_Weibo
//
//  Created by 丸子妈 on 16/10/2.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


-(void)themeChange{
    
    ThemeManager *manager =[ThemeManager shareManager];
    UIImage *image =[manager themeImageWithName:_imageName];
    UIImage *bgImage =[manager themeImageWithName:_backgroudImageName];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    
}

-(void)setImageName:(NSString *)imageName{
    
    _imageName =[imageName copy];
    [self themeChange];
    
}

-(void)setBackgroudImageName:(NSString *)backgroudImageName{

    _backgroudImageName =[backgroudImageName copy];
    [self themeChange];
    
}



@end
