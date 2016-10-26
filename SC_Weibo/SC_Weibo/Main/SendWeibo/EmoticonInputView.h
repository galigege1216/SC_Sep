//
//  EmoticonInputView.h
//  SC_Weibo
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEmoticonWidth (kScreenWidth/8.0)   //单个表情宽度
#define kPageControllerHeight 20    //页码控制器高度
#define kEmoticonInputViewHeight ((kEmoticonWidth*4)+kPageControllerHeight) //表情框中高度
#define kEmoticonViewTouchNotificationName @"kEmoticonViewTouchNotificationName"

/*
 1.键盘切换
 2.表情数据读取
 3.显示表情
 4.点击表情输出文本
 */

@interface EmoticonInputView : UIView<UIScrollViewDelegate>

{
    NSArray *_emoticonsArray;
    UIScrollView *_scrollView;
    UIPageControl *_page;
}

@end
