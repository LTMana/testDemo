//
//  ViewController.m
//  MapBoxText
//
//  Created by 刘博通 on 16/8/2.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "GC02-WC84.h"
#import "Mapbox.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()<CLLocationManagerDelegate,MGLMapViewDelegate>
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic,strong) NSArray *pointSet;
@property (nonatomic,strong)NSMutableArray *polyLineArr;
@end

@implementation ViewController
{
    CLLocationManager *_locationManager;
}


-(NSMutableArray *)polyLineArr
{
    if (_polyLineArr ==nil) {
        _polyLineArr =[NSMutableArray array];
    }
    
    return _polyLineArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setZoomLevel:14];
  
    self.mapView.delegate =self;
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(41.80288, 123.438937);
    [self.mapView setTargetCoordinate:point animated:YES];
    
    NSLog(@"%f , %f",  self.mapView.userLocation.location.coordinate.latitude,  self.mapView.userLocation.location.coordinate.longitude);
    
//    NSString *urlStr =@"mapbox://styles/ltmana/cird8mcdu0006gekob0wkq5yh";
//   _mapView =[[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[NSURL URLWithString:urlStr]];
//  _mapView =[[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:nil];
//    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(116.4074,39.9046)
//                       zoomLevel:10
//                        animated:YES];
//    
//    [_mapView sendSubviewToBack:self.view];
//    [self.view addSubview:_mapView];

    //[self createLocationManager];
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"level.plist" ofType:nil];

    self.pointSet =[NSArray arrayWithContentsOfFile:filePath];
}



/** 路况按钮 */
- (IBAction)roadCondition:(UIButton *)sender {
     sender.selected =!sender.selected;
    if (sender.selected) {
        for (int i=0; i<self.pointSet.count; i++) {
            
            
            NSArray *pointsArr =self.pointSet[i];
            //NSLog(@"执行次数%d",index);
            CLLocationCoordinate2D *GCpoints =(CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D)*(pointsArr.count));
            
            CLLocationCoordinate2D *WCpoints =(CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D)*(pointsArr.count));
            
            CLLocationCoordinate2D *tempPoints = GCpoints;
            
            CLLocationCoordinate2D *wcpoints = WCpoints;
            for (NSDictionary *lonWithLat in pointsArr) {
                
                
                (*tempPoints).longitude = [lonWithLat[@"lon"] doubleValue] *0.000001;
                
                (*tempPoints).latitude =[lonWithLat[@"lat"] doubleValue]*0.000001;
                *wcpoints =[GC02_WC84 gcj02ToWgs84:(*tempPoints)];
                
                
                tempPoints++;
                
                wcpoints ++;
                
            }
            
            MGLPolyline *polylineOverlay  =  [MGLPolyline polylineWithCoordinates:WCpoints count:pointsArr.count];
            
    
            [self.mapView addOverlay:polylineOverlay];
            
            free(WCpoints);
            free(GCpoints);
            
            [self.polyLineArr addObject:polylineOverlay];
    
        }
    }else{
        [self.mapView removeOverlays:self.polyLineArr];
    }
}



- (void)mapViewWillStartLocatingUser:(nonnull MGLMapView *)mapView

{
   
}


/** 卫星视图切换按钮 */
- (IBAction)changeWordMap:(UIButton *)sender {
    sender.selected =!sender.selected;
    
     NSString *urlStr =@"mapbox://styles/mapbox/satellite-v9";
    
    if (sender.selected) {
        self.mapView.styleURL =[NSURL URLWithString:urlStr];
    }else{
        self.mapView.styleURL=nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
