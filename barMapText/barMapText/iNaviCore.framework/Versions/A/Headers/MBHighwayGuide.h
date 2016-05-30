//
//  MBHighwayGuide.h
//  iNaviCore
//
//  Created by fanyl on 14-5-23.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBObject.h"

/**	高速行程模块工作模式 */
typedef enum MBHighwayGuideMode
{
    /**	缺省模式
     @details
     此模式下，用 HighwayGuide_getItem() 获取当前的高速行程信息，包括服务区和停车区，
     也可以用 HighwayGuide_getNextServiceArea() 来单独获取下一个服务区或停车区的信息。
     */
    MBHighwayGuideMode_default = 0,
    
    /** 排除服务区模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中不会包含任何服务区和停车区，
     但可以用 HighwayGuide_getNextServiceArea() 来获取下一个服务区或停车区的信息。
     */
    MBHighwayGuideMode_excludeServiceArea = 1,
    
    /**	服务区优先模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中尽可能包含至少一个服务区或停车区，即：
     如果 HighwayGuide_getNextServiceArea() 不为空，则这个服务区/停车区一定会出现在 HighwayGuide_getItem() 返回的结果中。
     */
    MBHighwayGuideMode_preferServiceArea = 2,
    
    /**	完整模式
     @details
     在此模式下，HighwayGuide_getItem() 可以返回当前车辆位置向前100公里内的所有高速行程信息，包括服务区和停车区。
     */
    MBHighwayGuideMode_complete = 3
} MBHighwayGuideMode;

@class MBHighwayGuideItem;
/**
 *  高速行程模块提供了车辆在高速公路上行驶时用作显示的行程信息，如：出口(IC)、高速连接线(JC)、服务区(SA)、停车区(PA)、收费站(TG)。
 */
@interface MBHighwayGuide : NSObject
/**
 *  高速引导模块构造
 *
 *  @since 5.0.x
 */
+(void)construct;
/**
 *  高速引导模块销毁
 *
 *  @since 5.0.x
 */
+(void)cleanUp;
/**
 *  1. 删除路线后
    2. 路线规划完毕后
    3. 路线重计算完毕后
    4. 模拟导航到达目的地后
    5. 模拟导航开始时
    6. 模拟导航结束时
 *
 *  @since 5.0.x
 */
+(void)reset;
/**
 *  设置高速行程模块是否启用
 *
 *  @param enable TRUE 表示启用
 *
 *  @since 5.0.x
 */
+(void)setEnable:(BOOL)enable;
/**
 *  判断高速行程模块是否已启用
 *
 *  @return TRUE 表示启用
 *
 *  @since 5.0.x
 */
+(BOOL)getEnable;
/**
 *  是否需要显示高速行程信息。
 *
 *  @return 是否需要显示高速行程信息
 *
 *  @since 5.0.x
 */
+(BOOL)shouldDisplay;
/**
 *  设置模式
 *
 *  @param mode 高速引导模式
 *
 *  @since 5.0.x
 */
+(void)setMode:(MBHighwayGuideMode)mode;
/**
 *  获取模式
 *
 *  @return 高速引导模式
 *
 *  @since 5.0.x
 */
+(MBHighwayGuideMode)getMode;
/**
 *  高速引导信息
 *
 *  @return MBHighwayGuideItem 数组
 *
 *  @since 5.0.x
 */
+(NSArray*)getItems;
/**
 *  获取下一个服务区或停车区对应的高速行程信息
 *
 *  @return MBHighwayGuideItem
 *
 *  @since 5.0.x
 */
+(MBHighwayGuideItem*)getNextServiceArea;
@end

