//
//  ThemeManager.h
//  SC_Weibo
//
//  Created by 丸子妈 on 16/10/1.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface ThemeManager : NSObject

@property(copy,nonatomic)NSString *currentThemeName;
@property(copy,nonatomic)NSDictionary *allThemes;
@property(copy,nonatomic)NSDictionary *colorConfigDic;

+(instancetype)shareManager;

-(UIImage *)themeImageWithName:(NSString *)imageName;

-(UIColor *)themeColorWithName:(NSString *)colorName;



@end
