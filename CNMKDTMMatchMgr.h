//
//  CNMKDTMMatchMgr.h
//  cennavimapapi
//
//  Created by jkliu on 16/3/28.
//
//

#import <Foundation/Foundation.h>
#import "CNMKDTMCache.h"
#import "CNMKManagerInternal.h"
#import "CNMKJamModel.h"
#import "CNMKMeshModel.h"
#import "CNMKRticModel.h"
#import "CNMKHeadElaborateModel.h"
#import "CNMKDTMTileModel.h"
#import "CNMKDTMMeshData.h"
#import "CNMKDTMRticData.h"
#import "CNMKPointData.h"
#import "CNMKDTMDataMgr.h"
#import "ComputePoint.h"
#import "CNMKElaborate.h"
#define MINUTE 1        //每分钟更新
#define UNMINUTE 0      //平时更新
#define DTMUPDATE 1     //DTM已经更新
#define UNDTMUPDATE 0     //DTM没更新

@interface CNMKDTMMatchMgr : NSObject
{
    //条件锁
    //NSCondition *matchConditionLock;
    NSLock  *matchConditionLock;
    
    //用于判断是否是整分钟路况更新
    BOOL timingRefresh;
    BOOL jamPost;
    
    //保存traffic传递来的对象
    NSMutableArray *trafficObjOld;
    NSMutableArray *trafficObjNew;
    
    //Save dtm tiles which is not matched
    NSMutableArray  *dtmTileList;
    
    //得到DTM传递来的TileID
//    NSString *curTileID;
    //DTM更新状态
    int DtmUpdateState;
    int dtmComeCnt;
    
    NSMutableArray *dtmTileCaches;

}


@property (nonatomic, strong) NSMutableDictionary *aaaa;
- (void)setDtmDataMgr:(CNMKDTMDataMgr *)dataMgrs;
- (UIImage *)getDTMTileImage:(TileID)tileID;

@end
