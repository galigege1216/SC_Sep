//
//  NearbyUserViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "NearbyUserViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "YYModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

#define kNearbyWeiboAPI @"place/nearby_timeline.json"

@interface NearbyUserViewController() <MKMapViewDelegate, SinaWeiboRequestDelegate>
{
    MKMapView *_mapView;
    BOOL _isLocation;
}
@end


@implementation NearbyUserViewController

//1.创建地图显示视图
//2.获取当前用户位置
//3.将用户位置发送给服务器，获取附近的用户微博
//4.显示在地图中


-(void)viewDidLoad{
    [super viewDidLoad];
    _isLocation = NO;
    [self createMapView];
}

-(void)createMapView{
    //在iOS8.0以上的版本需要获取定位权限
    if (KSystemVersion >=8.0) {
        CLLocationManager *manager = [[CLLocationManager alloc]init];
        //获取在应用程序使用期间访问用户位置的权限
        [manager requestWhenInUseAuthorization];
    }
    //创建地图视图
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //显示当前用户位置
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
}
//刷新了用户位置
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //调整地图显示的范围
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //获取经纬度
    double lat = coordinate.latitude;
    double lon = coordinate.longitude;
    
    //显示范围
    //地图显示的大小,单位是1经纬度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    
    //创建区域对象
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    //设定显示区域
    [_mapView setRegion:region animated:YES];
    //
    if (_isLocation == NO) {
        _isLocation = YES;
        //发送请求，获取附近的微博
        SinaWeibo *weibo = KSinaWeiboObject;
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        //设置经纬度参数
        [params setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"long"];
        [params setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
        
        [weibo requestWithURL:kNearbyWeiboAPI params:params httpMethod:@"GET" delegate:self];
    }
    
}

//获取附近的微博
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
//    NSLog(@"%@",result);
    
    NSArray *array = result[@"statuses"];
    for (NSDictionary *dic in array) {
        //构造微博对象
        WeiboModel *model = [WeiboModel yy_modelWithJSON:dic];
        //创建标注点
        WeiboAnnotation *annotation = [[WeiboAnnotation alloc]init];
        annotation.weiboModel = model;
        //添加标注点
        [_mapView addAnnotation:annotation];
    }
}
//自定义标注视图
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    //当前用户位置点 也是一个标注视图
    //当前用户位置点不需要自定义标注返回nil 让系统来标注
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    NSLog(@"%@",annotation);
    //从复用池获取标注视图
    WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"WeiboAnnotationView"];
    if (view == nil) {
        view = (WeiboAnnotationView *)[[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"WeiboAnnotationView"];
    }
    return view;
    
}



@end
