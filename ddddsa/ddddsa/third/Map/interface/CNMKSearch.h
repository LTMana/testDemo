//
//  CNMKSearch.h
//  cennavimapapi
//
//  Created by Lion on 13-3-13.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//


#import "CNMKGeometry.h"


@class CNMKSearchInternal;
@protocol CNMKSearchDelegate;

//...途径点
typedef struct __midPoints
{
    double Longitude;
    double Latitude;
}midPoints_t;
//...驾车API的参数结构体Base
typedef struct __driving
{
    CNMKGeoPoint StartPoint;        //...开始点坐标
    CNMKGeoPoint EndPoint;          //...结束点坐标
    NSInteger midPointCnt;          //...共多少个途径点
    midPoints_t midPoints[50];      //...最多支持50
    
    CNMKGeoPoint ServerPoints[5000]; //...返回结果点
    
}driving_t;
driving_t gstu_driving;

@interface CNMKSearch : NSObject
{
	id<CNMKSearchDelegate> _delegate;
	int _busPolicy;
	int _routingPolicy;
}

@property (nonatomic, retain) id<CNMKSearchDelegate> delegate;
//...公交检索策略
@property (nonatomic) int busPolicy;
//...驾乘检索策略
@property (nonatomic) int routingPolicy;


//...POI查询
//...POI城市关键字查询
- (BOOL)poiSearchInCity:(NSString*)cityCode types:(NSString*)types searchType:(NSString*)searchType dataType:(NSString*)dataType language:(NSInteger)language pageCount:(NSInteger)pageCount pageNumber:(NSInteger)pageNumber;

//...POI周边圆形查询
- (BOOL)poiCircleSearch:(NSString*)cityCode centerPoint:(CNMKGeoPoint)point radius:(NSInteger)radius types:(NSString *)types searchType:(NSString*)searchType dataType:(NSString*)dataType language:(NSInteger)language pageCount:(NSInteger)pageCount pageNumber:(NSInteger)pageNumber inRadius:(NSInteger)inRadius sortMethod:(NSInteger)sortMethod;

//...POI矩形范围查询、dataType：如汽车、餐饮
- (BOOL)poiRectangleSearch:(NSString*)cityCode withRect:(CNMKGeoRectNew)rect types:(NSString*)types searchType:(NSString*)searchType dataType:(NSString*)dataType language:(NSInteger)language pageCount:(NSInteger)pageCount pageNumber:(NSInteger)pageNumber;

//...公交路线查询    time格式：HH:MM
- (BOOL)busSearchInCity:(NSString *)city startPoint:(CNMKGeoPoint)startPoint endPoint:(CNMKGeoPoint)endPoint
                   time:(NSString *)time;

//...驾车路线查询
//...directionIconStatus 0表示显示驾车方向图标、1表示不显示驾车方向图标
- (BOOL)drivingSearch:(CNMKGeoPoint)StartPoint EndPoint:(CNMKGeoPoint)EndPoint iCostModel:(NSInteger)iCostModel iCriterial:(NSInteger)iCriterial language:(NSInteger) language bear:(NSInteger)bear vehiclespeed:(NSInteger)vehiclespeed directionIconStatus:(NSInteger)directionIconStatus;

//...驾车路线查询(带路况)
//...directionIconStatus 0表示显示驾车方向图标、1表示不显示驾车方向图标
- (BOOL)drivingSearchTraffic:(CNMKGeoPoint)StartPoint EndPoint:(CNMKGeoPoint)EndPoint iCostModel:(NSInteger)iCostModel iCriterial:(NSInteger)iCriterial language:(NSInteger) language bear:(NSInteger)bear vehiclespeed:(NSInteger)vehiclespeed directionIconStatus:(NSInteger)directionIconStatus ArrivalTime:(NSString *)arrivaltime DepartureTime:(NSString *)departuretime;

//...POI支持城市
- (NSArray *)poiCityList;

//...POI支持类型
- (NSArray *)poiTypeList;

//...公交路线支持城市
- (NSArray *)busCityList;

@end


//...搜索delegate，用于获取搜索结果
@protocol CNMKSearchDelegate<NSObject>
@optional
//...返回坐标点所在城市
- (void)onGetCity:(NSString *)city forLocation:(CNMKGeoPoint)location errorCode:(int)errorCode;

/*
 *返回POI搜索结果
 *@param poiResultList 搜索结果列表，成员类型为CNMKPoiResult
 *@param type 返回结果类型： CNMKTypePoiList,CNMKTypeAreaPoiList,CNMKAreaMultiPoiList
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetPoiResult:(NSArray*)result searchType:(int)type errorCode:(int)error;

/*
 *返回公交搜索结果
 *@param result 搜索结果
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetBusResult:(id)result errorCode:(int)error;

/*
 *返回驾乘搜索结果
 *@param result 搜索结果
 *@param error 错误号，@see CNMKErrorCode
 */
- (void)onGetRoutingResult:(id)result errorCode:(int)error;

@end
