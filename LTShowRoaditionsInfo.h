//
//  LTShowRoaditionsInfo.h
//  
//
//  Created by 刘博通 on 16/5/12.
//
//

#import <UIKit/UIKit.h>
@class LTRoadConditonDetailModel;
@interface LTShowRoaditionsInfo : UIView
@property (nonatomic ,strong)LTRoadConditonDetailModel *detailModel;

+(instancetype)getShowRoaditionView;
@end
