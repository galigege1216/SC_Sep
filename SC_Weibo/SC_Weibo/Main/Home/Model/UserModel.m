//
//  UserModel.m
//  SC_Weibo
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             //model类中的属性作为key json字典中的key作为value
             @"des":@"description"
             };
}

@end
