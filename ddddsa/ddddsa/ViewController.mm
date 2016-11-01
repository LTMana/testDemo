//
//  ViewController.m
//  ddddsa
//
//  Created by LTMana on 16/7/26.
//  Copyright © 2016年 ltcom. All rights reserved.
//  地图显示Demo

#import "ViewController.h"
#import "CNMapKit.h"


#import <CoreLocation/CoreLocation.h>


#define CLUserPoint [[self.mapView userLocation] coordinate]

#define SrceenUserPoint [self.mapView lnglatToPixel:CNMKGeoPointFromCLLocationCoordinate2D(CLUserPoint) toPointToView:self.view]
#define  kRoadConditionTimer @"changeJamTimer"

@interface ViewController ()<CNMKMapViewDelegate>
@property (nonatomic, retain) CNMKMapView *mapView;
/**
 *  meshId计算线程队列
 */
@property (nonatomic, strong)NSOperationQueue *meshQeue;
/**
 * 实时获取比例尺
 */
@property (nonatomic, assign)NSInteger changeMapLevel;
/**
 *  记录上次压盖的meshid
 */

@property (nonatomic, strong)NSArray *oldMeshIds;

/**
 *  变化的meshId数量
 */
@property (nonatomic, strong)NSArray *changeMeshIds;

@property (nonatomic ,assign)BOOL timeNotChange;

/**画线*/
@property (nonatomic ,strong) CNMKPolyline *myPolyline;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
    [self setUpMapView];
    

}


/**
 *  把地图加入视图
 */
-(void)setUpMapView
{
    
    UIButton *button =[[UIButton alloc] init];
    button.frame =CGRectMake(40, 400, 50, 50);
    button.backgroundColor =[UIColor redColor];
    [button addTarget:self action:@selector(showRoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    //创建check时间的变化的观察者
    [self.mapView addObserver:self forKeyPath:@"changeJamTimer" options: NSKeyValueObservingOptionNew|
     NSKeyValueObservingOptionOld context:nil];

    
}

/**
 *  懒加载并初始化地图
 */
-(CNMKMapView *)mapView
{
    if (_mapView ==nil) {
        
        CGFloat width =[[UIScreen mainScreen] bounds].size.width;
        CGFloat height =[[UIScreen mainScreen] bounds].size.height;
        _mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _mapView.delegate= self;
        _mapView.mapType = CNMKMapTypeStandard;
        [_mapView setZoomLevel:17];
        _changeMapLevel  =[self.mapView getZoomLevel];
        
        [_mapView setShowsUserLocation:YES];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoUserLoc];
            [self ImportSdk];


        });
        
        }
    
    return _mapView;
}


/**
 *  获取用户位置
 */
- (void)gotoUserLoc{
    
    
    if (0.001 > fabs(CLUserPoint.latitude) || 0.001 > fabs(CLUserPoint.longitude))
    {
        return;
    }
    [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(CLUserPoint)];
    
    
}




#pragma mark - 外部控制路况加载 

/**
 *   滑动加载路况
 */

- (void)mapViewDidEndDragging:(CNMKMapView *)mapView willDecelerate:(BOOL)decelerate
{
    
   
    [self ImportSdk];
    
    
    
    
}


//实时获取地图比例尺
- (void)mapViewDidZooming:(CNMKMapView *)mapView
{
  
    _changeMapLevel =mapView.getZoomLevel;
  
    
    // [self addRaditionView:_changeMapLevel];
    [self ImportSdk];
    
}





/**
 * mesh计算队列懒加载
 */
-(NSOperationQueue *)meshQeue
{
    if (!_meshQeue)
    {
        _meshQeue=[[NSOperationQueue alloc]init];
        
        [_meshQeue setMaxConcurrentOperationCount:5];
        
    }
    return _meshQeue;
    
}






/**
 *  把相关信息告诉SDK
 */
-(void)ImportSdk
{
//    if (self.changeMapLevel<10) return;
//    
//    [self.meshQeue addOperationWithBlock:^{
//        NSDictionary *jamState=[self changeCoordinateWithCenterCoordinate:[self.mapView centerCoordinate]];
//        if(self.changeMapLevel !=9){
//            NSArray *arr =  [self getMeshList:jamState];
//            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.oldMeshIds];
//            //过滤数组
//            NSArray * reslutFilteredArray = [arr filteredArrayUsingPredicate:filterPredicate];
//            if (self.timeNotChange) {
//                if (reslutFilteredArray.count==0) return;
//            }
//               self.changeMeshIds=reslutFilteredArray;
//            
//            self.oldMeshIds=arr;
//        }
//          if (self.changeMapLevel==0) self.changeMapLevel =17;
//        
//        NSString *JamLevel;
//        
//        if (self.changeMapLevel == 10 || self.changeMapLevel == 11)
//        {
//            JamLevel =@"11" ;
//        }
//        else if(self.changeMapLevel == 12)
//        {
//            JamLevel=@"12";
//        }
//        else if (self.changeMapLevel == 13 || self.changeMapLevel == 14)
//        {
//            JamLevel = @"14";
//        }
//        else
//        {
//            JamLevel = @"17";
//        }
//        
//        self.timeNotChange =YES;
//        
//        
//        [self.mapView jamStateDic:jamState mapLevels:JamLevel changeMeshIdArr:self.changeMeshIds];
//        
//    }];
    
    
}



/**
 *  通过中心点获取屏幕左下右上信息
 *
 *  @param centerCoordinate 中心点经纬度
 *
 *  @return 包含左下右上经纬度的数据字典
 */
- (NSDictionary *)changeCoordinateWithCenterCoordinate:(CNMKGeoPoint)centerCoordinate{
    
    CGPoint centerPoint = [self.mapView lnglatToPixel:CNMKGeoPointMake(centerCoordinate.longitude,centerCoordinate.latitude) toPointToView:self.view];
    
    
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    CGPoint leftDownPoint = CGPointMake(centerPoint.x-width/2, centerPoint.y+height/2);
    CGPoint rightTopPoint = CGPointMake(centerPoint.x+width/2, centerPoint.y-height/2);
    
    
    CNMKGeoPoint leftDownLngLatPoint = [self.mapView pixelToLngLat:leftDownPoint toCoordinateFromView:self.view];
    CNMKGeoPoint rightTopLngLatPoint = [self.mapView pixelToLngLat:rightTopPoint toCoordinateFromView:self.view];
    
    
    NSDictionary *dic = @{@"leftDownLng":@(leftDownLngLatPoint.longitude),
                          @"leftDownLat":@(leftDownLngLatPoint.latitude),
                          @"rightTopLng":@(rightTopLngLatPoint.longitude),
                          @"rightTopLat":@(rightTopLngLatPoint.latitude)
                          };
    
    return dic;
}


/**
 *  计算获得meshId列表
 *
 *  @param dic 左下右上经纬度的数据字典
 *
 *  @return mesh
 */
-(NSArray *)getMeshList:(NSDictionary *)dic
{
    
    NSMutableArray *meshList=[NSMutableArray array];
    
    
    int meshLD = [self findGridLongitude:[dic[@"leftDownLng"]doubleValue]  Latitude:[dic[@"leftDownLat"]doubleValue]];
    int meshLT =[self findGridLongitude:[dic[@"leftDownLng"]doubleValue]  Latitude:[dic[@"rightTopLat"]doubleValue]];
    
    int meshRD = [self findGridLongitude:[dic[@"rightTopLng"]doubleValue]  Latitude:[dic[@"rightTopLat"]doubleValue]]; 
    
   
    if ((meshLT - meshLT / 100 * 100) / 10 == 7) {
        meshLT += 10000;
        meshLT = meshLT / 100 * 100 + (meshLT - meshLT / 10 * 10);
    } else {
        meshLT += 10;
    }
    
    int tmpLU = meshLD;
    int iLU = (meshLD - meshLD / 100 * 100) / 10;
    int tmpLD = meshLD;
    
    [meshList addObject:[NSNumber numberWithInt:meshLD]];
    while (true) {
        tmpLD = tmpLU;
        int iLD = tmpLD - tmpLD / 10 * 10;         if (meshLD != meshRD) {
            while (true) {
                iLD++;
                if (iLD == 8) {
                    iLD = 0;
                    tmpLD += 100;
                    tmpLD = tmpLD / 10 * 10;
                } else {
                    tmpLD += 1;
                }
                
                
                if (tmpLD-meshRD > 0) {
                    
                    return meshList;
                }
                
                [meshList addObject:[NSNumber numberWithInt:tmpLD]];
              
                if (tmpLD == meshRD) {
                  
                    if ((meshRD - meshRD / 100 * 100) / 10 == 7) {
                        meshRD += 10000;
                        meshRD = (meshRD / 100 * 100)
                        + (meshRD - meshRD / 10 * 10);
                    } else {
                        meshRD += 10;
                    }
                    break;
                }
            }
        }
        
        iLU++;
        if (iLU == 8) {
            iLU = 0;
            tmpLU += 10000;
            tmpLU = (tmpLU / 100 * 100) + (tmpLU - tmpLU / 10 * 10);
        } else {
            tmpLU += 10;
        }
        
        if (tmpLU == meshLT) {
            break;
        }
        if (tmpLU-meshLT > 0) {
           
        }
        [meshList addObject:[NSNumber numberWithInt:tmpLU]];
    }
    return meshList;
 }


/**
 *  通过经纬度获得2次网格
 *
 *  @param lon 纬度
 *  @param lat 经度
 *
 *  @return meshId
 */
-(int)findGridLongitude:(double)lon Latitude:(double)lat
{
    int xx = (int) (lon - 60);
    int yy = (int) (lat * 60 / 40);
    int x = (int) ((lon - (int) lon) / 0.125);
    int y = (int) (((lat * 60 / 40 - yy)) / 0.125);
    return yy * 10000 + xx * 100 + y * 10 + x;
    
}


/**
 *  时间戳观察者
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
      self.timeNotChange =NO;
    
    
    [self ImportSdk];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView refreshTMC];
        
    });
    
}

- (void)showRoad
{
  
    NSArray * textPoint =@[@"123.433052,41.802639",
                           @"123.433334,41.803020",
                           @"123.433441,41.803020",
                           @"123.433640,41.803013",
                           @"123.433998,41.802998",
                           @"123.433998,41.802998",
                           @"123.434486,41.802361",
                           @"123.434563,41.802021",
                           @"123.434586,41.801651",
                           @"123.434334,41.800911",
                           @"123.433975,41.800537",
                           @"123.433296,41.800171",
                           @"123.433151,41.799950",
                           @"123.433151,41.799950",
                           @"123.433525,41.799408",
                           @"123.433525,41.799408",
                           @"123.433426,41.799408",
                           @"123.433098,41.799408",
                           @"123.432686,41.799469",
                           @"123.431694,41.799686",
                           @"123.431564,41.799721",
                           @"123.431053,41.799816",
                           @"123.430206,41.799999",
                           @"123.429565,41.800148",
                           @"123.429497,41.800007",
                           @"123.430153,41.799862",
                           @"123.431000,41.799679",
                           @"123.431000,41.799679",
                           @"123.431023,41.799603",
                           @"123.431305,41.799248",
                           @"123.431351,41.798721",
                           @"123.431580,41.798733",
                           @"123.431580,41.798733",
                           @"123.431595,41.798580",
                           @"123.431633,41.798351",
                           @"123.431755,41.797470",
                           @"123.431831,41.796909",
                           @"123.431953,41.796051",
                           @"123.432060,41.795269",
                           @"123.432220,41.794239",
                           @"123.432274,41.793941",
                           @"123.432396,41.793518",
                           @"123.432571,41.792961",
                           @"123.432831,41.792301",
                           @"123.432884,41.792179",
                           @"123.432899,41.792110"];
    
    
    
    
    CNMKGeoPoint *points = (CNMKGeoPoint*)malloc(sizeof(CNMKGeoPoint)*(textPoint.count));
    
     CNMKGeoPoint *tempPoints = points;
    for (NSInteger i = 0; i < textPoint.count; i++) {
        
        NSString *str = textPoint[i];
    
        NSArray *temp = [str componentsSeparatedByString:@","];
        
        for (int j=0; j<temp.count; j++) {
            
            (*tempPoints).longitude = [temp[0] doubleValue];
            
            (*tempPoints).latitude =[temp[1] doubleValue];
            tempPoints++;
         }
        
        
        
        
        
        
        self.myPolyline = [CNMKPolyline polylineWithGeoPoints:points count:textPoint.count];
       [self.mapView addOverlay:self.myPolyline];
     
        free(points);
    }
    
    
}




/**
 *  销毁
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kRoadConditionTimer object:nil];
    [self.mapView removeMapObjects];
    self.mapView.delegate =nil;

}


@end
