//
//  SinaWeibo+SendWeibo.m
//  SC_Weibo
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "SinaWeibo+SendWeibo.h"
#import "AFNetworking.h"


@implementation SinaWeibo (SendWeibo)

-(void)sendWeiboWith:(NSString *)text image:(UIImage *)image params:(NSDictionary *)params success:(SendWeiboSuccessBlock)success fail:(SendWeiboFailBlock)fail{
    
    //https://api.weibo.com/2/statuses/update.json
    //https://upload.api.weibo.com/2/statuses/upload.json
    NSMutableDictionary *mDic = [params mutableCopy];
    [mDic setObject:self.accessToken forKey:@"access_token"];
    [mDic setObject:text forKey:@"status"];
    //带图片
    if (image) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:mDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //请求体
            //图片转data,拼接数据
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (fail) {
                fail(error);
            }
        }];
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (fail) {
                fail(error);
            }
        }];
    }
    
}

@end
