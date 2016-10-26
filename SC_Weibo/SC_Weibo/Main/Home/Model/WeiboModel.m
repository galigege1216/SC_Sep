//
//  WeiboModel.m
//  SC_Weibo
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    //获取字符串
    NSString *weiboText = [self.text copy];
    
    //字符串内容替换
//    [兔子]  -> <image url = 001.png>
    //1.使用正则表达式，查找表情字符串
    NSString *regex = @"\\[\\w+\\]";
    NSArray *array = [weiboText componentsMatchedByRegex:regex];
    
    //2.到plist文件中，查找表情是否存在
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [[NSArray alloc]initWithContentsOfFile:filePath];
    //替换表情字符串
    for (NSString *str in array) {
        //使用谓词查找
        NSString *s = [NSString stringWithFormat:@"chs='%@'",str];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:s];
        //谓词过滤
        NSArray *result = [emoticons filteredArrayUsingPredicate:predicate];
        //过滤后的结果
        NSDictionary *emoticonsDic = [result firstObject];
        //3.如果表情存在，则获取表情文件名，按照格式替换
        if (emoticonsDic == nil) {
            //表情在列表中不存在就忽略
            continue;
        }
        NSString *imageName = emoticonsDic[@"png"];
        //替换后的字符串
        NSString *imageString = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
        //替换字符
        weiboText = [weiboText stringByReplacingOccurrencesOfString:str withString:imageString];
        NSLog(@"替换成功%@",str);
        
    }
    
    //重新设置text
    self.text =[weiboText copy];
    
    return YES;
}


@end
