//
//  CartoonCell.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "CartoonCell.h"
#import "UIImageView+WebCache.h"
@implementation CartoonCell

- (void)awakeFromNib {
    
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showInfoModel:(CartoonJson *)cjs
{
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:cjs.images]];
    self.titleL.text = cjs.name;
    self.typeL.text = cjs.categoryLabel;
    
    self.autorL.text = [NSString stringWithFormat:@"作者:%@",cjs.author];
    [self.autorL sizeToFit];
    self.dateL.text = [NSString stringWithFormat:@"更新时间:%@",cjs.createTime];
    [self.dateL sizeToFit];
}
@end
