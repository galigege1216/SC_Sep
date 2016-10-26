//
//  SinaWeibo+SendWeibo.h
//  SC_Weibo
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "SinaWeibo.h"

typedef void(^SendWeiboSuccessBlock)(id result);
typedef void(^SendWeiboFailBlock)(NSError *error);

@interface SinaWeibo (SendWeibo)

-(void)sendWeiboWith:(NSString *)text
               image:(UIImage *)image
              params:(NSDictionary *)params
             success:(SendWeiboSuccessBlock)success
                fail:(SendWeiboFailBlock)fail;

@end
