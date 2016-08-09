//
//  CNMKOverlay.h
//  cennavimapapi
//
//  Created by Lion on 13-3-24.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import "CNMKGeometry.h"

@protocol CNMKOverlay <NSObject>

@property (nonatomic) CNMKGeoPoint *points;     //...Overlay点集
@property (nonatomic) int pointCount;           //...Overlay点数量
@property (nonatomic) BOOL encrypted;           //...Overlay点是否已加密（默认已加密）

@end

@protocol CNMKAnnotationOverlay <NSObject>

@property (nonatomic) CNMKGeoPoint coordinate;  //...标注坐标点
@property (nonatomic) BOOL encrypted;           //...Overlay点是否已加密（默认已加密）

@end