//
//  MoreViewController.h
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : UITableViewController
@property (weak, nonatomic) IBOutlet ThemeImageView *icon1;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon2;

@property (weak, nonatomic) IBOutlet ThemeImageView *icon3;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon4;

@property (weak, nonatomic) IBOutlet ThemeLabel *themeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *label1;
@property (weak, nonatomic) IBOutlet ThemeLabel *label2;
@property (weak, nonatomic) IBOutlet ThemeLabel *label3;
@property (weak, nonatomic) IBOutlet ThemeLabel *label4;
@property (weak, nonatomic) IBOutlet ThemeLabel *cacheLabel;

@end
