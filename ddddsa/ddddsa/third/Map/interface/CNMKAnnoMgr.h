//
//  CNMKMapMgr.h
//  cennavimapapi
//
//  Created by Lion on 13-3-14.
//  Copyright (c) 2013年 __CenNavi__. All rights reserved.
//

#import "CNMKInternalType.h"
#import "CNMKFileCacheMgr.h"
#import "CNMKQueryElement.h"
#import "CNMKMapCache.h"

@protocol CNMKManagerInternalDelegate;
@interface CNMKAnnoMgr : NSObject <CNMKManagerInternalDelegate>
{
    //...瓦片地图缓存
    NSArray *tileCaches;
    NSLock *tileCacheLock;
    //...线程池
    NSOperationQueue *operationQueue;
    //...查询队列
    NSMutableArray *queryQueue;
    NSLock *queryQueueLock;
    //...瓦片地图文件缓存
    CNMKFileCacheMgr *tileFileCache;
    //...陆地瓦片图
    //UIImage *landImage;
    
    TileID dwt;
    NSInteger dwt1;
}

//...准备Map数据
- (BOOL)prepareMapTile:(TileID)tileID forDelegateIndex:(int)delegateIndex;
//...取消准备Map数据
- (void)unprepareMapTile:(TileID)tileID forDelegateIndex:(int)delegateIndex;
//...删除所有的数据
- (void)clearAnnoTile:(TileID)tileID forDelegateIndex:(int)delegateIndex;
//...在文件缓存中查询
- (void)queryTileInFileCache:(id)userInfo;
//...查询文件缓存完成
- (void)queryTileInFileCacheCompleted:(id)userInfo;
//...定时器5分钟更新路况
- (void)updateMapTimer;

//...生成Map瓦片
- (UIImage *)createMapTile:(TileID)tileID buffer:(const void *)buffer length:(int)length timestamp:(CFTimeInterval)timestamp;
//...添加Map瓦片数据
- (void)addMapTile:(CNMKQueryElement *)element tileImage:(UIImage *)tileImage;
//...查询完成
- (void)queryCompleted:(CNMKQueryElement *)element;
//...申请地图瓦片
- (UIImage *)getMapTileImage:(TileID)tileID;
//...瓦片地图文件缓存保存线程
- (void)saveFileCache:(id)obj;
@end
