//
//  ThemeImageView.h
//  SC_Weibo
//
//  Created by 丸子妈 on 16/10/2.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property(copy,nonatomic)NSString *imageName;

@property(assign,nonatomic)CGFloat leftCapWidth;
@property(assign,nonatomic)CGFloat topCapHeight;

@end
