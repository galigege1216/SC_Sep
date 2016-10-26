//
//  ThemeSelectController.m
//  SC_Weibo
//
//  Created by Apple on 16/10/4.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "ThemeSelectController.h"

@interface ThemeSelectController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    UIColor *_textColor;
}

@end

@implementation ThemeSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor grayColor];
    
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.dataSource =self;
    _table.delegate =self;
    _table.backgroundColor =[UIColor clearColor];
    //监听主题改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangeNotificationName object:nil];
    
    
}

//主题改变
-(void)themeChange{
    //设置字体颜色
    _textColor = [[ThemeManager shareManager]themeColorWithName:kMoreItemTextColor];
    
    //刷新数据
    [_table reloadData];
    //设置分割线颜色
    _table.separatorColor = [[ThemeManager shareManager]themeColorWithName:kMoreItemLineColor];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - deleget
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ThemeManager shareManager].allThemes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeManager *manager =[ThemeManager shareManager];
    NSDictionary *allTheme =manager.allThemes;
    NSArray *allKeys =allTheme.allKeys;
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        //系统自带默认单元格样式
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor =[UIColor clearColor];
        
    }
    //主题名
    NSString *key =allKeys[indexPath.row];
    cell.textLabel.text =key;
    cell.textLabel.textColor = _textColor;
    //手动拼接图片路径
    NSString *imageName =[NSString stringWithFormat:@"%@/%@",allTheme[key],@"more_icon_theme.png"];
    cell.imageView.image =[UIImage imageNamed:imageName];
    //主题名对应管理器当前主题名
    if ([manager.currentThemeName isEqualToString:key]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeManager *manager =[ThemeManager shareManager];
    NSDictionary *allTheme =manager.allThemes;
    NSArray *allKeys =allTheme.allKeys;
    NSString *selectTheme =allKeys[indexPath.row];
    //刷新数据
    manager.currentThemeName =selectTheme;
    [_table reloadData];
}


@end
