//
//  ModeCell.h
//  MiyaCartoon
//
//  Created by miya on 16/6/22.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *ModeL;
- (IBAction)switchClick:(UISwitch *)sender;
@property (nonatomic,strong) UIViewController * vc;
@property (nonatomic,strong) NSArray * array;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@end
