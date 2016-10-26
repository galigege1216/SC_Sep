//
//  Emoticon.m
//  SC_Weibo
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Sccc. All rights reserved.
//

#import "Emoticon.h"

@implementation Emoticon

-(UIImage *)emoticonImage{
    UIImage *image = [UIImage imageNamed:self.png];
    return image;
}

@end
