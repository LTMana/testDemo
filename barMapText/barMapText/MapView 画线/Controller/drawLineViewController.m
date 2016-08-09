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

#define POINTCOUNT 10
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


@property (nonatomic,strong) NSArray *pointSet;

@property (nonatomic,strong)NSMutableDictionary *pointsDic;

@property (nonatomic,strong)NSMutableArray *polyLineArr;

@end

@implementation drawLineViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMapView];

}


-(NSMutableArray *)polyLineArr
{
    if (_polyLineArr ==nil) {
        _polyLineArr =[NSMutableArray array];
    }
    
    return _polyLineArr;
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
        
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"level.plist" ofType:nil];

        
        self.pointSet =[NSArray arrayWithContentsOfFile:filePath];
        
//    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"drawlines.txt" ofType:nil];
//        
//        NSLog(@"%@",filePath);
//        NSMutableArray *moveArr=[NSMutableArray array];
//        
//        
//        NSString *str=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        NSArray *array = [str componentsSeparatedByString:@"move,"];
//        
//        for (NSString *moveStr in array) {
//            
//            NSArray *array = [moveStr componentsSeparatedByString:@","];
//            
//            NSMutableArray *tempArr=[NSMutableArray array];
//            for (int i=0; i<array.count; i++) {
//                if (i%2==0) {
//                    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//                    self.pointsDic =dic;
//                    [self.pointsDic setObject:array[i] forKey:@"lon"];
//                }else{
//                     [self.pointsDic setObject:array[i] forKey:@"lat"];
//                    
//                }
//                
//                
//              
//                [tempArr addObject:self.pointsDic];
//                
//            }
//            
//           
//            [moveArr addObject:tempArr];
//         
//        }
//        
//        
//        [moveArr writeToFile:@"/Users/liubotong/Desktop/level.plist" atomically:YES];
       // NSLog(@"array:%@",array);
    }
    
    return _mapView;
}

-(void)writeOrReadFile
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *fileName = [path stringByAppendingPathComponent:@"123.plist"];
    
    NSArray *array = @[@ "123" , @ "456" , @ "789" ];
    [array writeToFile:fileName atomically:YES];
    
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    NSLog(@"%@",result);
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
   
    
    static int index=0;
   
    
    for (int i=0; i<self.pointSet.count; i++) {
        index ++;
        
        NSArray *pointsArr =self.pointSet[i];
        //NSLog(@"执行次数%d",index);
        MBPoint* points = (MBPoint*)malloc(sizeof(MBPoint)*(pointsArr.count));
        
        MBPoint*tempPoints = points;
        for (NSDictionary *lonWithLat in pointsArr) {
            
            (*tempPoints).x = [lonWithLat[@"lon"] intValue] *0.1;
            
            (*tempPoints).y =[lonWithLat[@"lat"] intValue]*0.1;
            tempPoints++;
            
        }
        
        
        MBPolylineOverlay *polylineOverlay =[[MBPolylineOverlay alloc] initWithPoints:points count:pointsArr.count  isClosed:NO];

        
        if (i%3==0) {
            [polylineOverlay setOutlineColor:0xFF0000FF];
            [polylineOverlay setColor:0xFF0000FF];
        }
        if (i%3==1) {
            [polylineOverlay setOutlineColor:0xFF00FF00];
            [polylineOverlay setColor:0xFF00FF00];
        }
        
        if (i%3==2) {
            [polylineOverlay setOutlineColor:0xFF00FFFF];
            [polylineOverlay setColor:0xFF00FFFF];
            
        }
        
        
        [polylineOverlay setWidth:7];
        [polylineOverlay setStrokeStyle:MBStrokeStyle_tunnel];
        
        [self.mapView addOverlay:polylineOverlay];
        
        free(points);
        
        [self.polyLineArr addObject:polylineOverlay];

        
        
        
//        self.polylineOverlay = [[MBPolylineOverlay alloc] initWithPoints:points count:pointsArr.count isClosed:NO];
//        
//        if (i%3==0) {
//            [self.polylineOverlay setOutlineColor:0xFF0000FF];
//            [self.polylineOverlay setColor:0xFF0000FF];
//        }
//        if (i%3==1) {
//            [self.polylineOverlay setOutlineColor:0xFF00FF00];
//            [self.polylineOverlay setColor:0xFF00FF00];
//        }
// 
//        if (i%3==2) {
//            [self.polylineOverlay setOutlineColor:0xFF00FFFF];
//            [self.polylineOverlay setColor:0xFF00FFFF];
//
//        }
//        
//        
//        [self.polylineOverlay setWidth:9];
//               [self.polylineOverlay setStrokeStyle:MBStrokeStyle_tunnel];
//        
//        [self.mapView addOverlay:self.polylineOverlay];
//        
//        free(points);
//        
//        [self.polyLineArr addObject:self.polylineOverlay];
        

    }
    
    
//    
//        for (NSArray *pointsArr in self.pointSet) {
//            index ++;
//           
//            //NSLog(@"执行次数%d",index);
//            MBPoint* points = (MBPoint*)malloc(sizeof(MBPoint)*(pointsArr.count));
//            
//            MBPoint*tempPoints = points;
//            for (NSDictionary *lonWithLat in pointsArr) {
//
//                (*tempPoints).x = [lonWithLat[@"lon"] intValue] *0.1;
//                
//                (*tempPoints).y =[lonWithLat[@"lat"] intValue]*0.1;
//                tempPoints++;
//                
//            }
//            
//            self.polylineOverlay = [[MBPolylineOverlay alloc] initWithPoints:points count:pointsArr.count isClosed:NO];
//               
//                
//                [self.polylineOverlay setWidth:13];
//                [self.polylineOverlay setOutlineColor:0xFF0000FF];
//                [self.polylineOverlay setStrokeStyle:MBStrokeStyle_tunnel];
//                [self.polylineOverlay setColor:0xFF0000FF];
//                [self.mapView addOverlay:self.polylineOverlay];
//                
//                 free(points);
//
//            
//                 
//            
//            
//            
//            
//            
//            
//        }
    


   }

//#pragma mark -gc-02 转 84坐标
//- (CLLocationCoordinate2D)MarsGS2WorldGS:(CLLocationCoordinate2D)coordinate
//{
//    double gLat = coordinate.latitude;
//    double gLon = coordinate.longitude;
//    CLLocationCoordinate2D marsCoor = [self WorldGS2MarsGS:coordinate];
//    double dLat = marsCoor.latitude - gLat;
//    double dLon = marsCoor.longitude - gLon;
//    return CLLocationCoordinate2DMake(gLat - dLat, gLon - dLon);
//}
//
//
//
//- (CLLocationCoordinate2D)WorldGS2MarsGS:(CLLocationCoordinate2D)coordinate
//{
//    // a = 6378245.0, 1/f = 298.3
//    // b = a * (1 - f)
//    // ee = (a^2 - b^2) / a^2;
//    const double a = 6378245.0;
//    const double ee = 0.00669342162296594323;
//
//    double wgLat = coordinate.latitude;
//    double wgLon = coordinate.longitude;
//
//    double dLat = [self transformLatX:wgLon - 105.0 transformLatY:wgLat - 35.0];
//    double dLon = [self transformLonX:wgLon - 105.0 transformLonY:wgLat - 35.0];
//    
//   
//    double radLat = wgLat / 180.0 * M_PI;
//    double magic = sin(radLat);
//    magic = 1 - ee * magic * magic;
//    double sqrtMagic = sqrt(magic);
//    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
//    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
//    
//    return CLLocationCoordinate2DMake(wgLat + dLat, wgLon + dLon);
//}
//
//- (double) transformLatX:(double)x  transformLatY:(double) y
//{
//    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y +
//    0.2 * sqrt(fabs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x *M_PI)) * 2.0 /
//    3.0;
//    ret += (20.0 * sin(y * M_PI) + 40.0 *sin(y / 3.0 *M_PI)) * 2.0 / 3.0;
//    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 *sin(y * M_PI / 30.0)) * 2.0 /
//    3.0;
//    return ret;
//}
//
//- (double) transformLonX:(double) x transformLonY:(double) y
//{
//    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 /
//    3.0;
//    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
//    ret += (150.0 * sin(x / 12.0 *M_PI) + 300.0 *sin(x / 30.0 * M_PI)) * 2.0 /
//    3.0;
//    return ret;
//}






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
          
            
            tempPoints++;
            
            NSLog(@"%d,%d",(*tempPoints).x,(*tempPoints).y);

            //                MBPoint point = {centerPoint.x+i*10,centerPoint.y+i*10};
            //                MBIconOverlay *car = [[MBIconOverlay alloc]initWithFilePath:@"res/icons/1100.png" maintainPixelSize:YES];
            //                car.position = point;
            //                [self.mapView addOverlay:car];
            
        }
        
        MBPolylineOverlay *polylineOverlay =[[MBPolylineOverlay alloc] initWithPoints:points count:lon.count isClosed:NO];
        
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


- (IBAction)Traffic:(UIButton *)sender {
     sender.selected =!sender.selected;
    if ([sender isSelected]) {
        [self removeLine];
        
        self.mapView.enableTmc = YES;
    } else {
        self.mapView.enableTmc = NO;
    }
}



- (IBAction)removeLine {
    
  
   
    [self.mapView removeOverlays:self.polyLineArr];
   
    self.polyLineArr =nil;

    
}


#pragma mark - MBGpsLocationDelegate
// GPS 更新的时候调用
-(void)didGpsInfoUpdated:(MBGpsInfo *)info{
    if (self.mapView.authErrorType == MBAuthError_none) {
        self.mapView.worldCenter = info.pos;
        NSLog(@"%d,%d",self.mapView.worldCenter.x,self.mapView.worldCenter.y);
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
