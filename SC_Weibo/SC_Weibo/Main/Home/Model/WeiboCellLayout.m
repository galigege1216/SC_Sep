//
//  WeiboCellLayout.m
//  SC_Weibo
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"

@interface WeiboCellLayout(){
    CGFloat _cellHeight;
}

@end

@implementation WeiboCellLayout

+(instancetype)layoutWithWeibo:(WeiboModel *)weibo{
    WeiboCellLayout *layout = [[WeiboCellLayout alloc]init];
    if (layout) {
        layout.weibo = weibo;
    }
    return layout;
}

-(void)setWeibo:(WeiboModel *)weibo{
    if (_weibo == weibo) {
        return;
    }
    
    _weibo = weibo;
    //初始化高度
    _cellHeight = 0;
    
    _cellHeight += cellTopViewHeight;
    
    _cellHeight += spaceWidth;
    //-------------------计算frame-----------------------
    //1.微博正文
//    NSDictionary *attributes = @{NSFontAttributeName : kWeiboTextFont};
//    CGSize textSize = CGSizeMake(KScreenWidth -2*spaceWidth, 10000);
//    CGRect rect = [_weibo.text boundingRectWithSize:textSize
//                                                 options:NSStringDrawingUsesLineFragmentOrigin
//                                              attributes:attributes
//                                                 context:nil];
//    CGFloat weiboTextHeight = rect.size.height;
//    CGFloat weiboTextHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:textSize.width text:_weibo.text];
    
    //设置正文高度
    //pointSize得到字体大小 font的属性
    CGFloat weiboTextHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:(kScreenWidth - 2*spaceWidth) text:_weibo.text linespace:lineSpace];
    weiboTextHeight += 3;
    
    _weiboTextFrame = CGRectMake(spaceWidth, _cellHeight, kScreenWidth - 2*spaceWidth, weiboTextHeight);
    
    _cellHeight += weiboTextHeight;
    _cellHeight += spaceWidth;
    
    
    
    
    //3.转发微博
    if (_weibo.retweeted_status) {
        //--------------转发微博正文-----------------
//        NSDictionary *attributes2 = @{NSFontAttributeName : kReWeiboTextFont};
//        CGSize textSize2 = CGSizeMake(KScreenWidth -4*spaceWidth, 10000);
//        CGRect rect2 = [_weibo.retweeted_status.text boundingRectWithSize:textSize2
//                                                options:NSStringDrawingUsesLineFragmentOrigin
//                                             attributes:attributes2
//                                                context:nil];
        
        CGFloat reWeiboTextHeight = [WXLabel getTextHeight:kReWeiboTextFont.pointSize width:(kScreenWidth - 4*spaceWidth) text:_weibo.retweeted_status.text linespace:lineSpace];
        reWeiboTextHeight += 3;
        
        _reWeiboTextFrame = CGRectMake(spaceWidth * 2, _cellHeight + spaceWidth, kScreenWidth - 4 * spaceWidth, reWeiboTextHeight);
        
        _cellHeight += reWeiboTextHeight;
        _cellHeight += spaceWidth * 2;
        
        //--------------转发微博背景图片-----------------
        CGFloat reWeiboBGImageY = CGRectGetMinY(_reWeiboTextFrame) - spaceWidth;
        CGFloat reWeiboBGImageH = _reWeiboTextFrame.size.height + spaceWidth * 2;
        
//        _reWeiboBGImageFrame = CGRectMake(spaceWidth, reWeiboBGImageY, KScreenWidth - spaceWidth * 2, reWeiboBGImageH);
        _cellHeight += spaceWidth;
        
        //--------------转发微博图片-------------------
//        if (_weibo.retweeted_status.bmiddle_pic) {
//            _weiboImageFrame = CGRectMake(2 *spaceWidth, CGRectGetMaxY(_reWeiboTextFrame)+spaceWidth, weiboImageHeight, weiboImageHeight);
//            _cellHeight += _weiboImageFrame.size.height;
//            _cellHeight += spaceWidth;
//            _reWeiboBGImageFrame.size.height = _weiboImageFrame.size.height +spaceWidth;
//        }else{
//            _weiboImageFrame = CGRectZero;
//            
//        }
        if (_weibo.retweeted_status.pic_urls.count > 0) {
            CGFloat imageHeight2 = [self layoutNineImageViewWithImageCount:_weibo.retweeted_status.pic_urls.count viewWidth:(kScreenWidth - 4*spaceWidth) top:CGRectGetMaxY(_reWeiboTextFrame) + spaceWidth];
            //转发微博背景
            reWeiboBGImageH += (imageHeight2 + spaceWidth);
            
            _cellHeight += imageHeight2;
            _cellHeight += spaceWidth;
        }
        _reWeiboBGImageFrame = CGRectMake(spaceWidth, reWeiboBGImageY, kScreenWidth - spaceWidth * 2, reWeiboBGImageH);
        
        }else{
        _reWeiboTextFrame = CGRectZero;
        _reWeiboBGImageFrame = CGRectZero;
            
        //判断正文是否有图
            if (_weibo.pic_urls.count > 0) {
                
                CGFloat imageHeight1 = [self layoutNineImageViewWithImageCount:_weibo.pic_urls.count viewWidth:(kScreenWidth - 2*spaceWidth) top:(CGRectGetMaxY(_weiboTextFrame)+spaceWidth)];
                
                _cellHeight += imageHeight1;
                _cellHeight += spaceWidth;
                
            }else{
                _imageFrameArray = nil;
            }
        
    }
    

    
}
//获取总高度
-(CGFloat)cellHeight{
    return _cellHeight;
}

#pragma mark - 九宫格布局

/*
 布局九个视图的frame
 @param imageCount 图片数量
 @param viewWidth 整个视图的宽度
 @param top 最顶部图片的y值
 @return 视图总高度
 */

-(CGFloat)layoutNineImageViewWithImageCount:(NSInteger) imageCount
                               viewWidth:(CGFloat) viewWidth
                                     top:(CGFloat) top{
    
    //判断图片数量是否合法
    if (imageCount > 9 || imageCount <= 0) {
        _imageFrameArray = nil;
        return 0;
    }
    
    //分情况讨论图片的布局条件（行列 图片宽度）
    
    //确定图片的总高度/每个图片的边长/列数
    CGFloat viewHeight;
    CGFloat imageWidth;
    NSInteger numberOfColumn; //列数
    
    if (imageCount == 1) {
        //一列
        numberOfColumn = 1;
        imageWidth = viewWidth;
        viewHeight = viewWidth;
        
        //两列
    }else if (imageCount == 2){
        //一行
        numberOfColumn = 2;
        imageWidth = (viewWidth - imageViewSpace)/2;
        viewHeight = imageWidth;
        
    }else if (imageCount == 4){
        //两行
        numberOfColumn = 2;
        imageWidth = (viewWidth - imageViewSpace)/2;
        viewHeight = viewWidth;
    
    }else{
        //三列
        numberOfColumn = 3;
        imageWidth = (viewWidth - 2*imageViewSpace)/3;
        
        if (imageCount == 3) {
            viewHeight = imageWidth;
        }else if (imageCount <= 6){
            viewHeight = imageWidth*2 + imageViewSpace;
        }else{
            viewHeight = viewWidth;
        }
        
    }
    
    //布局每个视图
    //创建可变数组接受frame
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    //循环创建frame
    for (int i = 0; i<9; i++) {
        
        //循环次数大于图片数量添加一个空的frame到数组
        if (i>= imageCount) {
            CGRect frame = CGRectZero;
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }else{
            //行列
            NSInteger row = i / numberOfColumn;
            NSInteger col = i % numberOfColumn;
            
            CGFloat subImageX = col * (imageWidth + imageViewSpace) + (kScreenWidth - viewWidth)/2;
            CGFloat subImageY = row * (imageWidth + imageViewSpace) + top;
            
            CGRect frame = CGRectMake(subImageX, subImageY, imageWidth, imageWidth);
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }
        
    }
    
    _imageFrameArray = [mArray copy];
    
    
    return viewHeight;
    
}




@end
