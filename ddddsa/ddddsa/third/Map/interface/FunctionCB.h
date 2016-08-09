//...定义协议
#import <UIKit/UIKit.h>
#import "CNMKSearchType.h"

@protocol NoteCBDelegate
//...回调函数
//...驾车
-(void)getSDKDrintMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...POI信息
-(void)getSDKMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...所有省列表
-(void)getSDKAllProvinceListMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...地址，门址
-(void)getSDKAddressMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...取行政区代码名称给用户
-(void)getSDKAdminbypointMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...查询点最近的门址或poi数据
-(void)getSDKAReverSegeocodMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...查询地标，路口，大厦，门址等信息
-(void)getSDKPoiaroundMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...返给用户的回调函数
-(void)POIRectangleSearchCB:(NSString *)FunctionName id2:(CNMKPoiResult*)DicGetString id3:(NSInteger)Error;
//...用于返回搜索结果后的最大点与最小点的坐标，通过这2个坐标进行地图自动缩放
-(void)POISearchZoomLevelCB:(NSString *)FunctionName id2:(CNMKGeoPoint)MaxPpint id3:(CNMKGeoPoint)MinPpint id4:(NSInteger)Error;

//...获取指定省列表
-(void)getSDKProvinceListMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...获取指定省的城市
-(void)getSDKCityListMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...获取指定省的城市->区
-(void)getSDKAreaListMsgCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...长按地图返给用户的回调函数
-(void)handleMapViewLongPressedCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...单击大头针回调
-(void)pinIconClickedCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...单击驾车结果中的方向图标回调
-(void)directionIconClickedCB:(NSString *)FunctionName id2:(NSString*)DicGetString id3:(NSInteger)Error;

//...获取用户设置GPS坐标最近POI点的信息
-(void)getSDKPoiMessageCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;

//...轨迹泡泡的回调函数
-(void)getSDKTrackMessageCB:(NSString *)FunctionName id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error;


//...获取画驾车路线的各点
-(void)getSDKDrawPointsCB:(NSString *)FunctionName id2:(CNMKGeoPoint*)PointsGPS id3:(NSInteger)PointsCount;

//...获取画驾车路线的各点(带路况)
-(void)getSDKDrawPointsCBTraffic:(NSString *)FunctionName id2:(CNMKGeoPoint*)PointsGPS id3:(NSInteger)PointsCount id4:(NSArray *)jamcodes;

//...单击泡泡回调
//-(void)pinPopoClickedCB:(NSString *)FunctionName id2:(CNMKPoiResult*)DicGetString id3:(NSInteger)Error;

@end
