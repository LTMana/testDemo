//
//  CNMKAnnotation.h
//  cennavimapapi
//
//  Created by Lion on 13-3-28.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import "CNMKOverlay.h"

@interface CNMKAnnotation : NSObject <CNMKAnnotationOverlay>
{
    NSInteger tag;
    CNMKGeoPoint _coordinate;
    BOOL _encrypted;
    NSString *_title1;
    NSString *_subtitle;
	double longitude;       //...经度
	double latitude;		//...纬度
    NSString *msg1;         //...信息1
    NSString *msg2;         //...信息2
    NSString *msg3;         //...信息3
    NSString *msg4;         //...信息4
    NSString *msg5;         //...信息5
    NSString *msg6;         //...信息6
}

@property (nonatomic) CNMKGeoPoint coordinate;
@property (nonatomic) BOOL encrypted;
@property (nonatomic) NSInteger tag;
@property (nonatomic, copy) NSString *title1;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic, copy) NSString *msg1;
@property (nonatomic, copy) NSString *msg2;
@property (nonatomic, copy) NSString *msg3;
@property (nonatomic, copy) NSString *msg4;
@property (nonatomic, copy) NSString *msg5;
@property (nonatomic, copy) NSString *msg6;

+ (id)annotationWithCoordinate:(CNMKGeoPoint)coordinate;

@end
