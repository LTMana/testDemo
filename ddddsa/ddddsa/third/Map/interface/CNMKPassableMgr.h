//
//  CNMKMapMgr.h
//  cennavimapapi
//
//  Created by Lion on 12-2-14.
//  Copyright (c) 2012年 __CenNavi__. All rights reserved.
//

#import "CNMKInternalType.h"
#import "CNMKFileCacheMgr.h"

#import "CNMKQueryElement.h"
#import "CNMKMapCache.h"


@protocol CNMKManagerInternalDelegate;

@interface CNMKPassableMgr : NSObject <CNMKManagerInternalDelegate> {
    
    //瓦片地图缓存
    NSArray *tileCaches;
    NSLock *tileCacheLock;
    
    //线程池
    NSOperationQueue *operationQueue;
    
    //查询队列
    NSMutableArray *queryQueue;
    NSLock *queryQueueLock;
    
    //瓦片地图文件缓存
    CNMKFileCacheMgr *tileFileCache;
    
    NSTimer *timer;
    int timestampHour;
    int lastDelegateIndex;
}

//刷新出租车信息
- (void)refreshTaxi:(NSTimer *)timer;

//准备Map数据
- (BOOL)prepareMapTile:(TileID)tileID forDelegateIndex:(int)delegateIndex;

//取消准备Map数据
- (void)unprepareMapTile:(TileID)tileID forDelegateIndex:(int)delegateIndex;


//在文件缓存中查询
- (void)queryTileInFileCache:(id)userInfo;

//查询文件缓存完成
- (void)queryTileInFileCacheCompleted:(id)userInfo;


//生成Map瓦片
- (UIImage *)createMapTile:(TileID)tileID buffer:(const void *)buffer length:(int)length timestamp:(CFTimeInterval)timestamp;

//添加Map瓦片数据
- (void)addMapTile:(CNMKQueryElement *)element tileImage:(UIImage *)tileImage;


//查询完成
- (void)queryCompleted:(CNMKQueryElement *)element;


//申请地图瓦片
- (UIImage *)getMapTileImage:(TileID)tileID;


//瓦片地图文件缓存保存线程
- (void)saveFileCache:(id)obj;


//下载结果
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)managerRequestDidStartSelector:(ASIHTTPRequest *)request;
- (void)managerRequestDidFinishSelector:(ASIHTTPRequest *)request;
- (void)managerRequestDidFailSelector:(ASIHTTPRequest *)request;

@end
