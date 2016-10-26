//
//  HomeViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "YYModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "WXRefresh.h"
#import <AVFoundation/AVFoundation.h>


//获取首页微博接口
#define kGetTimeLineWeiboAPI @"statuses/home_timeline.json"


@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_weiboArray;
    ThemeImageView *_newWeiboCountView;
    UILabel *_newWeiboCountLabel;
    SystemSoundID _msgcomeID;
}


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWeiboData];
    [self creatableView];
    [self reloadWeibo];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //注销系统声音
    AudioServicesRemoveSystemSoundCompletion(_msgcomeID);
}



#pragma mark - 加载微博数据
-(void)loadWeiboData{
    
    //发起网络请求
    //1.获取微博对象
    SinaWeibo *weibo = KSinaWeiboObject;
    //2.判断登录状态是否有效
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return;
    }
    
    //3.发起请求
    NSDictionary *params =@{@"count" : @"20"};
    SinaWeiboRequest *request = [weibo requestWithURL:kGetTimeLineWeiboAPI
                   params:[params mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    //添加标记 0：第一次加载请求，1：下拉加载最新微博请求，2：上拉加载更多请求
    request.tag = 0;
    //监听数据读取
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"网络加载完成");
//    NSLog(@"%@",result);
    
    NSArray *arr = result[@"statuses"];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        
        WeiboModel *weiboModel = [WeiboModel yy_modelWithJSON:dic];
        [mArr addObject:weiboModel];
        
        NSLog(@"%@:%@",weiboModel.user.name,weiboModel.text);
    }
    //判断请求的类型
    if (request.tag == 0) {
        _weiboArray = [mArr mutableCopy];
        
    }else if (request.tag == 1){
        if (mArr.count == 0) {
            [_table.pullToRefreshView stopAnimating];
            [self showNewWeiboCountView:0];
            return;
        }
        NSIndexSet *set1 = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, mArr.count)];
        [_weiboArray insertObjects:mArr atIndexes:set1];
        [_table.pullToRefreshView stopAnimating];
        //显示提示框
        [self showNewWeiboCountView:mArr.count];
    }
    
    
    [_table reloadData];
    
}

#pragma mark - 刷新微博

-(void)reloadWeibo{
    
    //ARC环境下的block循环引用的解决办法：block外创建__weak类型的指针解决循环引用 block内创建__strong类型的指针 防止weak指针指向的对象销毁指针变为空无法调用方法
    __weak HomeViewController *weakSelf = self;

    //下拉刷新最新
    [_table addPullDownRefreshBlock:^{
        
        __strong HomeViewController *strongSelf = weakSelf;
        [strongSelf loadNewData];
    }];
    //上拉刷新更多
    [_table addInfiniteScrollingWithActionHandler:^{
        
        __strong HomeViewController *strongSelf = weakSelf;
        [strongSelf loadMoreData];
    }];
    
    _newWeiboCountView = [[ThemeImageView alloc]initWithFrame:CGRectMake(3, 3, kScreenWidth -6, 40)];
    _newWeiboCountView.imageName = @"timeline_notify";
    _newWeiboCountView.transform =CGAffineTransformMakeTranslation(0, -60);
    [self.view addSubview:_newWeiboCountView];
    
    _newWeiboCountLabel = [[UILabel alloc]initWithFrame:_newWeiboCountView.bounds];
    _newWeiboCountLabel.textAlignment = NSTextAlignmentCenter;
    [_newWeiboCountView addSubview:_newWeiboCountLabel];
    //获取声音文件资源路径url
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"msgcome" withExtension:@"wav"];
    //注册系统声音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_msgcomeID);
    
}

//下拉加载最新微博数据
-(void)loadNewData{

    //发起网络请求
    //1.获取微博对象
    SinaWeibo *weibo = KSinaWeiboObject;
    //2.判断登录状态是否有效
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return;
    }
    WeiboModel *firstWeibo = [_weiboArray objectAtIndex:0];
    NSString *idstr = firstWeibo.idstr;
    //3.发起请求
    NSDictionary *params =@{@"count" : @"20",
                            @"since_id" : idstr
                            };
    SinaWeiboRequest *request = [weibo requestWithURL:kGetTimeLineWeiboAPI
                                               params:[params mutableCopy]
                                           httpMethod:@"GET"
                                             delegate:self];
    request.tag = 1;
    
}



-(void)loadMoreData{
    NSLog(@"上拉加载更多的微博");
    
    [_table.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    if (_weiboArray.count > 0) {
        SinaWeibo *weibo = KSinaWeiboObject;
        if (![weibo isAuthValid]) {
            [weibo logIn];
            return;
        }
        WeiboModel *lastModel = _weiboArray.lastObject;
        NSInteger maxID =[lastModel.idstr intValue];
        maxID--;
        NSDictionary *params = @{@"max_id " : [NSString stringWithFormat:@"%li",maxID]};
        SinaWeiboRequest *request = [weibo requestWithURL:kGetTimeLineWeiboAPI params:[params mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 2;
    }
    
}
//刷新微博操作
-(void)reloadNewWeibo{
    NSLog(@"刷新微博");
    //播放下拉刷新动画
    [_table.pullToRefreshView startAnimating];
    //调用下拉刷新方法
    [self loadNewData];
}

#pragma mark - 微博提示框

-(void)showNewWeiboCountView:(NSInteger)count{
    if (count == 0) {
        _newWeiboCountLabel.text = @"没有新微博";
    }else{
        _newWeiboCountLabel.text = [NSString stringWithFormat:@"%li条新微博",count];
    }
    [UIView animateWithDuration:0.5 animations:^{
        //显示提示框
        _newWeiboCountView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //播放提示音
        AudioServicesPlayAlertSound(_msgcomeID);
        //两秒后收回提示框
        [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _newWeiboCountView.transform = CGAffineTransformMakeTranslation(0, -60);
        } completion:nil];
    }];
    
}

#pragma mark - 表视图

-(void)creatableView{
    
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-49) style:UITableViewStylePlain];
    _table.delegate =self;
    _table.dataSource =self;
    
    [self.view addSubview:_table];
    //注册单元格
    UINib *nib =[UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    _table.backgroundColor = [UIColor clearColor];
}

#pragma  mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    
    //填充数据
    WeiboModel *model = _weiboArray[indexPath.row];
//    cell.textLabel.text =model.user.name;
//    cell.detailTextLabel.text =model.text;
    cell.weiboModel =model;
    
    return cell;
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //类方法创建布局
    WeiboModel *weibo = _weiboArray[indexPath.row];
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeibo:weibo];
    //返回单元格高度
    return [layout cellHeight];
}






@end
