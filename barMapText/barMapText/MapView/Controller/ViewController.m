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
#import "AFNetworking.h"
#import "MJExtension.h"
#import "LTRaditionsShowModel.h"
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


//** 事件显示模型数组 */
@property (nonatomic ,strong)NSArray *showRaditonsArr;

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


/*
 * 加载事件数据
 */
-(void)showRoadConditon
{
    
}

- (void)mbMapView:(MBMapView *)mapView didPanStartPos:(MBPoint)pos
{
    //NSLog(@"%f,%f",mapView.worldCenter.x/100000.0,mapView.worldCenter.y/100000.0);
   

    
    [self upRoadConditonDataForNet];
}

-(void)upRoadConditonDataForNet
{
    NSLog(@"%d",(int)self.mapView.zoomLevel);
    
//    if ((int)self.mapView.zoomLevel<10){
//        [self removeRoadcondi];
//        self.showRaditonsArr =nil;
//        return;
//        
//    }

    
    NSDictionary *params=[self getParams];
    
    [[AFHTTPSessionManager manager]GET:@"http://mobile.trafficeye.com.cn:8087/EventService/raditionshow/range" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
      // [self removeRoadcondi];
        self.showRaditonsArr =[LTRaditionsShowModel mj_objectArrayWithKeyValuesArray:responseObject[@"response"][@"result"]];
         //NSLog(@"%@",responseObject);
        
        //[self.roadConditionsShow signal];
        [self addRaditionView:(int)self.mapView.zoomLevel];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error raodcit");
        NSLog(@"error%@",error);
        //[self.roadConditionsShow signal];
        
    }];

}

-(void)addRaditionView:(int)mapLevel
{
    
//    MBPoint centerPoint = self.mapView.worldCenter;
//    for (int i = 0; i<10; i++) {
//        
//        int valueX =arc4random_uniform(500 + 1);
//        int valueY =arc4random_uniform(500 + 1);
//        
//        MBPoint point;
//        point.x = centerPoint.x+valueX;
//        point.y = centerPoint.y+valueY;
//        NSLog(@"%d,%d",point.x,point.y);
//        CGPoint pivotPoint = {0, 0};
//        MBAnnotation* annotation = [[MBAnnotation alloc] initWithZLevel:2 pos:point iconId:1030 pivot: pivotPoint];
//               [self.mapView addAnnotation:annotation];
//    }

    
    
    
//
        for (LTRaditionsShowModel *showRoadModel in self.showRaditonsArr) {
            MBPoint point;
            point.x =(int)(showRoadModel.linkLongitude *100000);
            point.y =(int)(showRoadModel.linkLatitude *100000);
            
           // NSLog(@"%d,%d",point.x,point.y);
            CGPoint pivotPoint = {0, 0};
            showRoadModel.anno=[[MBAnnotation alloc]initWithZLevel:0 pos:point iconId:1030 pivot:pivotPoint];
            
            
            
             [self.mapView addAnnotation:showRoadModel.anno];
            
        }
    
//        showAnno.latitude =showRoadModel.linkLatitude;
//        showAnno.longitude=showRoadModel.linkLongitude;
//        showRoadModel.anno =showAnno;
//        showAnno.msg1 =@"show";
//        showAnno.msg2 =[LTRoadConditonTools getRoadConditonIcon:showRoadModel.trafficEyeType];
//        showAnno.tag =showRoadModel.eventId;
//        
//        
//        [_mapView addAnnotation:showRoadModel.anno viewHande:nil customIcon:showAnno.msg2];
        
        
        
        
  
}


-(void)removeRoadcondi
{
    for (LTRaditionsShowModel *model in self.showRaditonsArr) {
        [self.mapView removeAnnotation:model.anno];
    }
    
    
}

- (void)mbMapView:(MBMapView *)mapView onGestureAnimationEvent:(BOOL)animStarted
{
    NSLog(@"erewrewqqqghhh");
}

- (void)mbMapViewDrawFinished:(MBMapView *)mapView
{
    NSLog(@"erewrewqfxxxxxx");
}

-(NSDictionary *)getParams
{
    MBRect rect;
    rect.left=0;
    rect.top =0;
    rect.right =kMainScreenSizeWidth;
    rect.bottom=kMainScreenSizeHeight;
    MBRect r=  [self.mapView screenRect2World:rect];
    
    NSLog(@"%d,%d,%d,%d,%d",r.left,r.top,r.right,r.bottom,(int)self.mapView.zoomLevel);
    

    NSMutableDictionary *params =[NSMutableDictionary dictionary];

    params[@"eventlevel"]=[ViewController getRoadLevel:(NSInteger)self.mapView.zoomLevel];
    params[@"restype"]=@"json";
    
    params[@"lt"]=[NSString stringWithFormat:@"%f,%f",r.left/100000.0,r.top/100000.0];
    params[@"rb"]=[NSString stringWithFormat:@"%f,%f",r.right/100000.0,r.bottom/100000.0];

    
    
    
    return params;
}

+(NSString *)getRoadLevel:(NSInteger)maplevel
{
    NSString *roadLevel;
    if (maplevel ==9) {
        roadLevel=@"0,2";
    }else if (maplevel ==10)
    {
        roadLevel=@"0,103";
    }else if (maplevel ==11)
    {
        roadLevel=@"0,204";
    }else if (maplevel ==12)
    {
        roadLevel=@"0,305";
    }else if (maplevel ==13)
    {
        roadLevel=@"0,406";
    }else if (maplevel ==14)
    {
        roadLevel=@"0,602";
    }else if (maplevel ==15)
    {
        roadLevel=@"0,605";
    }else if (maplevel ==16)
    {
        roadLevel=@"0,608";
    }else if (maplevel ==17)
    {
        roadLevel=@"0,609";
    }else{
        roadLevel =@"0,609";
    }
    
    return roadLevel;
    
}



- (void)mbMapViewDidTouched:(MBMapView *)mapView
{
    //NSLog(@"ddddaaaqa");
}

//- (void)mbMapViewDrawFinished:(MBMapView *)mapView
//{
//    NSLog(@"dfds");
//}


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


- (void)mbMapView:(MBMapView *)mapView onCameraAnimationEnded:(void*)unused
{
    NSLog(@"erwrew");
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
       
        //[self.navigationController popViewControllerAnimated:YES];
    }
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
