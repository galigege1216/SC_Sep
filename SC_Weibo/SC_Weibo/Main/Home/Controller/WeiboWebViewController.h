//
//  WeiboWebViewController.h
//  SC_Weibo
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboWebViewController : BaseViewController

@property(strong,nonatomic)NSURL *url;

-(instancetype)initWithURL:(NSURL *)url;

@end
