//
//  ViewController.m
//  MapBoxText
//
//  Created by 刘博通 on 16/8/2.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <Mapbox/Mapbox.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;

@end

@implementation ViewController
{
    CLLocationManager *_locationManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}
//-(void) createLocationManager{
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//    if ([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
//        [_locationManager setAllowsBackgroundLocationUpdates:YES];
//    }
//    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//    _locationManager.pausesLocationUpdatesAutomatically = NO;
//}




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
    // Dispose of any resources that can be recreated.
}

@end
