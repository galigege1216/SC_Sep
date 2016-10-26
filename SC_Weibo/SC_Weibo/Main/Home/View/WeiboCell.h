//
//  WeiboCell.h
//  SC_Weibo
//
//  Created by Apple on 16/10/10.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "WXPhotoBrowser.h"

@interface WeiboCell : UITableViewCell<WXLabelDelegate,PhotoBrowerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *namelabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;

@property(strong,nonatomic) WXLabel *weiboTextLabel;
//@property(strong,nonatomic) UIImageView *weiboImageView;
@property(strong,nonatomic) WXLabel *reWeiboTextLabel;
@property(strong,nonatomic) ThemeImageView *reWeiboBGImageView;

@property(strong,nonatomic) NSArray *weiboImages;


@property(strong,nonatomic)WeiboModel *weiboModel;

@end
