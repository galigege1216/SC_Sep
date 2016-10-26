//
//  WeiboAnnotationView.m
//  SC_Weibo
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"

@implementation WeiboAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"创建标注视图");
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    
    //背景视图
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    bgImageView.image = [UIImage imageNamed:@"nearby_map_people_bg"];
    [self addSubview:bgImageView];
    //头像视图
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 50, 50)];
    userImageView.layer.cornerRadius = 3.0;
    userImageView.layer.masksToBounds = YES;
    userImageView.backgroundColor = [UIColor orangeColor];
    [bgImageView addSubview:userImageView];
    //调整背景视图frame 默认是左上角 调整到底边中点不动
    bgImageView.frame = CGRectMake(-35, -70, 70, 70);
    //加载用户头像
    WeiboAnnotation *annotation = self.annotation;
    WeiboModel *model = annotation.weiboModel;
    [userImageView sd_setImageWithURL:model.user.profile_image_url];
    
}

@end
