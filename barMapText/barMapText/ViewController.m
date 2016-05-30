//
//  ViewController.m
//  barMapText
//
//  Created by 刘博通 on 16/5/30.
//  Copyright (c) 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBGpsLocation.h>
#import <iNaviCore/MBReverseGeocoder.h>
#import <iNaviCore/MBPoiQuery.h>

//#import "MBBaseMapView.h"
@interface ViewController ()<MBGpsLocationDelegate,MBMapViewDelegate,MBReverseGeocodeDelegate,UIAlertViewDelegate>
/**
 *  基础地图
 */
@property (nonatomic ,strong) MBMapView *mapView;

/**
 *  GPS 定位信息
 */
@property (nonatomic ,strong) MBGpsLocation *gpsLocation;


/**
 *  逆地理类
 */
@property (nonatomic ,strong) MBReverseGeocoder *reverseGeocoder;

/**
 *  当前位置
 */
@property (nonatomic ,assign) MBPoint point;


/**
 *  设置建筑物是否透明
 */
@property (nonatomic ,assign) BOOL isBuildingOpaque;


/**
 *  POI搜索类
 */
@property (nonatomic ,strong) MBPoiQuery *poiQuery;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

   [self setUpMapView];
    
}


/*
 * 懒加载地图
 */

-(MBMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MBMapView alloc]initWithFrame:kMainScreenBounds];
        // 判断授权
       _mapView.delegate = self;
      
    }
    
    return _mapView;
}

/*
 * 初始化地图
 */
-(void)setUpMapView
{
    if (self.mapView.authErrorType == MBSdkAuthError_none) {
        // 授权成功
        [self.view insertSubview:self.mapView atIndex:0];
        [self.mapView setZoomLevel:self.mapView.zoomLevel - 1 animated:YES];
        
        if ([CLLocationManager locationServicesEnabled]) {
            // 开始定位用户位置
            self.gpsLocation = [[MBGpsLocation alloc]init];
            self.gpsLocation.delegate = self;
            [self.gpsLocation startUpdatingLocation];
        }else{
            // 不能定位用户位置
            // 1. 提醒用户检查网络状况
            // 2. 提醒用户打开网络开关
        }
        
        self.poiQuery = [MBPoiQuery sharedInstance];
        MBPoiQueryParams *params = [MBPoiQueryParams defaultParams];
        params.mode = MBPoiQueryMode_online;
        self.poiQuery.params = params;

        self.reverseGeocoder = [[MBReverseGeocoder alloc]init];
        self.reverseGeocoder.delegate = self;

        // 防止按钮多点触发
    }else{
        // 授权失败
        ErrorMsg *msg = [[ErrorMsg alloc]initWithErrorId:self.mapView.authErrorType];
        NSString *strMsg = [NSString stringWithFormat:@"地图授权失败,%@",msg.errorMsg];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:strMsg delegate:self cancelButtonTitle:@"确定退出" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}


#pragma mark - MBGpsLocationDelegate
/**
 *  更新Gps信息
 */
-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    
    self.point = info.pos;
    
    
}

/*
 * 定位按钮
 */
- (IBAction)Userlocation {
    
    if (self.point.x == 0 && self.point.y == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请稍等正在定位中!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
//        self.pos.text = [NSString stringWithFormat:@"%d,%d",self.point.x,self.point.y];
        [self.reverseGeocoder reverseByPoint:&_point];
    }

}
#pragma mark - MBReverseGeocodeDelegate
/**
 *  逆地理开始
 */
-(void)reverseGeocodeEventStart:(MBReverseGeocoder*) reverseGeocodeManager{
    [SVProgressHUD showWithStatus:@"正在定位中,请稍候..." maskType:SVProgressHUDMaskTypeBlack];
}
/**
 *  逆地理成功
 */
-(void)reverseGeocodeEventSucc:(MBReverseGeocodeObject*)rgObject{
    
    [SVProgressHUD showSuccessWithStatus:@"定位成功 !" maskType:SVProgressHUDMaskTypeBlack];
    
    self.mapView.worldCenter = rgObject.pos;
  
}
/**
 *  逆地理失败
 */
-(void)reverseGeocodeEventFailed:(MBReverseGeocodeError)err{
    [SVProgressHUD showErrorWithStatus:@"定位失败 !" maskType:SVProgressHUDMaskTypeBlack];
}
/**
 *  逆地理取消
 */
-(void)reverseGeocodeEventCanceled{
    
}

/**
 *  销毁
 */
-(void)dealloc{
    self.mapView.delegate = nil;
    self.mapView = nil;
    self.reverseGeocoder.delegate = nil;
    self.reverseGeocoder = nil;
    [self.gpsLocation stopUpdatingLocation];
    self.gpsLocation.delegate = nil;
    self.gpsLocation = nil;
    self.poiQuery.delegate = nil;
    self.poiQuery = nil;
}

@end
