//
//  LocationViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

#define kLocationNearbyAPI @"place/nearby/pois.json"

@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *_locationManager;
    NSArray *_locationArray;
    UITableView *_table;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"周边地点";
    [self createTable];
    [self startLocation];
}

-(void)startLocation{
    //创建位置管理器
    _locationManager = [[CLLocationManager alloc]init];
    //在iOS8之后，需要来设置定位的服务类型 始终/在程序运行时
    //NSLocationAlwaysUsageDescription
    //NSLocationWhenInUseUsageDescription
    //将需要使用的类型，添加到plist文件中，然后在后面字段中写上提示语
    if (KSystemVersion >=8.0) {
        //请求在程序使用期间的定位权限
        [_locationManager requestWhenInUseAuthorization];
    }
    //设置定位的精准度，精度越高耗电量越高
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

//在获取到最新的位置信息时调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    NSLog(@"%@",locations);
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    //经度
    double lon = location.coordinate.longitude;
    //纬度
    double lat = location.coordinate.latitude;
    NSLog(@"经度:%f纬度:%f",lon,lat);
    
    //获取当前位置的附近的地理信息
    //地理位置反编码，经纬度坐标信息-->实际的地点名称
    //新浪微博的地理接口
    //发送网络请求，获取附近的地点信息
    SinaWeibo *weibo = KSinaWeiboObject;
    NSDictionary *dic = @{@"long" : [NSString stringWithFormat:@"%f",lon],
                          @"lat" : [NSString stringWithFormat:@"%f",lat]};
    [weibo requestWithURL:kLocationNearbyAPI params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
    
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
//    NSLog(@"%@",result);
    _locationArray = result[@"pois"];
    [_table reloadData];
}

-(void)createTable{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _table.delegate =self;
    _table.dataSource =self;
    _table.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_table];
}

-(void)addLocationResultBlock:(LocationResultBlock)block{
    _block = [block copy];
}

#pragma mark - tableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回传被选中的地理信息
    if (_block) {
        _block(_locationArray[indexPath.row]);
    }
    //返回上一级界面
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    //地点
    NSDictionary *dic = _locationArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    //地址
    if (![dic[@"address"]isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = dic[@"address"];
    }else{
        cell.detailTextLabel.text = nil;
    }
    //图标
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
