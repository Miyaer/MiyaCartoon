//
//  MovieCell.h
//  MiyaCartoon
//
//  Created by miya on 16/6/17.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@end
