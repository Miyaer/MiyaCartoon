//
//  GuoViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/20.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "GuoViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "LLSlideMenu.h"
@interface GuoViewController ()<MKMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>//地图协议,定位协议
{
    MKCoordinateSpan span;
}
//@property (nonatomic, strong) UIPanGestureRecognizer *leftSwipe;//侧滑手势
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percent;
//@property (nonatomic, strong) LLSlideMenu *slideMenu;
@property (nonatomic,strong) UIView * slideView;
@property (nonatomic,strong) MKMapView * mapView;//地图视图
@property (nonatomic,strong) CLLocation * location; //获取的用户位置
@property (nonatomic,strong) CLLocationManager  * manager;
@property (nonatomic,strong) CLGeocoder * coder;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSMutableArray * localArr;//漫展数组
@property (nonatomic,strong) UITableView * localTable;
@property (nonatomic,strong) NSMutableArray * coorArr;
@end

@implementation GuoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    span = MKCoordinateSpanMake(0.03, 0.03);
    [self createNav];
    [self createMapView];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self getLocation];
    [self getCoordinate];
    [self createSlideView];
}
- (void)createSlideView{
    _slideView = [[UIView alloc]initWithFrame:CGRectMake(-(WIDTH/2), 64, WIDTH/2, HEIGHT-64)];
    _slideView.userInteractionEnabled = YES;
    _slideView.backgroundColor =[UIColor colorWithRed:0.45 green:0.79 blue:0.93 alpha:0.6];
    [_mapView addSubview:_slideView];
    
    [_slideView addSubview:self.localTable];
    
    
}
- (void)rightClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _slideView.frame = CGRectMake(0, 64, WIDTH/2, HEIGHT-64);
        } completion:nil];
        
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _slideView.frame =CGRectMake(-(WIDTH/2), 64, WIDTH/2, HEIGHT-64);
        } completion:nil];
    }
}
- (void)createNav{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNSIZE, BTNHEIGHT)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNSIZE, BTNHEIGHT)];
    rightBtn.tag = 100;
    [rightBtn setImage:[UIImage imageNamed:@"mu.png"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
-(void)btnClick:(UIButton *)btn{
    [_slideView removeFromSuperview];
    [_mapView removeFromSuperview];
    [self.localArr removeAllObjects];
    [self.coorArr removeAllObjects];
    _manager.delegate = nil;
    _mapView.delegate = nil;
    _location = nil;
    self.coder = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.localArr removeAllObjects];
//    [self.coorArr removeAllObjects];
//    [_slideView removeFromSuperview];
//    [_mapView removeFromSuperview];
//    _manager.delegate = nil;
//    _mapView.delegate = nil;
//    _location = nil;
//    self.coder = nil;
//    
//}
//获取位置信息
- (void)getLocation{
    _manager = [[CLLocationManager alloc]init];
    _manager.desiredAccuracy = kCLLocationAccuracyBest;//精确定位
    
    _manager.distanceFilter = 0.5;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [_manager requestWhenInUseAuthorization];
    }
    _manager.delegate = self;
    [_manager startUpdatingLocation];

}
- (void)createMapView{
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
   
    _mapView.mapType = MKMapTypeStandard;
       MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, span);
    _mapView.region = region;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode =1;
    _mapView.scrollEnabled = YES;
    _mapView.delegate = self;
    
     [self.view addSubview:_mapView];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.localArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string = @"localCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.localArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mapView removeFromSuperview];
        CLLocation * location = self.coorArr[indexPath.row];
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        _mapView.region = region;
    UIButton * btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:100];
    [UIView animateWithDuration:0.3 animations:^{
        _slideView.frame =CGRectMake(-(WIDTH/2), 64, WIDTH/2, HEIGHT-64);
    } completion:nil];
    btn.selected = NO;
    location = nil;
    
    [self.view addSubview:_mapView];

}
#pragma mark - 定位协议
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    _location = [locations lastObject];
    _coordinate = _location.coordinate;
    [_manager stopUpdatingLocation];

  }
- (void)getCoordinate{
    
    MKLocalSearchRequest * request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"漫展";
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, span);
    request.region = region;
    MKLocalSearch * search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray * mapItemArray = response.mapItems;
            for (MKMapItem * item in mapItemArray) {
                MKPlacemark * place = item.placemark;
                CLLocation * location = place.location;
                
                MKPointAnnotation * antation = [[MKPointAnnotation alloc]init];
                antation.coordinate = location.coordinate;
                antation.title = place.name;
                antation.subtitle = item.phoneNumber;
                [_mapView addAnnotation:antation];
                [self.localArr addObject:place.name];
               // NSLog(@"%@",place.name);
                [self.coorArr addObject:location];
                [self.localTable reloadData];
            }
            
        }else{
            NSLog(@"获取失败");
        }
    }];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
        static NSString * pinViewID = @"pinID";
        MKPinAnnotationView * pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinViewID];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pinViewID];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.draggable = NO;
        }
        return pinView;
    
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self.mapView removeFromSuperview];
    [self.view addSubview:mapView];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败%@",error.debugDescription);
    
}

- (CLGeocoder *)coder{
    if (!_coder) {
        _coder = [[CLGeocoder alloc]init];
    }
    return _coder;
}
- (NSMutableArray *)localArr{
    if (!_localArr) {
        _localArr = [[NSMutableArray alloc]init];
        
    }
    return _localArr;
}
- (UITableView * )localTable{
    if (!_localTable) {
        _localTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 170, HEIGHT-64-20) style:UITableViewStylePlain];
        _localTable.delegate = self;
        _localTable.dataSource = self;
        _localTable.backgroundColor = [UIColor clearColor];
    }
    return _localTable;
}
- (NSMutableArray *)coorArr{
    if (!_coorArr) {
        _coorArr = [[NSMutableArray alloc]init];
        
    }
    return _coorArr;
}
@end
