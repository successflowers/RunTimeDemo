//
//  SFDefaultView.m
//  Demo_001
//
//  Created by 张敬 on 2020/3/6.
//  Copyright © 2020 张敬. All rights reserved.
//

#import "SFDefaultView.h"

@implementation SFDefaultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNODataLabel: frame];
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self addNODataLabel: frame];
}

- (void)addNODataLabel: (CGRect)rect{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    imageView.backgroundColor = [UIColor redColor];
    imageView.frame = CGRectMake(0, 0, rect.size.width / 2.0, rect.size.width / 2.0);
    imageView.center = CGPointMake(self.center.x, self.center.y - 100);
    [self addSubview:imageView];

    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, imageView.center.y + imageView.frame.size.height / 2.0, rect.size.width, 30);
    label.text = @"抱歉，暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];

}

@end
