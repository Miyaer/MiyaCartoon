//
//  MyTabBar.m
//  Cmy的封装类
//
//  Created by soul on 16/5/12.
//  Copyright © 2016年 Miya. All rights reserved.
//

#import "MyTabBar.h"

@interface MyTabBar ()

@end

@implementation MyTabBar

- (void)createTabBar{
    NSArray * imageArr = @[@"main",@"movie",@"local",@"my"];
    NSArray * selectArr = @[@"main_select",@"movie_select",@"local_select",@"my_select"];
    NSArray * ClassArr = @[@"MainViewController",@"DMViewController",@"POIViewController",@"MyViewController"];
    NSArray * titleArr = @[@"漫画",@"动漫",@"漫展",@"我的"];
    NSMutableArray * arrayCtr = [[NSMutableArray alloc]init];
    for (int i = 0; i<ClassArr.count; i++) {
        Class viewCtrClass = NSClassFromString(ClassArr[i]);
        UIViewController * vc = [[viewCtrClass alloc]init];
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        
        if (i<3) {
            [vc.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:0];
            
            vc.navigationItem.title = titleArr[i];

        }

        nav.tabBarItem.image = [[UIImage imageNamed:imageArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        nav.tabBarItem.title = titleArr[i];
        
        [arrayCtr addObject:nav];
    }
    self.tabBar.tintColor = [UIColor colorWithRed:0.34 green:0.67 blue:0.89 alpha:1.00];
    self.tabBar.backgroundColor = [UIColor whiteColor];
   // self.tabBar.backgroundImage = [UIImage imageNamed:@"TabbarBg"];
    self.viewControllers = arrayCtr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
