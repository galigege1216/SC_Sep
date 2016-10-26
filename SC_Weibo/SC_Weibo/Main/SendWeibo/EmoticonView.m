//
//  EmoticonView.m
//  SC_Weibo
//
//  Created by Apple on 16/10/22.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonInputView.h"
#import "Emoticon.h"

#define kEmoticonWidth (kScreenWidth/8.0)   //单个表情宽度

@implementation EmoticonView

-(void)drawRect:(CGRect)rect{
    
    if (_emoticonArr.count ==0 || _emoticonArr.count >32) {
        return;
    }
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 8; j++) {
            //计算frame
            CGRect frame = CGRectMake(j * kEmoticonWidth, i *kEmoticonWidth, kEmoticonWidth, kEmoticonWidth);
            
            //获取图片
            //绘制完所有的表情，结束绘制
            NSInteger index = i * 8 + j;
            if ( index>=_emoticonArr.count) {
                return;
            }
            Emoticon *emoticon = _emoticonArr[index];
            UIImage *image = [UIImage imageNamed:emoticon.png];
            //绘制图片
            [image drawInRect:frame];
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取手指
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    //根据坐标值计算出点击的表情
    NSInteger i = location.y / kEmoticonWidth;
    NSInteger j = location.x / kEmoticonWidth;
    
    NSInteger index = i * 8 + j;
    if (index < _emoticonArr.count) {
        Emoticon *emoticon = _emoticonArr[index];
        //表情数据的回传，表情所对应字符串添加到textView
        //参数字典
        NSDictionary *userInfo = @{@"chs" : emoticon.chs};
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kEmoticonViewTouchNotificationName object:nil userInfo:userInfo];
        
        
    }
    
}

@end
