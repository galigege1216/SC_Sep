//
//  LocationViewController.h
//  SC_Weibo
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^LocationResultBlock)(NSDictionary *result);

@interface LocationViewController : BaseViewController

@property(nonatomic,copy)LocationResultBlock block;

-(void)addLocationResultBlock:(LocationResultBlock)block;

@end
