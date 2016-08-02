//
//  EnterViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/21.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "EnterViewController.h"
#import "IKGifImageDecoder.h"
#import "IKAnimatedImageView.h"
#import "MyTabBar.h"
#import "AppDelegate.h"
@interface EnterViewController ()
{
    IKAnimatedImageView * gifImageView;
    
    BOOL bUseCAKeyFrameAnimation;
    NSInteger pictureIndex;
    BOOL isEnter;
}
@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createGif];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 10;
    btn.center = CGPointMake(self.view.center.x, self.view.center.y+HEIGHT/4);
    [btn setTintColor:[UIColor blackColor]];
    [btn setTitle:@"开启娱漫之旅" forState:UIControlStateNormal];
    btn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    btn.layer.borderWidth = 3;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [gifImageView addSubview:btn];

}
-(void)btnClick:(UIButton *)btn{
    
        UIApplication * application = [UIApplication sharedApplication];
        AppDelegate * delegate = application.delegate;
        delegate.window.rootViewController = [[MyTabBar alloc]init];


}
- (void)createGif{
    //如果图片存在 就从视图中删除
    if (gifImageView) {
        [gifImageView removeFromSuperview];
        gifImageView = nil;
    }
    //图片视图的大小位置
    gifImageView = [[IKAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:gifImageView];
   //图片名字
    NSString * pictureName = @"first";
    //获得图片的路径
    NSString * filePath = [[NSBundle mainBundle] pathForResource:pictureName ofType:@"gif"];
    //获得动态图片
    IKAnimatedImage * tmpImage = [IKAnimatedImage animatedImageWithImagePath:filePath Decoder:[IKGifImageDecoder decoder]];
    
    if (bUseCAKeyFrameAnimation) {
        gifImageView.keyframeAnimation = [tmpImage convertToKeyFrameAnimation];
        
    }else{
        gifImageView.image = tmpImage;
        [gifImageView startAnimation];
    }
    
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
