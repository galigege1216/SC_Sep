//
//  WeiboCellLayout.h
//  SC_Weibo
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define cellTopViewHeight 60
#define spaceWidth 10
#define weiboImageHeight 200
#define imageViewSpace 5
#define lineSpace 3

@interface WeiboCellLayout : NSObject

//-------------数据输入---------------------
@property(nonatomic,strong)WeiboModel *weibo;

+(instancetype)layoutWithWeibo:(WeiboModel *)weibo;

//---------------布局输出--------------------
//正文frame
@property(nonatomic,assign,readonly)CGRect weiboTextFrame;
//图片frame
//@property(nonatomic,assign,readonly)CGRect weiboImageFrame;
//转发微博正文frame
@property(nonatomic,assign,readonly)CGRect reWeiboTextFrame;
//转发微博背景图片frame
@property(nonatomic,assign,readonly)CGRect reWeiboBGImageFrame;

//九宫格图片frame
@property(nonatomic,strong,readonly)NSArray *imageFrameArray;

//总高度获取
-(CGFloat)cellHeight;

@end
