//
//  MBNaviSession.h
//  iNaviCore
//
//  Created by fanwei on 2/21/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBEngine.h"
#import "MBRoutePlan.h"
#import "MBRouteBase.h"
#import "MBNaviSessionParams.h"
#import "MBRouteCollection.h"
#import "MBNaviSessionData.h"
#import "MBHighwayGuide.h"

#import "MBTmcReporter.h"
#import "MBNaviSpeaker.h"

typedef enum MBTmcRequest
{
    MBTmcRequest_updateRouteColors = 0x1,
    MBTmcRequest_unused = 0x2,
    MBTmcRequest_checkReroute = 0x4,
    MBTmcRequest_all = MBTmcRequest_updateRouteColors + MBTmcRequest_checkReroute
}MBTmcRequest;

typedef struct MBTmcOptions
{
    BOOL enableTmcReroute;//是否开启
    unsigned int rerouteCheckInterval;//算路间隔，单位：毫秒
    unsigned int routeColorUpdateInterval;
} MBTmcOptions;

/**
 *  初始化引擎后，已加载的电子眼数据状态
 */
typedef enum MBCameraDataState
{
    //电子眼数据加载失败，或未开启电子眼模块
    MBCameraDataState_none = 0,
    //已经加载的电子眼数据为VIP数据
    MBCameraDataState_vip = 1,
    //已经加载的电子眼数据为普通版数据
    MBCameraDataState_normal = 2
} MBCameraDataState;

/**
 *  算路失败后返回的错误类型
 */
typedef enum MBTRouterError {
    MBERouterError_None = 0,
    MBERouterError_OriDestTooNear = 1,    ///< 起点终点距离太近
    MBERouterError_SetOriFailed = 2,      ///< 设置起点失败，常见的原因是起点离道路很远，或者没有算路数据文件(.red)
    MBERouterError_SetDestFailed = 3,     ///< 设置终点失败，常见的原因是终点离道路很远
    MBERouterError_ComputeFailed = 4,     ///< 路线计算失败。如果是在线算路，则错误码会以字符串形式保存在 additionalMessage 中。
    MBERouterError_MissingSubfiles = 5,   ///< 某些省份的数据不存在或没有授权，省份的名称保存在 additionalMessage 中。
    MBERouterError_NotEnoughMemory = 6,   ///< 内存不足。
    MBERouterError_NetworkError = 7,      ///< 网络出错。在线算路时网络链接出错或服务器出错。
    
    MBERouterError_oriNoData = 8,         ///< 起点所在位置没有数据
    MBERouterError_destNoData = 9,        ///< 终点所在位置没有数据
    MBERouterError_waypointNoData = 10,   ///< 途经点所在位置没有数据
    
    MBERouterError_oriAuthError = 11,     ///< 起点所在位置数据授权错误
    MBERouterError_destAuthError = 12,    ///< 终点所在位置数据授权错误
    MBERouterError_waypointAuthError = 13,///< 途经点所在位置数据授权错误
    
    MBERouterError_illegalCall = 14,      ///< 不合理的调用接口导致的错误，如不支持步行离线算路的引擎中，调用离线步行
    
    MBERouterError_oriGuidMismatch = 15,     ///< 起点所在位置数据与基础数据(base.dat)不匹配
    MBERouterError_destGuidMismatch = 16,    ///< 终点所在位置数据与基础数据(base.dat)不匹配
    MBERouterError_waypointGuidMismatch = 17,///< 途经点所在位置数据与基础数据(base.dat)不匹配
    
    MBERouterError_baseDataInvalidOrMissing = 18 ///< 基础数据(base.dat)无效或不存在
    
} MBTRouterError;

/**
 *  防止掉头设置
 */
typedef enum MBAvoidUTurnMode
{
    //不防调头
    MBAvoidUTurnMode_disable = 0,
    //偏航多次后自动防掉头
    MBAvoidUTurnMode_auto,
    //一直防掉头(测试用，客户端一般不使用此值)
    MBAvoidUTurnMode_always,
}MBAvoidUTurnMode;

/**
 *  TMC播报失败对应的错误类型
 */
typedef enum MBTmcReportError
{
    MBTmcReportError_none = 0,
    MBTmcReportError_netFailed = 1,		/// Õ¯¬Á ß∞‹µº÷¬tmc≤•±® ß∞‹
} MBTmcReportError;

/**
 *  导航模式，主要控制算路的模式
 */
typedef enum MBNaviMode
{
    MBNaviMode_offline = 0,
    MBNaviMode_online = 1,
    MBNaviMode_auto = 2
} MBNaviMode;

/**
 *  导航开始时的语音播报模式，分为详细模式和简洁模式
 */
typedef enum MBNaviSessionNaviStartVoiceMode
{
    /** 详细模式 */
    MBNaviSessionNaviStartVoiceMode_detailed = 0,
    /** 简洁模式 */
    MBNaviSessionNaviStartVoiceMode_brief = 1,
    /**	PND 模式 */
    MBNaviSessionNaviStartVoiceMode_pnd = 2
} MBNaviSessionNaviStartVoiceMode;

typedef enum MBCamerFilterMode{
    MBCamerFilterMode_simple = 0,
    MBCamerFilterMode_standard,
    MBCamerFilterMode_all
}MBCamerFilterMode;

/**
 *  控制算路方式
 */
typedef enum MBNaviSessionRouteMethod {
    MBNaviSessionRouteMethod_single,        /// 算一条路
    MBNaviSessionRouteMethod_multipleRule,  /// 用“系统推荐”、“距离优先”、“高速优先”、“避让收费” 4种规则算出4条路线结果(其中可能有相同结果)，此时路线计划(RoutePlan)中的算路规则字段会被忽略。
    MBNaviSessionRouteMethod_multipleResult /// 用 MBRoutePlan 中的规则，尝试算多条路线结果(最终结果可能是1条~3条)
} MBNaviSessionRouteMethod;

@class MBNaviLaneCollection;


/** @protocol MBNaviSessionDelegate
 *
 *   导航回调函数
 *
 */
@protocol MBNaviSessionDelegate <NSObject>
@optional
/**
 *
 *   开始算路
 *
 */
- (void) naviSessionRouteStarted;

/**
 *
 *   开始偏航重计算
 *
 */
- (void) naviSessionRerouteStarted;
/**
 *  路线计算，完成
 *
 *  @param routes 算路结果集合
 *
 *  @since 4.9.x
 */
- (void) naviSessionResult:(MBRouteCollection*)routes;

/**
 *  偏航重计算完成
 *
 *  @param base 偏航后重新计算得到的路线
 *
 *  @since 4.9.x
 */
- (void) naviSessionRerouteComplete:(MBRouteBase *)base;

/**
 *  算路失败返回
 *
 *  @param errCode 失败错误码
 *  @param details 失败详情
 *
 *  @since 4.9.x
 */
- (void) naviSessionRouteFailed:(MBTRouterError)errCode moreDetails:(NSString*)details;
/**
 *  重算路失败
 *
 *  @param errCode 失败错误码
 *  @param details 失败详情
 *
 *  @since 4.9.x
 */
- (void) naviSessionRerouteFailed:(MBTRouterError)errCode moreDetails:(NSString*)details;
/**
 *
 *   到达终点
 *
 */
- (void) naviSessionDestArrived;

/**
 *
 *   导航初始化后数据包回调，一旦初始化成功并且GPS打开，就会触发该回调
 *
 */
- (void) naviSessionTracking:(MBNaviSessionData*)sData;

/**
 *
 *   路线计算中
 *
 */
- (void) naviSessionRouting;

/**
 *
 *   路线计算被取消
 *
 */
- (void) naviSessionRouteCancelled;

/**
 *
 *   偏航重计算被取消
 *
 */
- (void) naviSessionRerouteCancelled;

/**
 *
 *   进入手动起点状态
 *
 */
- (void) naviSessionManualStartStateBegin;

/**
 *
 *   离开手动起点状态
 *
 */
- (void) naviSessionManualStartStateEnd;

/**
 *
 *   新路线已被采纳为当前路线
 *
 */
- (void) naviSessionNewRouteTaken;

/**
 *
 *   需要进行偏航重计算。在真实导航中，如果在偏航状态保持2秒，则会收到此事件
 *
 */
- (void) naviSessionNeedsReroute;

/**
 *
 *   模拟导航开始
 *
 */
- (void) naviSessionSimNaviBegin;
/**
 *
 *   模拟导航结束
 *
 */
- (void) naviSessionSimNaviEnd;
/**
 *  根据TMC发现一条比当前路线更优的路线。客户端应该在回调内决定是否take这个RouteBase对象,回调结束后这个指针会被回收。
 *
 *  @param base 一条路线。
 */
- (void) naviSessionNewTmcRoute:(MBRouteBase*)base;
/**
 *  当前有新的转弯箭头需要显示。
 *
 *  @param arrowShapes 表示箭头的点数组
 */
- (void) naviSessionNewArrow:(NSArray*)arrowShapes;
/**
 *  当有转弯箭头需要删除时出发回调
 */
- (void) naviSessionDeleteArrow;
/**
 *  路线上的TMC信息更新，获取该回调需要设置 MBTmcOptions 属性
 *
 *  @param base 一条路线
 */
- (void) naviSessionRouteTmcUpdated:(MBRouteBase*)base;
/**
 *  进行了一次tmc的播报。
 *
 *  @param tmcItem MBTmcReportItem
 */
- (void) naviSessionTmcReportItemReported:(MBTmcReportItem*) tmcItem;
/**
 *  有新的车道信息可以显示。仅限离线算路。
 *
 *  @param collection 参数是一个 MBNaviLaneCollection
 */
- (void) naviSessionNewNaviLaneCollection:(MBNaviLaneCollection*)collection;
/**
 *  当前车道信息不再应该显示。
 */
- (void) naviSessionDeleteNaviLaneCollection;
/**
 *  电子眼数据授权验证失败。
 *
 *  @param err MBAuthError 错误码
 */
- (void) naviSessionCameraAuthFailed:(MBAuthError)err;
/**
 *  已到达途经点(附近)。
 *
 *  @param index 保存着已到达的途经点的下标：第一个途经点下标为0，以此类推。
 */
-(void)naviSessionWayPointArrived:(NSUInteger)index;
/**
 *  声音播放开始。
 */
-(void)naviSessionNaviBegin;
/**
 *  声音播放结束
 */
-(void)naviSessionSoundEnd;
/**
 *  当前路线被删除
 */
-(void)naviSessionRouteRemoved;
/**
 *  tmc播报出错。
 *
 *  @param err 参见 [MBTmcReportError](#)
 */
-(void)naviSessionTmcReportError:(MBTmcReportError)err;
/**
 *  检测到TMC播报事件
 *
 *  @param tmcItems 返回MBTmcReportItem数组
 */
- (void) naviSessionTmcReportItemsDetected:(NSArray*)tmcItems;
/**
 * 自动模式(NaviSession_getNaviMode == NaviMode_auto)下，离线算路失败。
 *  自动模式下的离线算路失败并不是错误，不需要提示用户，NaviSession 会再尝试在线算路。如果在线算路也失败了，才会有 NaviSessionEvent_routeFailed 事件。
 *
 *  @param err     MBTRouterError
 *  @param details 详细信息
 */
-(void) naviSessionOfflineRouteFaildInAutoMode:(MBTRouterError)err moreDetails:(NSString*)details;
/**
 *  放大图内容从无到有。建议调用者在收到show和refresh事件后显示或重绘放大图、收到hide事件后隐藏放大图窗口。
 *  @since 5.0.0
 */
-(void)naviSessionExpandViewShow;
/**
 *  从上一次发出show事件或refresh事件后，放大图内容有了更新。此更新可能是由调用ExpandView_update()触发，也可能是由放大图模块内的定时器等触发。
 *  @since 5.0.0
 */
-(void) naviSessionExpandViewRefresh;
/**
 *  放大图内容从有到无
 *  @since 5.0.0
 */
-(void) naviSessionExpandViewHide;
@end

/**
 *   导航API，该模块需要先初始化 MBGpsTracker
 */
@interface MBNaviSession : NSObject
/**
 *  获取导航的单例对象，得到后需要设置 MBNaviSessionParams 才能正常使用相关导航功能
 *  @return MBNaviSession 对象
 */
+(MBNaviSession *)sharedInstance;
/**
 *  导航单例销毁
 *
 *  @since 5.0.x
 */
+(void)cleanup;
/**
 *  设置导航相关参数
 */
@property(nonatomic,retain) MBNaviSessionParams* params;
/**
 *  导航授权
 */
@property(nonatomic,readonly) MBSdkAuthError authErrorType;
/**
 * 是否为VIP摄像头数据
 */
@property(nonatomic,readonly) BOOL isVipCameraData;
/**
 *  设置蚯蚓路tmc状态获取接口的url,默认值："http://search.api.mapbar.com/tmc/getTmc.jsp"
 */
@property(nonatomic,retain) NSString* tmcUrlBase;
/**
 * 是否启用摄像头播报
 */
@property(nonatomic,assign) BOOL enableCamera;
/**
 *  导航代理
 */
@property(nonatomic, assign) id<MBNaviSessionDelegate> delegate;
/**
 *  设置语音方言
 *
 *  @param value 方言类型，参见 MBTTS_PARAM_SPEAKER
 *
 *  @since 5.0.x
 */
-(void)setTTSRole:(NSUInteger)value;
/**
 *  打开/关闭某个/某些子模块 [子模块管理]
 *  @param  module  子模块
 *  @param  enable  是否开启
 *  @return 空
 */
- (void)enableModule:(MBNaviSessionModule)module enable:(BOOL)enable;
/**
 *
 *  判断指定的子模块是否已打开 [子模块管理]
 *  @param  module  子模块
 *  @return enable  是否开启
 *  @see    enableModule:enable:
 *
 */
- (BOOL)isModuleEnabled:(MBNaviSessionModule)module;
/**
 *  设置导航模式：在线/离线/自动 [路线规划]
 *  @param  mode  在线/离线/自动
 *  @return 空
 */
- (void)setNaviMode:(MBNaviMode)mode;
/**
 *  获取当前的导航模式：在线/离线/自动 [路线规划]，默认自动
 *  @return  mode  在线/离线/自动
 */
- (MBNaviMode)getNaviMode;
/**
 *  使用指定的路线计划开始算路 [路线规划]
 *  @param  newPlan     指定的路线计划
 *  @param  method      算路方法：是只算一条路，是用多种规则计算多条路，还是用一种规则算多条路。
 *  @return 空
 *  @see    cancelRouting:
 *  @note   算路开始后，典型地，调用者会收到以下事件：1条 NaviSessionEvent_routeStarted 若干条 NaviSessionEvent_routing 1条 NaviSessionEvent_routeComplete 或 NaviSessionEvent_routeFailed 或 NaviSessionEvent_routeCancelled
 */
- (void)startRoute:(const MBRoutePlan *)newPlan routeMethod:(MBNaviSessionRouteMethod)method;
/**
 *  使用指定的路线规则开始算路,返回1~3条结果 [路线规划]
 *  @param  newPlan     指定的路线计划
 *  @param  type        用“系统推荐”、“距离优先”、“高速优先”、“避让收费”的一种规则算多条路。
 *  @return 空
 *  @ntoe   算路开始后，典型地，调用者会收到以下事件：1条 NaviSessionEvent_routeStarted 若干条 NaviSessionEvent_routing 1条 NaviSessionEvent_routeComplete 或 NaviSessionEvent_routeFailed 或 NaviSessionEvent_routeCancelled
 */
-(void)startRoute:(const MBRoutePlan*)newPlan avoidRoadType:(MBRouteRule)type;
/**
 *  取消正在进行的路线规划计算 [路线规划]
 *  @return 空
 */
- (void)cancelRouting;
/**
 *  获取当前路线 [路线规划]
 *  @return RouteBase
 */
- (MBRouteBase *)getRoute;
/**
 *  获取当前的路线计划(只读)线 [路线规划]
 *  @return RoutePlan
 */
- (MBRoutePlan*)getPlan;
/**
 *  采纳指定的路线，将其设为当前路线，用于导航和模拟导航 [路线规划]
 *  @param  RouteBase   路线的基本信息
 *  @return 空
 */
- (void)takeRoute:(MBRouteBase*)route;
/**
 *  删除当前路线，以及路线计划文件 [路线规划]，也就是停止导航。对应 [takeRoute:](#) 方法。
 *  @return 空
 */
- (void)removeRoute;
/**
 *  当前是否正在算路中 [路线规划]
 *  @return 空
 */
-(BOOL)isRouting;
/**
 *  获取算路步数计数器的值 [路线规划]
 *  @return 算路步数计数器的值
 */
- (NSInteger)getStepCounter;
/**
 *  是否有上次运行留下来的路线计划文件可用于恢复导航 [路线规划]
 *  @return BOOL
 */
- (BOOL)canResumeNavigation:(MBRoutePlan*)plan;
/**
 *  使用上次运行留下来的路线计划文件恢复导航 [路线规划]
 *  @return 空
 */
- (void)resumeNavigation;
/**
 *  获取算路异常时错误信息 [路线规划]
 *  @return 返回当前算路错误的信息字串
 */
-(NSString *)getErrorStr;
/**
 *
 *  用于获取导航实时数据 [路线规划]
 *  @return NaviSessionData 导航实时数据对象
 *   一般情况下，在回调函数中的tracking事件会返回{@link NaviSessionData}对象<br>此对象即表示当前实时导航信息，不需要手动调用此方法获取实时信息
 */
-(id)getNaviData;

/**
 *
 *  开始模拟导航 [模拟导航]
 *  @return 空
 *
 */
-(void)startSimulation;

/**
 *
 *  用指定的 RoutePlan 启动实景模拟功能 [模拟导航]
 *  @param  plan 指定的路线计划
 *  @return 空
 *   会暂时强制启用路口放大图功能
 */
-(void)startSimulationWithPlan:(MBRoutePlan*)plan;

/**
 *
 *  终止模拟导航 [模拟导航]
 *  @return 空
 *
 */
-(void)endSimulation;

/**
 *
 *  是否在模拟导航状态 [模拟导航]
 *  @return 如果处于模拟导航模式中返回YES，否则返回NO
 *   模拟导航暂停时，仍然在模拟导航状态
 */
-(BOOL)isInSimulation;

/**
 *
 *  暂停模拟导航 [模拟导航]
 *  @return 空
 *
 */
-(void)pauseSimulation;

/**
 *
 *  恢复模拟导航 [模拟导航]
 *  @return 空
 *
 */
-(void)resumeSimulation;

/**
 *
 *  是否在模拟导航暂停状态 [模拟导航]
 *  @return 是否当前已经暂停了模拟导航状态，已经暂停返回YES，否则返回NO
 *
 */
-(BOOL)isSimulationPaused;

/**
 *
 *  设置模拟导航的速度倍数 [模拟导航]
 *  @param  speed 当前的速度等级(相对于基础速度的百分比) 1.0,2.0 ...
 *  @return 空
 *
 */
-(void)setSimulationSpeed:(float)speed;

/**
 *
 *  获取模拟导航的速度倍数 [模拟导航]
 *  @return 空
 *
 */
-(float)getSimulationSpeed;

/**
 *
 *  设置模拟导航是否循环模拟 [模拟导航]
 *  @param  enable 设置为YES则表示循环模拟，设置为NO表示单次模拟
 *  @return 空
 *
 */
-(void)enableRepeatSimulation:(BOOL)enable;

/**
 *
 *  模拟导航是否循环模拟 [模拟导航]
 *  @return 如果此时为循环模拟，返回YES，否则返回NO
 *
 */
-(BOOL)isRepeatSimulationEnabled;

/**
 *
 *  设置模拟导航刷新的时间步长 [模拟导航]
 *  @param  milliseconds 设置模拟导航刷新的间隔时间，单位为毫秒(ms)
 *  @return 空
 *
 */
-(void)setSimulationInterval:(uint)milliseconds;

/**
 *
 *  用于在地图上呈现当前算的路线 [Route overview]
 *  @return 空
 *
 */
-(void)startRouteOverview;

/**
 *
 *  用于结束道路的地图呈现 [Route overview]
 *  @return 空
 *
 */
-(void)endRouteOverview;

/**
 *
 *  暂停真实导航 [Pause and resume]
 *  @return 空
 *   此函数使用了引用计数。注意要保证与 NaviSession_resumeNavi() 成对使用
 */
-(void)pauseNavi;

/**
 *
 *  恢复真实导航 [Pause and resume]
 *  @return 空
 *
 */
-(void)resumeNavi;

/**
 *
 *  真实导航是否已暂停 [Pause and resume]
 *  @return 空
 *
 */
-(BOOL)isNaviPaused;

/**
 *
 *  判断当前是否为手动起点状态 [手动起点状态]
 *  @return 如果当前处于手动起点状态返回YES，否则返回NO
 *   所谓“手动起点状态”。就是说不采用GPS定位点为起点，而是手动设置的起点。此时虽然偏航，但是并不会引起重新计算
 */
-(BOOL)isInManualStartState;

/**
 *
 *  结束手动起点状态 [手动起点状态]
 *  @return 空
 *
 */
-(void)endManualStartState;
/**
 * 更新导航数据
 */
-(void)updateSessionTracking;
/**
 *
 *  设置白天黑夜模式 [Misc]
 *  @param  如果为YES表示进入夜晚状态，如果为NO进入白天状态
 *  @return 空
 *
 */
-(void)setNightMode:(BOOL)night;

/**
 *
 *  获取当前的白天黑夜模式 [Misc]
 *  @return 如果当前为夜晚模式则返回YES，否则返回NO
 *
 */
-(BOOL)getNightMode;

/**
 *
 *  测试根据给定的坐标和方向是否能抓路 [Misc]
 *  @param  pos 给定的坐标点
 *  @param  ori 给定的方向
 *  @return 如果能成功抓路则返回YES，否则返回NO
 *
 */
-(BOOL)tryGrabSegments:(MBPoint*)pos ori:(short)ori;

/**
 *
 *  设置在线算路服务器URL
 *  @param  urlBase 服务器URL地址
 *  @return 空
 *
 */
-(void)setRouteUrlBase:(NSString *)urlBase;

/**
 *
 *  设置语音播报模式
 *  @param [in] mode 要设置的语音播报模式：简介、标准、安全。
 *  @return 空
 *
 */
-(void)setGuidanceMode:(MBGuidanceMode)mode;

/**
 *
 *  设置电子眼播报模式
 *  @param mode 要设置的电子眼播报模式：简单、标准、全部。
 *  @return 空
 *
 */
- (void)setCameraMode:(MBCamerFilterMode)mode;
/**
 *  高速模式
 */
@property(nonatomic,assign)MBHighwayGuideMode highwayGuidemode;
/**
 *
 *   设置“导航开始语音模式”，“导航开始语音模式”的设置会影响导航开始以及模拟导航开始时的语音播报内容。缺省值为 MBNaviSessionNaviStartVoiceMode_pnd
 */
@property(nonatomic,assign)MBNaviSessionNaviStartVoiceMode naviStartVoiceMode;

/**
 *  近期导航得到的路线
 */
@property (nonatomic, retain) MBRouteCollection *routes;

/**
 *  近期导航得到的数据
 */
@property (nonatomic, retain) MBNaviSessionData *sessionData;

/**
 *  关闭离线电子眼
 */
-(void)disableOfflineCameraData;
/**
 *  获取电子眼数据的授权验证结果
 *
 *  @return 授权结果，参见MBAuthError
 */
-(MBAuthError)getCameraAuthError;
/**
 *  初始化引擎后，判断当前已经加载的电子眼数据状态
 *
 *  @return 电子眼数据状态,MBCameraDataState
 */
- (MBCameraDataState)getCameraDataState;
/**
 *  获取TMC相关选项
 *
 *  @return MBTmcOptions
 */
@property (nonatomic,assign) MBTmcOptions tmcOptions;
/**
 *  判断当前引擎是否处在定位状态
 *
 *  @return YES即定位
 */
-(BOOL)isPositionFixed;
/**
 *  开启/关闭各种播报语音
 *
 *  @param enabled YES表示开启。
 */
@property (nonatomic,assign) BOOL enableSound;
/**
 *  主动发起一次TMC更新、TMC重算路的请求，需要相应的MBTmcOptions.enableTmcReroute设置为true才生效
 *
 *  @param request MBTmcRequest
 */
-(void)requestTmcUpdate:(MBTmcRequest)request;
/**
 *  设置防调头模式
 *
 *  @param mode MBAvoidUTurnMode
 */
-(void)setAvoidUTurnMode:(MBAvoidUTurnMode)mode;
/**
 *  设置偏航重计算的结果是否倾向于与原有路线相似 此接口的需求来自这样的应用场景：
 *  用户在“单规则多结果”算路方式下选择了非第一条路线作为当前路线进行导航，
 *  但在起点附近很快就发生了偏航重计算，此时用户希望重计算的结果仍然是之前选择的路线。
 *  此接口设置为 true后可能带来的副作用是重计算结果立刻要掉头的概率会更大一些。
 *
 *  @param prefer YES表示尽可能相似。
 */
-(void)setReroutePreferExisting:(BOOL)prefer;
@end
