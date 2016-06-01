//
//  LTRaditionsShowModel.h
//  
//
//  Created by 刘博通 on 16/5/12.
//
//

#import <Foundation/Foundation.h>
@class MBAnnotation;
@interface LTRaditionsShowModel : NSObject
//** 事件Id */
@property (nonatomic ,assign)NSInteger eventId;
//** 事件管制中代码 */
@property (nonatomic ,assign)NSInteger eventRestrict;
//** 事件管制小代码 */
@property (nonatomic ,assign)NSInteger eventRestrictType;
//** 事件类型中代码 */
@property (nonatomic ,assign)NSInteger eventReasonType;
//** 事件类型小代码 */
@property (nonatomic ,assign)NSInteger eventReason;
//** 事件纬度 */
@property (nonatomic ,assign)double linkLatitude;
//** 事件精度*/
@property (nonatomic ,assign)double linkLongitude;
//** 事件道路等级*/
@property (nonatomic ,copy)NSString *roadLevel;
//**新事件类型代码
@property (nonatomic ,assign)NSInteger trafficEyeType;

//辅助属性
//** 事件显示图层*/
@property (nonatomic ,strong)MBAnnotation *anno;


@end
