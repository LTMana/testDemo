//
//  CNMKPinView.h
//  cennavimapapi
//
//  Created by Lion on 13-3-13.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import "CNMKAnnotationView.h"
#import "CNMKMapView.h"
typedef enum
{
    CNMKPinColorGreen = 0,
    CNMKPinColorPurple,
    CNMKPinColorRed,
} CNMKPinColor;

@interface CNMKPinView : CNMKAnnotationView
{
    NSMutableDictionary* dicPin;
}

@property (nonatomic) CNMKPinColor pinColor;

@end
