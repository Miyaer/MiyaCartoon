//
//  POIViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/20.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "POIViewController.h"
#import "GuoViewController.h"
#import "IKGifImageDecoder.h"
#import "IKAnimatedImageView.h"
@interface POIViewController ()
{
    IKAnimatedImageView * gifImageView;
    
    BOOL bUseCAKeyFrameAnimation;
    NSInteger pictureIndex;
}
@end

@implementation POIViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    bUseCAKeyFrameAnimation = NO;
    pictureIndex = 1;
    [self createGif];
    [self createUI];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}
- (void)createGif{
    if (gifImageView) {
        [gifImageView removeFromSuperview];
        gifImageView = nil;
    }
    gifImageView = [[IKAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44)];
    [self.view addSubview:gifImageView];
    
    NSString * pictureName = @"localBg";
    NSString * filePath = [[NSBundle mainBundle] pathForResource:pictureName ofType:@"gif"];
    IKAnimatedImage * tmpImage = [IKAnimatedImage animatedImageWithImagePath:filePath Decoder:[IKGifImageDecoder decoder]];
    if (bUseCAKeyFrameAnimation) {
        gifImageView.keyframeAnimation = [tmpImage convertToKeyFrameAnimation];
        
    }else{
        gifImageView.image = tmpImage;
        [gifImageView startAnimation];
    }
}
- (void)createUI{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y+HEIGHT/4);
    [btn setTitle:@"寻找漫展" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    btn.layer.borderWidth = 2;
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [gifImageView addSubview:btn];
    
}

- (void)btnClick:(UIButton *)btn{
    GuoViewController * gvc = [[GuoViewController alloc]init];
    gvc.hidesBottomBarWhenPushed = YES;
    gvc.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:gvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
