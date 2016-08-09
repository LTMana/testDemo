//
//  CNMKMapView.h
//  cennavimapapi
//
//  Created by Lion on 13-3-15.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CNMKTypes.h"
#import "CNMKGeometry.h"
#import "CNMKOverlay.h"
#import "CNMKOverlayView.h"
#import "CNMKAnnotation.h"
#import "CNMKAnnotationView.h"
#import "CNMKSearchType.h"
#import "FunctionCB.h"
#import "CNMKShape.h"

//...自定义图标，设置成nil或删除都表示采用系统默认图标
NSString *customLocateIcon;             //...自定义定位图标
NSString *customDirectionIcon;          //...自定义方向图标
NSString *customDrivingEndIcon;         //...自定义驾车结束图标
NSString *customDrivingStartIcon;       //...自定义驾车开始图标
NSString *customPinIcon;                //...自定义大头针图标

NSInteger typesLanguage;                //...0表示中文，1表示英文
NSString   *adCodeLevel1;               //...使用这个来拆分分类字符串
NSString   *adCodeLevel2;               //...使用这个来拆分分类字符串

typedef struct _lineAttribute
{
    double colorR;
    double colorG;
    double colorB;
    double alpha;
    NSInteger lineWidth;
}lineAttribute;

@class CNMKMapViewInternal;
@class CNMKOverlayView;
@protocol CNMKMapViewDelegate;
@protocol CNMKOverlay;

@class CNMKMapViewInternal;

@interface CNMKMapView : UIView <UIGestureRecognizerDelegate>
{
    id<NoteCBDelegate> noteDelegate;          //...代理
    @private
        CNMKMapViewInternal *_internal;
        NSInteger _lineWidth;    //...线宽
        double _colorR;
        double _colorG;
        double _colorB;
        double _alpha;
    
    
    int tem;
    int test_count;
}

/**
 *  路况时间变化
 */
@property (nonatomic, copy)NSString *changeJamTimer;
//...地图View的Delegate
@property (nonatomic, assign) id<CNMKMapViewDelegate> delegate;
//...当前地图类型，可设定为普通模式或实时路况模式
@property (nonatomic) CNMKMapType mapType;
//...当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
@property (nonatomic) CNMKGeoRect region;
//...地图比例尺级别
@property (nonatomic) NSInteger getZoomLevel;
//...当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CNMKGeoPoint centerCoordinate;
@property (nonatomic,retain) id<NoteCBDelegate> gNoteCBDelegate;
@property (nonatomic) BOOL isShowStartIcon; //...是否显示起点图标
@property (nonatomic) BOOL isShowEndIcon;   //...是否显示终点图标


- (id)initWithFrame:(CGRect)frame;


/**
 *  获取主屏幕的一些必要信息
 *
 *  @param jamStateDic   左下右上经纬度点
 *  @param mapLevels     实时比例尺
 *  @param changeMeshIdarr 边际添加的meshId
 * ..............................by liubotong
 */
-(void)jamStateDic:(NSDictionary *)jamStateDic mapLevels:(NSString *)mapLevels changeMeshIdArr:(NSArray *)changeMeshIdarr;







/**************************************************
 * 根据传递的驾车线路点向地图描画驾车线路
 * @param polyLine 折线类实例
 * @param lineWidth 驾车线路的线宽
 * @param color 红色
 * @param color 绿色
 * @param color 蓝色
 * @param alpha 透明度
 *************************************************/
- (void)driveLineDraw:(CNMKPolyline*)polyLine lineWidth:(NSInteger)lineWidth colorR:(double)colorR colorG:(double)colorG colorB:(double)colorB alpha:(double)alpha;

/**************************************************
 * 根据传递的驾车线路点向地图描画驾车线路(带路况)
 * @param polyLine 折线类实例
 * @param smoothState 畅通状态属性
 * @param slowState 缓慢状态属性
 * @param jameState 拥堵状态属性
 *************************************************/
- (void)driveLineDrawTraffic:(CNMKPolyline*)polyLine smooth:(lineAttribute*)smoothState slow:(lineAttribute*)slowState jams:(lineAttribute*)jameState;

/**************************************************
 * 设定地图中心点坐标
 * @param coordinate 要设定的地图中心点坐标，用经纬度表示
 * @param animated   是否采用动画效果
 *************************************************/
- (void)setCenterCoordinate:(CNMKGeoPoint)coordinate animated:(BOOL)animated;

/**************************************************
 * 地图比例尺级别，在手机上当前可使用的级别
 * @param zoomLevel 级别为3-18级(百度也是3-18级)
 *************************************************/
- (void)setZoomLevel:(int)a_zoomLevel;

/**************************************************
 * 根据传递来的2个坐标点，自动以最合适地显示这2个点
 * @param lnglat1 第1点坐标
 * @param lnglat2 第2点坐标
 * @param view point坐标所在的view
 *************************************************/
- (void)autoZoomMap:(CNMKGeoPoint)lnglat1 lnglat2:(CNMKGeoPoint)lnglat2 toCoordinateFromView:(UIView *)view;


/**************************************************
 * 放大一级比例尺
 * @return 是否成功
 *************************************************/
- (BOOL)zoomIn;


/**************************************************
 * 缩小一级比例尺
 * @return 是否成功
 *************************************************/
- (BOOL)zoomOut;

/**************************************************
 * 改变地图大小
 * @return 是否成功
 *************************************************/
- (BOOL)setMapSize:(double)x y:(double)y width:(double)width height:(double)height;

/**************************************************
 * 隐藏AnnotationPop
 * @return 是否成功
 *************************************************/
- (id)HiddenAnnotationPop:(id<CNMKAnnotationOverlay>)annotation;

/**************************************************
 * 隐藏全部的AnnotationPop
 * @return 是否成功
 *************************************************/
- (id)HiddenAnnotationPopAll;

/**************************************************
 * 设置地图语言
 * 0 中0文
 * 1 英文
 * @return 是否成功
 *************************************************/
- (BOOL)setMapLangue:(NSInteger)language;

/**************************************************
 * 刷新地图
 *************************************************/
- (BOOL)refreshTMC;

/**************************************************
 * 得到当前屏中心点地图上的坐标
 * @return 是否成功
 *************************************************/
- (CNMKGeoPoint)getMapCenter;

/**************************************************
 * 得到当前用户显示级别
 * @return 比例尺级别
 *************************************************/
- (NSInteger)getZoomLevel;

/**************************************************
 * 显示与隐藏比例尺
 * @return 是否成功
 *************************************************/
- (BOOL)displayZoomControls:(BOOL)a_showState scaleX:(NSInteger)scaleX scaleY:(NSInteger)scaleY fontSize:(NSInteger)fontSize scaleLineWidth:(NSInteger)scaleLineWidth;




/**************************************************
 * 长按地图事件
 * timer 响应时间（默认1秒），单位秒m，可输入小数，如0.5就是半秒
 * @return 返回值
 *************************************************/
- (BOOL)handleLongPressMap:(double)timer;


/**************************************************
 * 获取行政区代码名称
 * dlongitude 经度
 * dlatitude 纬度
 * @return 返回值
 *************************************************/
- (BOOL)adminbypoint:(double)dlongitude dlatitude:(double)dlatitude language:(NSInteger)language;



/**************************************************
 * 清除地图缓存
 * @return 返回值
 *************************************************/
-(void)removeMapObjects;

//...当前地图范围，采用直角坐标系表示，向右向下增长
@property (nonatomic, readonly) CNMKScrRect visibleMapRect;
//...设定地图View能否支持用户多点缩放
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
//...设定地图View能否支持用户移动地图
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
//...设定是否显示定位图层
@property (nonatomic) BOOL showsUserLocation;
//...当前用户位置，返回坐标为加密坐标
@property (nonatomic, readonly) CNMKLocation *userLocation;
//...返回定位坐标点是否在当前地图可视区域内
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

@end


#pragma mark Annotation
@interface CNMKMapView (Annotation)

/**************************************************
 * 向地国中添加视图
 * @param annotation 要添加的层标注
 * @param viewHande 视图句柄
 *************************************************/
- (void)addAnnotationView:(id <CNMKAnnotationOverlay>)annotation viewHande:(CNMKAnnotationView*)viewHande;

/**************************************************
 * 向地图窗口添加标注，需要实现CNMKMapViewDelegate的-mapView:viewForAnnotation:
    函数来生成标注对应的View
 * @param annotation 要添加的标注
 *************************************************/
- (void)addAnnotation:(id <CNMKAnnotationOverlay>)annotation viewHande:(UIView*)viewHande customIcon:(NSString*)customIcon;

/**************************************************
 * 移除标注
 * @param annotation 要移除的标注
 *************************************************/
- (void)removeAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**************************************************
 * 向地图窗口添加一组标注，需要实现CNMKMapViewDelegate的-mapView:viewForAnnotation:
    函数来生成标注对应的View
 * @param annotations 要添加的标注数组
 *************************************************/
- (void)addAnnotations:(NSArray *)annotations viewHande:(UIView*)viewHande;

/**************************************************
 * 移除一组标注
 * @param annotation 要移除的标注数组
 *************************************************/
- (void)removeAnnotations:(NSArray *)annotations;

//...当前地图View的已经添加的标注数组
@property (nonatomic, readonly) NSArray *annotations;

/**************************************************
 * 查找指定标注对应的View，如果该标注尚未显示，返回nil
 * @param annotation 指定的标注
 * @return 指定标注对应的View
 *************************************************/
- (CNMKAnnotationView *)viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**************************************************
 * 选中指定的标注，本版暂不支持animate效果
 * @param annotation 指定的标注
 * @param animated 本版暂不支持
 *************************************************/
- (void)selectAnnotation:(id <CNMKAnnotationOverlay>)annotation animated:(BOOL)animated;

/**************************************************
 * 取消指定的标注的选中状态，本版暂不支持animate效果
 * @param annotation 指定的标注
 * @param animated 本版暂不支持
 *************************************************/
- (void)deselectAnnotation:(id <CNMKAnnotationOverlay>)annotation animated:(BOOL)animated;

@end

#pragma mark Overlay
@interface CNMKMapView (Overlay)

/**************************************************
 * 向地图窗口添加Overlay，需要实现CNMKMapViewDelegate的-mapView:viewForOverlay:
    函数来生成标注对应的View
 * @param overlay 要添加的overlay
 *************************************************/
- (void)addOverlay:(id <CNMKOverlay>)overlay;

/**************************************************
 * 移除Overlay
 * @param overlay 要移除的overlay
 *************************************************/
- (void)removeOverlay:(id <CNMKOverlay>)overlay;

/**************************************************
 * 向地图窗口添加一组Overlay，需要实现CNMKMapViewDelegate的-mapView:viewForOverlay:
    函数来生成标注对应的View
 * @param overlays 要添加的overlay数组
 *************************************************/
- (void)addOverlays:(NSArray *)overlays;

/**************************************************
 * 移除一组Overlay
 * @param overlays 要移除的overlay数组
 *************************************************/
- (void)removeOverlays:(NSArray *)overlays;

//...当前mapView中已经添加的Overlay数组
@property (nonatomic, readonly) NSArray *overlays;

/**************************************************
 * 查找指定overlay对应的View，如果该View尚未创建，返回nil
 * @param overlay 指定的overlay
 * @return 指定overlay对应的View
 *************************************************/
- (CNMKOverlayView *)viewForOverlay:(id <CNMKOverlay>)overlay;

@end

#pragma mark Search Overlay
@interface CNMKMapView (SearchOverlay)

- (BOOL)setRoutingResult:(CNMKRoutingResult *)result;
- (void)removeRoutingResult;

@end


#pragma mark Convert
@interface CNMKMapView (Convert)

/**************************************************
 * 将经纬度坐标转换为屏幕坐标
 * @param coordinate 待转换的经纬度坐标
 * @param view 指定相对的屏幕View
 * @return 转换后的View坐标
 *************************************************/
- (CGPoint)lnglatToPixel:(CNMKGeoPoint)coordinate toPointToView:(UIView *)view;

/**************************************************
 * 将屏幕坐标转换成经纬度坐标
 * @param point 待转换的View坐标
 * @param view point坐标所在的屏幕view
 * @return 转换后的经纬度坐标
 *************************************************/
- (CNMKGeoPoint)pixelToLngLat:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**************************************************
 * 将经纬度矩形区域转换为View矩形区域
 * @param region 待转换的经纬度矩形
 * @param view 指定相对的View
 * @return 转换后的View矩形区域
 *************************************************/
- (CGRect)convertRegion:(CNMKGeoRect)region toRectToView:(UIView *)view;

/**************************************************
 * 将View矩形区域转换成经纬度矩形区域
 * @param rect 待转换的View矩形区域
 * @param view rect坐标所在的view
 * @return 转换后的经纬度矩形区域
 *************************************************/
- (CNMKGeoRect)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/**************************************************
 * 将直角地理坐标矩形区域转换为View矩形区域
 * @param mapRect 待转换的直角地理坐标矩形
 * @param view 指定相对的View
 * @return 转换后的View矩形区域
 *************************************************/
- (CGRect)convertMapRect:(CNMKScrRect)mapRect toRectToView:(UIView *)view;

/**************************************************
 * 将View矩形区域转换成直角地理坐标矩形区域
 * @param rect 待转换的View矩形区域
 * @param view rect坐标所在的view
 * @return 转换后的直角地理坐标矩形区域
 *************************************************/
- (CNMKScrRect)convertRect:(CGRect)rect toMapRectFromView:(UIView *)view;

@end

//...MapView的Delegate，mapView通过此类来通知用户对应的事件
@protocol CNMKMapViewDelegate <NSObject>
@optional

/**************************************************
 * 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 *************************************************/
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation;

/**************************************************
 * 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 *************************************************/
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotationView:(id <CNMKAnnotationOverlay>)annotation ivew:(CNMKAnnotationView*)ivew;

/**************************************************
 * 当mapView新添加annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 新添加的annotation views
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**************************************************
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 选中的annotation views
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didSelectAnnotationView:(CNMKAnnotationView *)view;

/**************************************************
 * 当取消选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 取消选中的annotation views
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didDeselectAnnotationView:(CNMKAnnotationView *)view;

/**************************************************
 * 在地图View将要启动定位时，会调用此函数
 * @param mapView 地图View
 *************************************************/
- (void)mapViewWillStartLocatingUser:(CNMKMapView *)mapView;

/**************************************************
 * 在地图View停止定位后，会调用此函数
 * @param mapView 地图View
 *************************************************/
- (void)mapViewDidStopLocatingUser:(CNMKMapView *)mapView;

/**************************************************
 * 用户位置更新后，会调用此函数
 * @param mapView 地图View
 * @param userLocation 新的用户位置
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didUpdateUserLocation:(CNMKLocation *)userLocation;

/**************************************************
 * 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;

/**************************************************
 * 当点击annotation view弹出的泡泡时，调用此接口
 * @param mapView 地图View
 * @param view 泡泡所属的annotation view
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView annotationViewForBubble:(CNMKAnnotationView *)view;

/**************************************************
 * 根据overlay生成对应的View
 * @param mapView 地图View
 * @param overlay 指定的overlay
 * @return 生成的覆盖物View
 *************************************************/
- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id <CNMKOverlay>)overlay;

/**************************************************
 * 当mapView新添加overlay views时，调用此接口
 * @param mapView 地图View
 * @param overlayViews 新添加的overlay views
 *************************************************/
- (void)mapView:(CNMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;

//...地图移动相关Delegate方法
#pragma mark - map move

/**************************************************
 * 地图移动
 * @param mapView 地图View
 *************************************************/
- (void)mapViewDidScroll:(CNMKMapView *)mapView;

/**************************************************
 * 开始拖拽地图
 * @param mapView 地图View
 *************************************************/
- (void)mapViewWillBeginDragging:(CNMKMapView *)mapView;

/**************************************************
 * 结束拖拽地图
 * @param mapView 地图View
 * decelerate 是否以动画
 *************************************************/
- (void)mapViewDidEndDragging:(CNMKMapView *)mapView willDecelerate:(BOOL)decelerate;

/**************************************************
 * 开始减速缓冲
 * @param mapView 地图View
 *************************************************/
- (void)mapViewWillBeginDecelerating:(CNMKMapView *)mapView;

/**************************************************
 * 结束减速缓冲
 * @param mapView 地图View
 *************************************************/
- (void)mapViewDidEndDecelerating:(CNMKMapView *)mapView;

/**************************************************
 * 比例尺变化，开始变化与结束变化
 * @param mapView 地图View
 *************************************************/
- (void)mapViewDidZooming:(CNMKMapView *)mapView;

/**************************************************
 * 开始缩放
 * @param mapView 地图View
 *************************************************/
- (void)mapViewWillBeginZooming:(CNMKMapView *)mapView;

/**************************************************
 * 通过长度获取当前比例尺
 * @param dist 长度
 *************************************************/
-(NSInteger)getZoomFromDist:(NSInteger)dist;

@end


