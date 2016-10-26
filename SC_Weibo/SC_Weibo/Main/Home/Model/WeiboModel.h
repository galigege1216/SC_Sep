//
//  WeiboModel.h
//  SC_Weibo
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface WeiboModel : NSObject


//微博来源
@property(copy,nonatomic) NSString *source;
//发布时间
@property(copy,nonatomic) NSString *created_at;
//微博编号
@property(copy,nonatomic) NSString *idstr;
//微博文本
@property(copy,nonatomic) NSString *text;
//转发数
@property(assign,nonatomic) NSInteger reposts_count;
//评论数
@property(assign,nonatomic) NSInteger comments_count;
//点赞数
@property(assign,nonatomic) NSInteger attitudes_count;
//发微博的用户
@property(strong,nonatomic) UserModel *user;
//被转发的微博
@property(strong,nonatomic) WeiboModel *retweeted_status;
//缩略图片地址
@property(copy,nonatomic) NSURL *thumbnail_pic;
//中等尺寸图片地址
@property(copy,nonatomic) NSURL *bmiddle_pic;
//原始图片地址
@property(copy,nonatomic) NSURL *original_pic;
//多图地址
@property(copy,nonatomic) NSArray *pic_urls;
//位置信息
@property(copy,nonatomic)NSDictionary *geo;


//-(instancetype)initWithDic:(NSDictionary *)dic;




@end
