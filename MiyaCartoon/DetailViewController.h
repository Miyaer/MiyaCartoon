//
//  DetailViewController.h
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonJson.h"
@interface DetailViewController : UIViewController
@property (nonatomic,strong) NSString * urlId;
@property (nonatomic,strong) NSString * imageName;
@property (nonatomic,strong) CartoonJson *cjs;
@end
