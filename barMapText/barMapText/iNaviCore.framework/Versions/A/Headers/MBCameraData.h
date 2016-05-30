//
//  MBCameraData.h
//  iNaviCore
//
//  Created by fanwei on 4/12/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import "MBObject.h"
/**
 *  摄像头类型
 */
typedef enum MBCameraType
{
    // 请勿更改此顺序
    MBCameraType_none = 0,
    MBCameraType_speed = 1,							/// 限速摄像头
    MBCameraType_light = 2,							/// 红绿灯照相
    MBCameraType_roadCondition = 3,					/// 路况监控摄像头(deprecate)
    MBCameraType_radar = 4,							/// 雷达测速摄像头(deprecate)
    MBCameraType_onewayStreet = 5,					/// 单行线摄像头(deprecate)
    MBCameraType_bicycle = 6,							/// 非机动车道摄像头
    MBCameraType_highSpeed = 7,						/// 高速出入口摄像头(deprecate)
    MBCameraType_bus = 8,								/// 公交车道摄像头
    MBCameraType_turnForbidden = 9,					/// 禁止左右转摄像头(deprecate)
    MBCameraType_mobile = 10,							/// 移动式测速摄像头(deprecate)
    MBCameraType_redLight = 11,						/// 红绿灯照相(deprecate)
    MBCameraType_monitor = 12,						/// 电子监控
    MBCameraType_areaSpeedingBegin = 13,
    MBCameraType_areaSpeedingEnd = 14,
    MBCameraType_cameraMax = 50,						/// 摄像头标识
    MBCameraType_serviceArea = 51,					/// 服务区
    MBCameraType_toll = 52,							/// 收费站
    MBCameraType_tunnel = 53,							/// 隧道
    MBCameraType_trfcSign = 100,						/// 交通信号标识
    MBCameraType_sharpLeftCurve = 101,				/// 向左急弯路
    MBCameraType_sharpRightCurve = 102,				/// 向右急弯路
    MBCameraType_reverseCurve = 103,					/// 反向弯路(左)
    MBCameraType_windingRoad = 104,					/// 连续弯路
    MBCameraType_steepAscent = 105,					/// 上陡坡
    MBCameraType_steepDecent = 106,					/// 下陡坡
    MBCameraType_roadNarrowsFromBothSides = 107,		/// 两侧变窄
    MBCameraType_roadNarrowsFromTheRight = 108,		/// 右侧变窄
    MBCameraType_roadNarrowsFromTheLeft = 109,		/// 左侧变窄
    MBCameraType_narrowBridge = 110,					/// 窄桥
    MBCameraType_twowayTraffic = 111,					/// 双向交通
    MBCameraType_childrenCrossing = 112,				/// 注意儿童
    MBCameraType_cattleCrossing = 113,				/// 注意牲畜
    MBCameraType_fallingRocksOnTheLeft = 114,			/// 注意左落石
    MBCameraType_fallingRocksOnTheRight = 115,		/// 注意右落石
    MBCameraType_crosswinds = 116,					/// 注意横风
    MBCameraType_slipperyRoad = 117,					/// 易滑
    MBCameraType_hillsOnTheLeft = 118,				/// 左侧傍山险路
    MBCameraType_hillsOnTheRight = 119,				/// 右侧傍山险路
    MBCameraType_embankmentOnTheRight = 120,			/// 右侧堤坝路
    MBCameraType_embankmentOnTheLeft = 121,			/// 左侧堤坝路
    MBCameraType_village = 122,						/// 村庄
    MBCameraType_humpbackBridge = 123,				/// 驼峰桥
    MBCameraType_unevenRoadSurface = 124,				/// 路面不平
    MBCameraType_roadFloods = 125,					/// 过水路面
    MBCameraType_guardedRailroadCrossing = 126,		/// 有人看守铁路道口
    MBCameraType_unguardedRailroadCrossing = 127,		/// 无人看守铁路道口
    MBCameraType_highAccidentArea = 128,				/// 事故易发路段
    MBCameraType_passLeftOrRightOfObstacle = 129,		/// 左右绕行
    MBCameraType_passLeftOfObstacle = 130,			/// 左侧绕行
    MBCameraType_passRightOfObstacle = 131,			/// 右侧绕行
    MBCameraType_dangerAhead = 132,					/// 注意危险
    MBCameraType_noOvertaking = 133,					/// 禁止超车
    MBCameraType_overtakingAllowed = 134,				/// 解除禁止超车
    MBCameraType_audibleWarning = 135,				/// 鸣喇叭
    MBCameraType_continuousDecent = 136,				/// 连续下坡
    MBCameraType_textWarning = 137,					/// 文字性警示标牌
    MBCameraType_confluenceFromLeft = 138,			/// 注意左侧合流
    MBCameraType_confluenceFromRight = 139,			/// 注意右侧合流
    ///(以下类型为四维12夏新增)
    MBCameraType_stopToGiveWay = 140,					/// 停车让行
    MBCameraType_joinToGiveWay = 141,					/// 会车让行
    MBCameraType_decelerationToGiveWay = 142,			/// 减速让行
    MBCameraType_tunnelToLight = 143,					/// 隧道开灯
    MBCameraType_tideRoad = 144,						/// 潮汐车道
    MBCameraType_convexRoad = 145,					/// 路面高凸
    MBCameraType_hollowRoad = 146,					/// 路面低洼
    ///(以下类型为四维12冬新增)
    MBCameraType_reverseCurveRight = 147,				/// 反向弯路(右)
    MBCameraType_max = 148
} MBCameraType;

/**
 *  摄像头数据
 */
@interface MBCameraData : MBObject
/**
 *  电子眼所在位置的经纬度坐标
 */
@property (assign,nonatomic) MBPoint position;
/**
 *  电子眼类型
 */
@property (assign,nonatomic) MBCameraType type;
/**
 *  从路线起点到该电子眼的距离，单位：米
 */
@property (assign,nonatomic) int absDistance;
/**
 *  电子眼角度
 */
@property (assign,nonatomic) short angle;
/**
 *  电子眼的限速值，单位：公里/小时。如果没有限速值，则为 0
 */
@property (assign,nonatomic) unsigned short	speedLimit;
/**
 *  是否为违章高发电子眼
 */
@property (assign,nonatomic) BOOL isDanger;
/**
 *  当前电子眼到车的距离
 */
@property (assign,nonatomic) int distance;
/**
 *  是否用户电子眼
 */
@property (assign,nonatomic) BOOL isUserCamera;
/**
 *  当前电子眼播报过的次数
 */
@property (assign,nonatomic) unsigned int broadcastedTimes;
/**
 *  在前方区域内, 未检测到此摄像头的次数
 */
@property (assign,nonatomic) int unChecked;
/**
 *  播报时的距离,主要用来计算进度条
 */
@property (assign,nonatomic) int reportDistance;
/**
 *  数据的优先级, 数据排序时使用
 */
@property (assign,nonatomic) int priority;
@end
