//
//  GC02-WC84.h
//  MapBoxText
//
//  Created by 刘博通 on 16/8/9.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GC02_WC84 : NSObject

+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;

@end
