//
//  HeaderView.m
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleName = [[UILabel alloc]initWithFrame:CGRectMake(25, 3, 100, 21)];
        self.titleName.textColor = [UIColor lightGrayColor];
        self.titleName.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleName];
//        self.backgroundColor = [UIColor colorWithRed:1.00 green:0.88 blue:0.62 alpha:1.00];
        self.headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-63, 0, 60, 30)];
        self.headerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        self.backgroundColor = [UIColor clearColor];
        [self.headerBtn setTitle:@"更多" forState:UIControlStateNormal];
        self.headerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.headerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.headerBtn setImage:[UIImage imageNamed:@"get-into@2x"] forState:UIControlStateNormal];
//        self.typeL = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-33-30, 0, 50, 30)];
//        self.typeL.text = @"更多";
//        self.typeL.font = [UIFont systemFontOfSize:12];
//        [self addSubview:self.typeL];
        self.userInteractionEnabled = YES;
        [self addSubview:self.headerBtn];
        self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 6, 15, 15)];
        self.titleImage.image = [UIImage imageNamed:@"gengduo"];
        [self addSubview:self.titleImage];
    }
    return self;
}


@end
