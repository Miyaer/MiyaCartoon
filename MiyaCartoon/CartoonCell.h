//
//  CartoonCell.h
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonJson.h"
@interface CartoonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *autorL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;


- (void)showInfoModel:(CartoonJson *)cjs;
@end
