//
//  WeiboAnnotation.m
//  SC_Weibo
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

-(void)setWeiboModel:(WeiboModel *)weiboModel{

    
    _weiboModel = weiboModel;
    //从微博对象中获取地理位置信息 填充到coordinate中
    NSDictionary *geo = _weiboModel.geo;
//    NSLog(@"%@",geo);
    //获取经纬度坐标点
    NSArray *coordinates = geo[@"coordinates"];
    if (coordinates.count == 2) {
        //纬度
        double lat = [coordinates.firstObject doubleValue];
        //经度
        double lon = [coordinates.lastObject doubleValue];
        
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
    
}

@end
