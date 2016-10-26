//
//  LeftViewController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_data;
    NSInteger _selectIndex;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片
    ThemeImageView *bgImageView =[[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"mask_bg.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    
    [self _createTable];
}

-(void)_createTable{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, kScreenHeight -64) style:UITableViewStylePlain];
    
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    NSArray *array = @[@"无",@"滑动",@"滑动&缩放",@"3D旋转",@"视差滑动"];
    _data = [array mutableCopy];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectIndex = 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        ThemeImageView *imgView = [[ThemeImageView alloc]initWithFrame:CGRectMake(5, 0, 44, 44)];
        imgView.imageName = @"sidebar_themebar_bg";
        [cell.contentView addSubview:imgView];
        
        ThemeLabel *label = [[ThemeLabel alloc]initWithFrame:CGRectMake(54, 0, 80, 44)];
        label.colorName = kMoreItemTextColor;
        [cell.contentView addSubview:label];
        label.tag = 110;
//        label.text = _data[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    //填充数据
    UILabel *label = [cell.contentView viewWithTag:110];
    label.text = _data[indexPath.row];
    
    
    if (indexPath.row == _selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _selectIndex = indexPath.row;
    [tableView reloadData];
    
    MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
    //改变滑动样式
    manager.leftDrawerAnimationType = indexPath.row;
    manager.rightDrawerAnimationType = indexPath.row;
    
    
    
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
