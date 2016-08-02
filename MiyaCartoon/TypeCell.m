//
//  TypeCell.m
//  MiyaCartoon
//
//  Created by miya on 16/6/17.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "TypeCell.h"

@implementation TypeCell

- (void)awakeFromNib {
    // Initialization code
    self.typeImage.layer.masksToBounds = YES;
    self.typeImage.layer.cornerRadius = 10;
}

@end
