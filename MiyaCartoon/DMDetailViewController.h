//
//  DMDetailViewController.h
//  MiyaCartoon
//
//  Created by miya on 16/6/18.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *localL;
@property (weak, nonatomic) IBOutlet UIButton *palyB;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong) NSString * urlID;
@end
