//
//  DMViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/17.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "DMViewController.h"
#import "FirsstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "FivcViewController.h"
#import "ZLNavTabBarController.h"
#import "UIView+Frame.h"
@interface DMViewController ()

@end

@implementation DMViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCursor];
    // Do any additional setup after loading the view.
}
- (void)createCursor{
    FirsstViewController * startV = [[FirsstViewController alloc]init];
    startV.title = @"最新";
    startV.view.backgroundColor = [UIColor redColor];
    SecondViewController * svc = [[SecondViewController alloc]init];
    svc.title = @"港台";
    ThirdViewController * tvc = [[ThirdViewController alloc]init];
    tvc.title = @"日韩";
    FourViewController * fvc = [[FourViewController alloc]init];
    fvc.title = @"内地";
    FivcViewController * fiveVc = [[FivcViewController alloc]init];
    fiveVc.title = @"欧美";
    ZLNavTabBarController * navTabBarController = [[ZLNavTabBarController alloc]init];
    navTabBarController.subViewControllers = @[startV,svc,tvc,fvc,fiveVc];
    navTabBarController.mainViewBounces = YES;
    navTabBarController.selectedToIndex = 5;
    
    [navTabBarController addParentController:self];

    
}
//
//- (void)createControllers{
//    
//    FirsstViewController * startV = [[FirsstViewController alloc]init];
//    startV.title = @"更新";
//    
//        
//    SecondViewController * svc = [[SecondViewController alloc]init];
//    svc.title = @"港台";
//    
//    ThirdViewController * tvc = [[ThirdViewController alloc]init];
//    tvc.title = @"日韩";
//    
//    FourViewController * fvc = [[FourViewController alloc]init];
//    fvc.title = @"内地";
//    
//    FivcViewController * fiveV = [[FivcViewController alloc]init];
//    fiveV.title = @"欧美";
//    //1.管理工具
//
//    scNav = [[SCNavTabBarController alloc]init];
//    //2.管理视图控制器
//    scNav.subViewControllers = @[startV,svc,tvc,fvc,fiveV];
//    
//    //颜色
//    
//    scNav.navTabBarColor = [UIColor whiteColor];
//    
//    //底色
//    self.view.backgroundColor = [UIColor clearColor];
//    
//    //3.执行 管理
//    
//    [scNav addParentController:self];
//    
//}
@end
