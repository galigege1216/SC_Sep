//
//  WeiboCell.m
//  SC_Weibo
//
//  Created by Apple on 16/10/10.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboCell.h"
#import "GDataXMLNode.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
#import "RegexKitLite.h"
#import "WeiboWebViewController.h"

@implementation WeiboCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    _userImageView.layer.borderWidth = 0.5;
    _userImageView.layer.masksToBounds = YES;
    
    //文本颜色
    _namelabel.colorName = kHomeUserNameTextColor;
    _timeLabel.colorName = kHomeTimeLabelTextColor;
    _sourceLabel.colorName = kHomeTimeLabelTextColor;
    //监听通知 改变微博字体颜色
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
    [self themeChange];
}

-(void)themeChange{
    
    self.weiboTextLabel.textColor = [[ThemeManager shareManager]themeColorWithName:kHomeWeiboTextColor];
    self.reWeiboTextLabel.textColor = [[ThemeManager shareManager]themeColorWithName:kHomeReWeiboTextColor];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel =weiboModel;
    [_userImageView sd_setImageWithURL:_weiboModel.user.profile_image_url];
    _namelabel.text = _weiboModel.user.name;
    _timeLabel.text = _weiboModel.created_at;
    
    //微博来源
//    <a href="http://weibo.com" rel="nofollow">新浪微博</a>
    //使用XML
//    if (_weiboModel.source.length != 0) {
//        _sourceLabel.hidden =NO;
//        
//        GDataXMLElement *element = [[GDataXMLElement alloc]initWithXMLString:_weiboModel.source error:nil];
//        NSString *source = element.stringValue;
//        _sourceLabel.text =[NSString stringWithFormat:@"来源:%@",source];
//        
//    }else{
//        _sourceLabel.hidden = YES;
//    }
    //拼接
    if (_weiboModel.source.length != 0) {
        //三个元素，字符串
        NSArray *arr1 = [_weiboModel.source componentsSeparatedByString:@">"];
        NSString *subStr =arr1[1];
        //两个元素，字符串
        NSArray *arr2 = [subStr componentsSeparatedByString:@"<"];
        NSString *source = arr2[0];
        _sourceLabel.text = [NSString stringWithFormat:@"来源:%@",source];
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    
    [self createTime];
    [self loadText];
    //-----------------------微博图片----------------------------

    //布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeibo:_weiboModel];
    //微博正文布局
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    self.weiboTextLabel.text = _weiboModel.text;
    
    //微博图片布局
    //转发微博图片布局
    if (_weiboModel.retweeted_status.bmiddle_pic) {
    
//        for (UIImageView *imageView in _weiboImages) {
//            imageView.frame = CGRectZero;
//        }
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = self.weiboImages[i];
            
            NSValue *val = layout.imageFrameArray[i];
            imageView.frame = [val CGRectValue];
            if (i < _weiboModel.retweeted_status.pic_urls.count) {
                NSURL *url = [NSURL URLWithString:_weiboModel.retweeted_status.pic_urls[i][@"thumbnail_pic"]];
                [imageView sd_setImageWithURL:url];
                
            }
        }
        //微博图片
    }else if (_weiboModel.bmiddle_pic){
        
        for (int i = 0; i<9; i++) {
            //取出imageView
            UIImageView *imgView = self.weiboImages[i];
            //设置frame
            NSValue *val = layout.imageFrameArray[i];
            imgView.frame = [val CGRectValue];
            
            if (i < _weiboModel.pic_urls.count) {
                //设置内容
                NSURL *url = [NSURL URLWithString:_weiboModel.pic_urls[i][@"thumbnail_pic"]];
                [imgView sd_setImageWithURL:url];
            }
            
        }
        //没有图片
    }else{
        for (UIImageView *imageView in _weiboImages) {
            imageView.frame = CGRectZero;
        }
    }
    
    //转发微博正文
    self.reWeiboTextLabel.frame =layout.reWeiboTextFrame;
    self.reWeiboTextLabel.text = _weiboModel.retweeted_status.text;
    
    //转发微博背景图片
    self.reWeiboBGImageView.frame = layout.reWeiboBGImageFrame;
    
}

#pragma mark - 时间
-(void)createTime{
    //"Tue May 31 17:46:55 +0800 2011"
    //格式化字符串
    NSString *formatterStr = @"E M d HH:mm:ss Z yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置时间格式
    [formatter setDateFormat:formatterStr];
    //设置语言、地区
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [formatter dateFromString:_weiboModel.created_at];
    //计算各种时间单位
    NSTimeInterval second = -[date timeIntervalSinceNow];
    NSTimeInterval minute = second /60;
    NSTimeInterval hour = second/60;
    NSTimeInterval day = hour/24;
    
    NSString *timerString = nil;
    if (second < 60) {
        timerString = @"刚刚";
    }else if (minute < 60){
        timerString = [NSString stringWithFormat:@"%li分钟之前",(NSInteger)minute];
    }else if (hour < 60){
        timerString = [NSString stringWithFormat:@"%li小时之前",(NSInteger)hour];
    }else if (day < 7){
        timerString = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
    }else{
        //发送时间格式
        [formatter setDateFormat:@"M月d日 HH:mm"];
        [formatter setLocale:[NSLocale currentLocale]];
        timerString = [formatter stringFromDate:date];
    }
    
    _timeLabel.text = timerString;
}

#pragma mark - 微博正文
-(void)loadText{
//    //调用getter
//    self.weiboTextLabel.text = _weiboModel.text;
//    //文本自适应
//    NSDictionary *attributes = @{NSFontAttributeName : kWeiboTextFont};
//    CGSize textSize = CGSizeMake(KScreenWidth -20, 10000);
//    CGRect rect = [_weiboModel.text boundingRectWithSize:textSize
//                                                 options:NSStringDrawingUsesLineFragmentOrigin
//                                              attributes:attributes
//                                                 context:nil];
//    CGFloat height = rect.size.height;
//    //设置文本frame
//    _weiboTextLabel.frame = CGRectMake(10, 70, KScreenWidth-20, height);
}
//getter懒加载
#pragma  mark - 懒加载创建
//微博正文
-(WXLabel *)weiboTextLabel{
    if (_weiboTextLabel == nil) {
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _weiboTextLabel.font =kWeiboTextFont;
        _weiboTextLabel.numberOfLines = 0;
        
//        _weiboTextLabel.colorName = kHomeWeiboTextColor;
        _weiboTextLabel.wxLabelDelegate = self;
        _weiboTextLabel.linespace = lineSpace;
        
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}

//-(UIImageView *)weiboImageView{
//    if (_weiboImageView == nil) {
//        _weiboImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        
//        [self.contentView addSubview:_weiboImageView];
//    }
//    return _weiboImageView;
//}
//转发微博正文
-(WXLabel *)reWeiboTextLabel{
    if (_reWeiboTextLabel == nil) {
        _reWeiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _reWeiboTextLabel.font = kReWeiboTextFont;
//        _reWeiboTextLabel.colorName = kHomeReWeiboTextColor;
        _reWeiboTextLabel.wxLabelDelegate =self;
        _reWeiboTextLabel.numberOfLines = 0;
        _reWeiboTextLabel.linespace =lineSpace;
        
        [self.contentView addSubview:_reWeiboTextLabel];
    }
    return _reWeiboTextLabel;
}
//转发微博背景
-(ThemeImageView *)reWeiboBGImageView{
    if (_reWeiboBGImageView == nil) {
        _reWeiboBGImageView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        //timeline_rt_border图片名
        _reWeiboBGImageView.imageName =@"timeline_rt_border_selected_9";
        //设置拉伸点
        _reWeiboBGImageView.leftCapWidth = 27;
        _reWeiboBGImageView.topCapHeight = 20;
        
        [self.contentView insertSubview:_reWeiboBGImageView atIndex:0];
        
    }
    return _reWeiboBGImageView;
}
//微博图片
-(NSArray *)weiboImages{
    if (_weiboImages == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.backgroundColor = [UIColor greenColor];
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imgView addGestureRecognizer:tap];
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            
            [self.contentView addSubview:imgView];
            [mArray addObject:imgView];
            
        }
        _weiboImages = [mArray copy];
    }
    return _weiboImages;
}

#pragma mark - WXLabelDeleget

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}
//设置当前链接文本的颜色
//
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    
    //改变主题 返回到首页刷新界面调用绘制视图drawRect方法，因此链接颜色随着主题改变而变化
    return [[ThemeManager shareManager]themeColorWithName:kLinkTextColor];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}

-(void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSString *regex = @"http(s)?://([a-zA-Z0-9._-]+(/)?)+";
    if ([context isMatchedByRegex:regex]) {
        NSLog(@"%@",context);
        NSURL *url = [NSURL URLWithString:context];
        //创建浏览器界面
        WeiboWebViewController *webVC = [[WeiboWebViewController alloc]initWithURL:url];
        webVC.hidesBottomBarWhenPushed = YES;
        
        //使用响应者链查找导航控制器
        UIResponder *nextResponder =self.nextResponder;
        while (nextResponder) {
            //找到导航控制器 跳转界面跳出循环
            if ([nextResponder isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navi = (UINavigationController *)nextResponder;
                //跳转
                [navi pushViewController:webVC animated:YES];
                break;
            }
            nextResponder = nextResponder.nextResponder;
        }
        
    }
    
}

#pragma  mark - 图片点击操作
-(void)imageViewTapAction:(UITapGestureRecognizer *)tap{
    //获取被点击的图片
    UIImageView *imgView =(UIImageView *)tap.view;
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window
                   selectImageIndex:imgView.tag
                           delegate:self];
    
}

#pragma mark - PhotoBrowerDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    if (_weiboModel.retweeted_status.pic_urls.count > 0) {
        //转发微博的图片
        return _weiboModel.retweeted_status.pic_urls.count;
    }else{
        //微博的图片
        return _weiboModel.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    //
    WXPhoto *photo = [[WXPhoto alloc]init];
    NSString *imageUrlString = nil;
    if (_weiboModel.retweeted_status.pic_urls.count > 0) {
        //转发微博的图片
        NSDictionary *dic = _weiboModel.retweeted_status.pic_urls[index];
        imageUrlString = dic[@"thumbnail_pic"];
    }else{
        //微博的图片
        NSDictionary *dic = _weiboModel.pic_urls[index];
        imageUrlString = dic[@"thumbnail_pic"];
        
    }
    //缩略图地址
    //http://ww3.sinaimg.cn/thumbnail/bfc243a3gw1f6m40k407mg207c07ke82.gif
    //将缩略图地址 转化为大图地址
    imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    photo.url = [NSURL URLWithString:imageUrlString];
    //原ImageView 获取ImageView的Frame 来实现动画效果 以及ImageView中的缩略图
    photo.srcImageView = _weiboImages[index];
    
    
    return photo;
}

@end
