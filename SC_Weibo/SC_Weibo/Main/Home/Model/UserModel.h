//
//  UserModel.h
//  SC_Weibo
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

//字符串性的用户UID
@property(copy,nonatomic) NSString *idstr;
//用户昵称
@property(copy,nonatomic) NSString *screen_name;
//好友显示名称
@property(copy,nonatomic) NSString *name;
//用户所在地
@property(copy,nonatomic) NSString *location;
//用户个人描述
@property(copy,nonatomic) NSString *des;
//用户博客地址
@property(copy,nonatomic) NSString *url;
//用户头像地址，50*50像素
@property(copy,nonatomic) NSURL *profile_image_url;
//用户大头像地址
@property(copy,nonatomic) NSURL *avatar_large;
//性别，m：男、f：女、n：未知
@property(copy,nonatomic) NSString *gender;
//粉丝数
@property(strong,nonatomic)NSNumber *followers_count;
//关注数
@property(strong,nonatomic)NSNumber *friends_count;
//微博数
@property(strong,nonatomic)NSNumber *statuses_count;
//收藏数
@property(strong,nonatomic)NSNumber *favourites_count;
//是否是微博认证用户，即加V用户，true：是，false：否
@property(strong,nonatomic)NSNumber *verified;


//-(instancetype)initWithDic:(NSDictionary *)dic;



@end
