//
//  ModeCell.m
//  MiyaCartoon
//
//  Created by miya on 16/6/22.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "ModeCell.h"
#import "AppDelegate.h"
#import "MyViewController.h"
@implementation ModeCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchClick:(UISwitch *)sender {
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    

    if (sender.isOn) {
        //夜间模式
        delegate.isDay = NO;
        delegate.blackColor = [UIColor darkGrayColor];
        self.ModeL.text = @"夜间模式";
            }else{
        //白天模式
        delegate.isDay = YES;
        delegate.blackColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        self.ModeL.text = @"白天模式";
        
    }
    
}
- (NSArray *)array{
    if (!_array) {
        _array = [[NSArray alloc]init];
    }
    return _array;
}
@end
