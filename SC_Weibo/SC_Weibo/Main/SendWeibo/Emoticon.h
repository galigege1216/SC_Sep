//
//  Emoticon.h
//  SC_Weibo
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoticon : NSObject

@property(nonatomic,copy)NSString *cht; //繁体
@property(nonatomic,copy)NSString *chs; //简体
@property(nonatomic,copy)NSString *png;
@property(nonatomic,copy)NSString *gif;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,strong,readonly)UIImage *emoticonImage; //表情所对应的图片

@end
