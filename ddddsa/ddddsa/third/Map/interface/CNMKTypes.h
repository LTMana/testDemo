//
//  CNMKTypes.h
//  cennavimapapi
//
//  Created by Lion on 13-3-12.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

enum
{
    CNMKMapTypeStandard = 0,	//...标准地图
    CNMKMapTypeTraffic          //...实时路况地图
};
typedef NSUInteger CNMKMapType;

typedef CLLocation CNMKLocation;
