//
//  EmoticonInputView.m
//  SC_Weibo
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "EmoticonInputView.h"
#import "Emoticon.h"
#import "YYModel.h"
#import "EmoticonView.h"

@implementation EmoticonInputView

-(instancetype)initWithFrame:(CGRect)frame{
    //强制修改高度
    frame.size.height = kEmoticonInputViewHeight;
    //原点位置设置为0
    frame.origin = CGPointZero;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self loadData];
        [self createScrollView];
    }
    return self;
}
//读取表情数据
-(void)loadData{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Emoticon *emoticon = [Emoticon yy_modelWithJSON:dic];
        [mArr addObject:emoticon];
    }
    _emoticonsArray = [mArr copy];
}
//表情视图
-(void)createScrollView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kEmoticonInputViewHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    //总页数
    NSInteger pageNumber = (_emoticonsArray.count -1)/32 +1;
    for (int i = 0; i < pageNumber; i++) {
        //计算frame
        CGRect frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, kEmoticonInputViewHeight);
        //创建视图
        EmoticonView *view = [[EmoticonView alloc]initWithFrame:frame];
        [_scrollView addSubview:view];
        //设置需要显示的内容
        NSRange range = NSMakeRange(i * 32, 32);
        //最后一页
        if (i == pageNumber -1) {
            range.length = _emoticonsArray.count -32 * i;
        }
        NSArray *array = [_emoticonsArray subarrayWithRange:range];
        view.emoticonArr = array;
    }
    //分页控制器
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0,kEmoticonWidth *4 , kScreenWidth, kPageControllerHeight)];
    _page.numberOfPages = pageNumber;
    _page.backgroundColor = [UIColor grayColor];
    _page.currentPage = 0;
    _scrollView.delegate = self;
    [self addSubview:_page];
    
    _scrollView.contentSize = CGSizeMake(pageNumber * kScreenWidth, kEmoticonInputViewHeight);
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat offsetX = targetContentOffset->x;
    NSInteger pageNumber = offsetX / kScreenWidth;
    _page.currentPage = pageNumber;
}



@end
