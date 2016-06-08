//
//  drawLineViewController.m
//  
//
//  Created by 刘博通 on 16/6/7.
//
//

#import "drawLineViewController.h"
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBGpsLocation.h>
#import <iNaviCore/MBReverseGeocoder.h>
#import <iNaviCore/MBPolylineOverlay.h>
#import <iNaviCore/MBPoiQuery.h>
#import "AFNetworking.h"
#import "MJExtension.h"

@interface drawLineViewController ()<MBGpsLocationDelegate,MBMapViewDelegate,MBReverseGeocodeDelegate,UIAlertViewDelegate>

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
 *  绘制多边形polygon和线条line的Overlay
 */
@property (nonatomic ,strong) MBPolylineOverlay *polylineOverlay;

@end

@implementation drawLineViewController



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
BOOL state= YES;
- (IBAction)drawLine {
   
    
    
    
   
    
    
    
   }

- (IBAction)drawLineNum:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"1"]) {
        sender.selected =!sender.selected;
        if (sender.selected ==YES) {
            NSString *aa =@"12343309,4180268,12343332,4180302,12343344,4180302,12343363,4180301,123434,4180299,12342796,4180488,12342799,4180498,12342784,4180498,12342781,4180488,12342761,4180424,12342742,4180368,12342729,4180337";
            
            [self lineString:aa state:MBStrokeStyle_solid];
            
            [sender setBackgroundColor:[UIColor redColor]];

        }
              if (sender.selected ==NO) {
             [_mapView removeOverlay:self.polylineOverlay];
        }

    }
    
    if ([sender.titleLabel.text isEqualToString:@"2"]) {
         sender.selected =!sender.selected;
        if (sender.selected ==YES) {
            NSString *bb =@"12343449,4180235,12343457,4180202,12343457,4180164,12343432,4180090,12343398,4180054,12343330,4180016,12343315,4179995";
            [self lineString:bb state:MBStrokeStyle_10];
            [sender setBackgroundColor:[UIColor redColor]];

        }
        
        if (sender.selected ==NO) {
            [_mapView removeOverlay:self.polylineOverlay];
        }


    }
    
    if ([sender.titleLabel.text isEqualToString:@"3"]) {
         sender.selected =!sender.selected;
        if (sender.selected ==YES) {
            NSString *cc=@"12343352,4179941,12343343,4179941,12343309,4179941,12343268,4179947,12343169,4179969,12343156,4179972,12343105,4179982,12343021,418,12342957,4180015,12343048,4180233,12343054,4180248";
            [self lineString:cc state:MBStrokeStyle_63];
            [sender setBackgroundColor:[UIColor redColor]];
        }
        if (sender.selected ==NO) {
            [_mapView removeOverlay:self.polylineOverlay];
        }

        
              }
    
    if ([sender.titleLabel.text isEqualToString:@"4"]) {
         sender.selected =!sender.selected;
        if (sender.selected ==YES) {
            NSString *dd=@"12343034,4180253,1234299,4180263,12342955,4180271,12342929,4180276,12342812,4180299,12342733,4180309,12342753,4180366,12342775,4180423";
            
            
            [self lineString:dd state:MBStrokeStyle_route];
            [sender setBackgroundColor:[UIColor redColor]];

        }
        if (sender.selected ==NO) {
            [_mapView removeOverlay:self.polylineOverlay];
        }

       
    }



}


-(void)lineString:(NSString *)b state:(MBStrokeStyle)ddd
{
  
    
    
//    if (state) {
        
        
        
                  NSArray * pointsArr = [b componentsSeparatedByString:@","];
        
        
        
        NSMutableArray *lon =[NSMutableArray array];
        NSMutableArray *lat=[NSMutableArray array];
        for (int i ; i<pointsArr.count; i++) {
            if (i%2==0) {
                [lon addObject:pointsArr[i]];
            }
            if (i%2==1) {
                
                [lat addObject:pointsArr[i]];
            }
            
        }
        
        NSLog(@"%@",lon);
        
        NSLog(@"%@",lat);
        
        
        
        
        MBPoint* points = (MBPoint*)malloc(sizeof(MBPoint)*(lon.count));
        MBPoint*tempPoints = points;
        for (int i = 0; i<lon.count; i++) {
            
            
            
            (*tempPoints).x = [lon[i] intValue];
            
            (*tempPoints).y = [lat[i] intValue];
            
            NSLog(@"%d,%d",(*tempPoints).x,(*tempPoints).y);
            tempPoints++;
            //                MBPoint point = {centerPoint.x+i*10,centerPoint.y+i*10};
            //                MBIconOverlay *car = [[MBIconOverlay alloc]initWithFilePath:@"res/icons/1100.png" maintainPixelSize:YES];
            //                car.position = point;
            //                [self.mapView addOverlay:car];
            
        }
        
        
        
        self.polylineOverlay = [[MBPolylineOverlay alloc] initWithPoints:points count:lon.count isClosed:NO];
        [self.polylineOverlay setWidth:15];
        [self.polylineOverlay setOutlineColor:0xFF000000];
        [self.polylineOverlay setStrokeStyle:ddd];
        [self.polylineOverlay setColor:0xFF2176EE];
        [self.mapView addOverlay:self.polylineOverlay];
    
//        MBPolylineOverlay *ee =[[MBPolylineOverlay alloc] initWithPoints:points count:lon.count isClosed:NO];
//        [ee setWidth:15];
//        [ee setOutlineColor:0xFF000000];
//        [ee setStrokeStyle:ddd];
//        [ee setColor:0xFF2176EE];
//        [self.mapView addOverlay:ee];
        free(points);
        
   // }
  //  state =NO;

    
    
    
}


- (IBAction)removeLine {
    
   
    

    
}


#pragma mark - MBGpsLocationDelegate
// GPS 更新的时候调用
-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    if (self.mapView.authErrorType == MBAuthError_none) {
        self.mapView.worldCenter = info.pos;
        [self.gpsLocation stopUpdatingLocation];
    }
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
