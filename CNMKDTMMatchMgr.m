//
//  CNMKDTMMatchMgr.m
//  cennavimapapi
//
//  Created by jkliu on 16/3/28.
//
//

#import "CNMKDTMMatchMgr.h"

#import <math.h>

@implementation CNMKDTMMatchMgr
{
   // CNMKDTMTileModel *tileModel;
    CNMKDTMDataMgr *dataMgr;
    CGContextRef context;
}
//初始化匹配线程，消息监听，类变量
- (id)init
{


    //创建用于匹配处理线程，使用条件锁
    [NSThread detachNewThreadSelector:@selector(matchingProcessThread:) toTarget:self withObject:@""];
    
    NSOperationQueue *quee=[[NSOperationQueue alloc]init];
    NSInvocationOperation *op=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(DTM_RTIC_Match:) object:nil];
    
    [quee addOperation:op];

    
    //创建DTM监听消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DTMUpdateProcess:) name:@"DTM_UPDATE_MESSAGE" object:nil];
    //创建JAM监听消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TrafficUpdateProcess:) name:@"TRAFFIC_UPDATE_MESSAGE" object:nil];
    //创建条件锁
    //matchConditionLock =[[NSCondition alloc] init];
    matchConditionLock = [[NSLock alloc] init];
    //self.dtmDataMatchCondition=[[NSCondition alloc]init];
    //创建tileCaches
    dtmTileCaches = [[NSMutableArray alloc] initWithCapacity:CNMKDEF_DTMCACHE_SIZE];
    for (NSInteger i = 0; i < CNMKDEF_DTMCACHE_SIZE; i++)
    {
        [dtmTileCaches addObject:[[CNMKDTMCache alloc] init]];
    }
    dtmTileList = [[NSMutableArray alloc] initWithCapacity:CNMKDEF_DTMCACHE_SIZE];
    //dtmTileCaches = tileCachesTmp;

    //用于判断是否是整分钟路况更新
    timingRefresh = NO;
    jamPost = NO;
    
    //保存traffic传递来的对象
    trafficObjOld = nil;
    trafficObjNew = nil;
    
    //DTM没有更新
    DtmUpdateState = UNDTMUPDATE;
    dtmComeCnt = 0;
    
    //得到DTM传递来的TileID
    //curTileID = NULL;
    //tileModel = [[CNMKDTMTileModel alloc] init];

    return self;
}





//...DTM消息处理
- (void) DTMUpdateProcess: (NSNotification *)note
{
    [matchConditionLock lock];
    if( (note.userInfo[@"DtmTileId"] != NULL) && (note.userInfo[@"DtmUpdateState"] != NULL)  )
    {
        //self.curTileID = [[note userInfo] valueForKey:@"DtmTileId"];
        //[self dd:tileModel];
        NSString *state = [[note userInfo] valueForKey:@"DtmUpdateState"];
        
        if ([state isEqual:[NSString stringWithFormat:@"%d",DTMUPDATE]])
        {
            DtmUpdateState = DTMUPDATE; //DTM消息有更新
            dtmComeCnt++;
            NSString *TileID = [[note userInfo] valueForKey:@"DtmTileId"];
            [dtmTileList addObject:TileID];

        }
    }
    [matchConditionLock unlock];
    
}

- (void)setDtmDataMgr:(CNMKDTMDataMgr *)dataMgrs
{
    dataMgr = dataMgrs;
}


//...路况更新消息处理
- (void) TrafficUpdateProcess: (NSNotification *)note
{
    [matchConditionLock lock];
    
    if( (note.userInfo[@"TimingRefreshState"] != NULL) && (note.userInfo[@"NSMutableArr"] != NULL) )
    {
        NSString *state = [[note userInfo] valueForKey:@"TimingRefreshState"];
        NSMutableArray *jamObj = [[note userInfo] valueForKey:@"NSMutableArr"];
        /* 验证数据
        for (CNMKMeshModel *mesh in jamObj) {
            NSLog(@"==========================");
            NSLog(@"mesh.id:%@",mesh.meshId);
            NSLog(@"==========================");
            for (CNMKRticModel *rtic in mesh.rtics) {
                NSLog(@"==========================");
                NSLog(@"rtic.id:%@",rtic.rticId);
                NSLog(@"rtic.deg:%@",rtic.deg);
                NSLog(@"==========================");
                for (CNMKHeadElaborateModel *head in rtic.subInf) {
                    NSLog(@"head.slen:%ld",(long)head.sLen);
                    NSLog(@"head.dlen:%ld",(long)head.dLen);
                    NSLog(@"head.subdeg:%ld",(long)head.subDeg);
                }
            }
        }
        
        */
        //NSLog(@"TrafficUpdateProcess=%@ %@",state , jamObj);
        
        //整分钟路况更新
        if ([state intValue] == MINUTE)
        {
            timingRefresh = TRUE;
        }
        else
        {
            jamPost = YES;
        }
        
        trafficObjNew = jamObj;
    }
    [matchConditionLock unlock];
}


//...匹配处理线程
- (void) matchingProcessThread:(NSString*)str
{
    BOOL jamMatch = NO;
    while (true)
    {
        [matchConditionLock lock];
        CNMKDTMTileModel  *tileMode;
        //[matchConditionLock wait];  //等待接收消息进行处理

//        if (self.curTileID != nil) {
//            NSLog(@"wait_tileID=%@",self.curTileID);
//        }
        //用于判断是否是整分钟路况更新
        if (timingRefresh == YES)
        {
            jamMatch = YES;
            //删除旧的字典，使用新的字典
            if (trafficObjNew != nil)
            {
                if (trafficObjOld != nil) {
                    //[self releaseTrafficObj:trafficObjOld];
                    //NSLog(@"preold retaincount:%lu",(unsigned long)[trafficObjOld retainCount]);
                   
                    trafficObjOld = nil;
                   
                }
                trafficObjOld = trafficObjNew ;
                //NSLog(@"old retaincount:%lu",(unsigned long)[trafficObjOld retainCount]);
                trafficObjNew = nil;

                //加锁gdtmPool
                [gdtmPoollock lock];
                
                //NSLog(@"1 minute");
                for (int i = 0; i < [dataMgr.gdtmPool count]; i++)
                {
                    @autoreleasepool {
                        //以传递来的TileID查找gdtmPools中的新数据进行匹配
                        CNMKDTMTileModel  *tileModel = [dataMgr.gdtmPool objectForKey:[dataMgr.gdtmPool allKeys][i]];//以传递来的TileID为Key查找
                      
                        
                        //循环操作初始化参数
                        for (int j=0;j< tileModel.meshCnt; j++)
                        {
                            CNMKDTMMeshData *mesh=tileModel.meshArrary[j];
                            for (int k=0;k<mesh.rticCnt; k++)
                            {
                                CNMKDTMRticData *rtic=mesh.RticArrary[k];
                                rtic.tjamState = 1;         //重新设置 tjamState=1; 绿色
                            }
                        }

                    }
                                   }
                //解锁gdtmPool
                [gdtmPoollock unlock];
            }
            else
            {
                // No new data, so continue
                timingRefresh = NO;
                [matchConditionLock unlock];
                usleep(1000 * 1);
                continue;
            }
        }
        //else if (DtmUpdateState != DTMUPDATE) //DTM消息没有更新
        else if (jamPost == YES)
        {
            jamMatch = YES;
            jamPost = NO;
            //删除旧的字典，使用新的字典
            if (trafficObjNew != nil)
            {
                if (trafficObjOld != nil) {
                    trafficObjOld = nil;
                }
                trafficObjOld = trafficObjNew ;
                trafficObjNew = nil;
            }
            else
            {
                // No new data, so continue
                timingRefresh = NO;
                [matchConditionLock unlock];
                
                usleep(1000 * 1);
                continue;
            }
        }

        if ((dtmTileList.count > 0) || (jamMatch == YES))
        //if ((DtmUpdateState == DTMUPDATE) || (jamMatch == YES))
        {
            //加锁gdtmPool
            [gdtmPoollock lock];
            
            //DTM有更新
            //if (DtmUpdateState == DTMUPDATE)
            if (dtmTileList.count > 0)
            {
                //NSLog(@"match dtm");
                //DtmUpdateState = UNDTMUPDATE;   //DTM没有更新
                if (trafficObjOld != nil)
                {
                    for (int i = 0; i < dtmTileList.count; i++)
                    {
                        //以传递来的TileID查找gdtmPools中的新数据进行匹配
                        //NSLog(@"curTileID:%@",dtmTileList[i]);
                    
                        tileMode  = [dataMgr.gdtmPool valueForKey:dtmTileList[i]];
                        //NSLog(@"tileModel.tile_id1:%@",tileMode.tile_id);
                        if (tileMode.tile_id==NULL) {

                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REPEATDOWNLOAD" object:nil userInfo:@{@"dtmTileList":dtmTileList[i]}];
                            //NSLog(@"空了哈哈哈哈哈哈");

                        }
                        if (tileMode !=nil) {
                           // NSLog(@"tileMode retainCount:%ld",(unsigned long)[tileMode retainCount]);
                        }
                        //查看当前使用路况数据的哪一层数据
                        //level = [self getJamDataLevel:tileModel.tile_id ];
                        //NSLog(@"matchOutTile_start");
                       

                        if ([tileMode.tile_id isEqual:@"110489_48757_17"])
                        {
                            LTLog(@"find");
                        }
                        [self matchOutTile:tileMode matcInStatMeshInfo:trafficObjOld];
                        if (tileMode.matchState) {
                             [self drawDTMTile:tileMode.request stu_tile:tileMode];
                        }
                       
                        
                        }
                    [dtmTileList removeAllObjects];
                }
            }
            else //路况每分时更新，全部刷新gdtmPools
            {
                jamMatch = NO;
                //NSLog(@"match jam");
                if (trafficObjOld != nil)
                {
                    if (timingRefresh == YES) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"upDataJam" object:nil];
                        timingRefresh = NO;          //设置整刷新为NO
                    }
                    
                    //循环匹配gdtmPools
                    for (int i = 0; i < dataMgr.gdtmPool.count; i++)
                    {
                        //...依次查找gdtmPool中的信息进行匹配
                        //tileModel = [dataMgr.gdtmPool valueForKey:self.curTileID];
                       
                       @autoreleasepool {
                        
                        tileMode = [dataMgr.gdtmPool objectForKey:[dataMgr.gdtmPool allKeys][i]];
                        
                        //查看当前使用路况数据的哪一层数据
                        //level = [self getJamDataLevel:tileModel.tile_id ];
                        
                        //描画DTM
                        if (tileMode != nil)
                        {
                            @autoreleasepool {
                                [self matchOutTile:tileMode matcInStatMeshInfo:trafficObjOld];
                                if (tileMode.matchState) {
                                    [self drawDTMTile:tileMode.request stu_tile:tileMode];
                                }
                                
                                
                            }
                            
                        }
                        }
                    }
                }
            }
            
            //解锁gtmPool
            [gdtmPoollock unlock];
        }
        [matchConditionLock unlock];
        usleep(1000 * 1);
        
        //NSLog(@"matchingProcessThread");
    }
}


//当前使用路况数据的哪一层数据
//-(int)getJamDataLevel:(NSString*)NStileID
//{
//    int reLevel=0;
//    TileID tileIDKey;
//    
//    ////tmpTileID = [NSString stringWithCString:dtmTile->tile_id encoding:NSASCIIStringEncoding];    //得到Tile_id并获取当前级别
//    NSArray *arrayID = [NStileID componentsSeparatedByString:@"_"];
//    tileIDKey.X = [[arrayID objectAtIndex:0] intValue];
//    tileIDKey.Y = [[arrayID objectAtIndex:1] intValue];
//    tileIDKey.Z = [[arrayID objectAtIndex:2] intValue];
//    
//    if (tileIDKey.Z == 10)
//    {
//        //得到level1的数据
//        reLevel = 1;
//    }
//    else if (tileIDKey.Z == 11)
//    {
//        //得到level2的数据
//        reLevel = 2;
//    }
//    else if ((tileIDKey.Z == 12) || (tileIDKey.Z == 13))//12-13
//    {
//        //得到level3的数据
//        reLevel = 3;
//    }
//    else if ((tileIDKey.Z >= 14) || (tileIDKey.Z <= 17))//14-17
//    {
//        //得到level4的数据
//        reLevel = 4;
//    }
//    
//    return reLevel;
//}

//具体匹配算法
-(void) matchOutTile:(CNMKDTMTileModel *) dtmTile matcInStatMeshInfo:(NSMutableArray*) meshinfo
{
    int iRticMatchCnt = 0;
   
    
    for (int i = 0; i < dtmTile.meshCnt; i++)
    {
       // CNMKDTMMeshData *meshData = dtmTile.meshArrary[i];
        
        for (CNMKMeshModel *mesh in meshinfo) {
            iRticMatchCnt = [self match2DtmMesh:dtmTile.meshArrary[i] tileId:mesh];

        }
   //        for (int j = 0 ; j < meshinfo.count; j++)
//        {
//            CNMKMeshModel *mesh=meshinfo[j];
//            
//         iRticMatchCnt =[self match2DtmMesh:meshData matchInStatInfo:mesh];
//            if(iRticMatchCnt > 0){
//                dtmTile.matchState =YES;
//                break;
//            }

  //      }
        

    }
    
    if (iRticMatchCnt>0) {
        dtmTile.matchState =YES;
    }
    
}

//mesh匹配mesh
-(int) match2DtmMesh:(CNMKDTMMeshData *) dtmMesh tileId:(CNMKMeshModel *) JamMesh
{
    //NSLog(@"function_start=%s",__func__);
    
    int  rticMatchCnt = 0;
    if (dtmMesh == NULL) {
        return 0;
    }
//    for (CNMKMeshModel *mesh in trafficObjOld) {
    
        for (int i = 0; i < JamMesh.rtics.count; i++)
        {
//            CNMKRticModel *rticModel = .rtics[i];
//            int infoRticId = [rticModel.rticId intValue];
            CNMKRticModel *rticInfo =JamMesh.rtics[i];

            for (int j = 0; j < dtmMesh.rticCnt; j++)
            {
                CNMKDTMRticData *dtmRticData=dtmMesh.RticArrary[j];

               
                
                int rticID=dtmRticData.rtic_id;
                
                
                                //DTMTile
                if (rticID == [rticInfo.rticId intValue])
                {
                    
                    
                    dtmRticData.tjamState = [rticInfo.deg intValue];
                    
                    dtmRticData.elaborateArray =[self bidElaborateDtmPoint:dtmRticData JamHeadElaborate:rticInfo];
                    ;
                    
                }
                
            }
            //    }
            
        }

  //  }
   
    //if (dtmMesh.mash_id ==[meshStatInfo.meshId intValue]) {
        //对比所有路况rtic 和 tile mesh rtic 进行 status 赋值
             //NSLog(@"function_end=%s",__func__);
    rticMatchCnt =1;
    return rticMatchCnt;
}


///**
// * 匹配以MESH为单位
// *
// * @param dtmMesh
// * @param tileID
// */
//private int bindJam(DtmMesh dtmMesh, TileMapID tileID) {
//    if (dtmMesh == null) {
//        return 0;
//    }
//    // int sum = 0 ;
//    // TODO 每个现存MESH里的历史路况清理
//    dtmMesh.clearJam();
//    List<DtmHeadRcit> headRcits = dtmJamHead.mJamMeshs.get(dtmMesh.meshID);
//    if (headRcits == null) {
//        return 0;
//    }
//    int result = 0;
//    //		 int dtmSumAll = 0;
//    try {
//        for (int jamIDX = 0; jamIDX < headRcits.size(); jamIDX++) {
//            //				int dtmsum = 0;
//            for (int dtmIDX = 0; dtmIDX < dtmMesh.rticCnt; dtmIDX++) {
//                int rticId = dtmMesh.rticData[dtmIDX].rticId;
//                //TODO  测试
//                //					if(rticId != 60371){
//                //						continue;
//                //
//                //					}
//                DtmHeadRcit dtmHeadRcit = headRcits.get(jamIDX);
//                if (rticId == dtmHeadRcit.rticId) {
//                    dtmMesh.rticData[dtmIDX].jamState = dtmHeadRcit.jamInfo;
//                    // 制作精细化数据
//                    if (DTMJamState == ELABORATE) {
//                        synchronized (lock) {
//                            if (dtmHeadRcit.elaborate != null
//                                && dtmHeadRcit.elaborate.length > 0) {
//                                dtmMesh.rticData[dtmIDX].elaborateLink = bindElaborate(tileID,
//                                                                                       dtmMesh.rticData[dtmIDX].points,
//                                                                                       dtmHeadRcit.elaborate);
//                            }
//                            //								if(dtmMesh.rticData[dtmIDX].elaborateLink!=null){
//                            //									int sum = dtmMesh.rticData[dtmIDX].elaborateLink.size();
//                            //									Log.i("ljr", "tileID:"+tileID.toString()+" sum: "+sum);
//                            //								}
//                        }
//                    }
//                    //						 dtmsum ++;
//                    //						 if(dtmsum>1){
//                    //							 Log.i("ljr",dtmMesh.meshID+" 重复的Rtci："+rticId);
//                    //						 }
//                    //						 break;
//                }
//            }
//            //				 if(dtmsum>1){
//            //					 Log.i("ljr",dtmMesh.meshID+" 重复个数："+dtmsum);
//            ////				 dtmSumAll++;
//            //				
//            //				
//            //				 }
//        }
//        result = 1;
//        // if(dtmSumAll>0){
//        // Log.i("ljr",dtmMesh.meshID+" 重复的Rtci有："+dtmSumAll);
//        // }
//        // Log.i("ljr", "匹配："+ dtmMesh.meshID +" 精细化个数："+sum );
//        
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//    return result;
//}

//描画DTM
- (void)drawDTMTile:(CNMKQueryElement *)element stu_tile:(CNMKDTMTileModel *)tileData
{
 
    CNMKDTMCache *tileCache = nil;
    BOOL bReused = NO;
    for(CNMKDTMCache *tileCacheTmp in dtmTileCaches)
    {
        if ([tileCacheTmp match:element.tileID])
        {
            tileCache = tileCacheTmp;
            bReused = YES;
            //[tileCache.tileImage release];
            break;
        }
    }
    
    if (!bReused)
    {
        for (int i = 0; i < dtmTileCaches.count; i++)
        {
            CNMKDTMCache *cache = dtmTileCaches[i];
            BOOL bDelete = TRUE;
            //  NSLog(@"TileCount:%d",TileCount);
            for (int k = 0; k < TileCount; k++)
            {
                @autoreleasepool {
                    NSString *cacheTileStr=[NSString stringWithFormat:@"%ld_%ld_%ld",(long)cache.tileID.X,(long)cache.tileID.Y,(long)cache.tileID.Z];
                    if ([cacheTileStr isEqualToString:[NSString stringWithUTF8String:TileIDValue[k]]])
                    {
                        bDelete = FALSE;
                        //NSLog(@"字典里有当前屏幕的tile:%@",[NSString stringWithUTF8String:TileIDValue[k]]);
                    }
                    //NSLog(@"当前屏幕的tile:%@",[NSString stringWithUTF8String:TileIDValue[k]]);
                }
            }
            if (bDelete)
            {
                tileCache = cache;
                break;
            }
        }
        
        
    }

    if (tileCache)
    {
        
        [tileCache setTile:element.tileID tileData:(__bridge DTMTTileData *)(element)];
        
        //...制作图片
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:element, @"queryElement", tileCache, @"tileCache", [NSValue valueWithPointer:nil], @"tileImage",
                                         [NSNumber numberWithDouble:-1.0f], @"timestamp", nil];
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        context = nil;
        context = CGBitmapContextCreate(NULL, CNMKDEF_TILE_WIDTH, CNMKDEF_TILE_HEIGHT, 8, 4*CNMKDEF_TILE_WIDTH, colorSpace, kCGImageAlphaPremultipliedFirst);
        CGContextTranslateCTM(context, 0.0, 256.0);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextSetLineWidth(context, 3.0);//...描画线宽
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        
        
        for (int i=0; i<tileData.meshCnt; i++)
        {
            CNMKDTMMeshData *mesh = tileData.meshArrary[i];
            for (int j=0; j< mesh.rticCnt; j++)
            {
                //...写入TileID
                //                UIGraphicsPushContext(context);
                //                CGContextSetRGBFillColor(context, 1, 0, 1, 1);
                //                [ tileData.tile_id drawAtPoint:CGPointMake(0, 0) withFont:[UIFont boldSystemFontOfSize:20.0f]];
                //                UIGraphicsPopContext();
                //...写入TileID
                
                CGContextSaveGState(context);
                CNMKDTMRticData *rtic = mesh.RticArrary[j];
                int count = rtic.pointCnt;
                
                CGPoint addLines[count];
                
                for (int k=0; k<rtic.pointCnt; k++)
                {
                    CNMKPointData *point = rtic.pointArrary[k];
                    addLines[k].x = point.x;
                    addLines[k].y = point.y;
                }
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                
                CGContextBeginPath(context);
                
                CGContextAddLines(context, addLines, count);
                
                CGColorRef lineColor;
                if (rtic.tjamState == 1)
                {
                    //…畅通
                    lineColor = CGColorCreate(colorSpace, (CGFloat[]){80.0f/255.0f,191.0f/255.0f ,57.0f/255.0f,1});
                    
                    //…畅通
                    //lineColor = [[UIColor colorWithRed:80.0f/255.0f green:191.0f/255.0f blue:57.0f/255.0f alpha:1.0f] CGColor];
                    
                }
                else if(rtic.tjamState == 2)
                {
                    //…缓慢
                    lineColor = CGColorCreate(colorSpace, (CGFloat[]){255.0f/255.0f,204.0f/255.0f ,51.0f/255.0f,1});
                    //lineColor = [[UIColor colorWithRed:255.0f/255.0f green:159.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor];
                }
                else if(rtic.tjamState == 3)
                {
                    //…拥堵
                    lineColor = CGColorCreate(colorSpace, (CGFloat[]){242.0f/255.0f,48.0f/255.0f ,48.0f/255.0f,1});
                    //lineColor = [[UIColor colorWithRed:242.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f] CGColor];
                }
                else if(rtic.tjamState == 0)
                {
                    //…事件，不画
                    lineColor = CGColorCreate(colorSpace, (CGFloat[]){32.0f/255.0f,37.0f/255.0f ,50.0f/255.0f,1});
                    //lineColor = [[UIColor colorWithRed:80.0f/255.0f green:191.0f/255.0f blue:57.0f/255.0f alpha:0.0f] CGColor];
                }
                //…设置线风格
                CGContextSetStrokeColorWithColor(context, lineColor);
                CGColorRelease(lineColor);
                CGContextStrokePath(context);
                CGContextRestoreGState(context);
                
                //开始描画精细化路况
                if(rtic.elaborateArray != nil)
                {
                    
                    
                    for (CNMKElaborate *elaborateModel in rtic.elaborateArray)
                    {
                        if (elaborateModel.elaborateDeg == rtic.tjamState)
                        {
                            continue;
                        }
                        
                        CGPoint addLinesNew[elaborateModel.elaboratePoint.count];
                        CGContextSaveGState(context);
                        CGContextSetLineWidth(context, 5.0);//...描画线宽
                        CGContextSetBlendMode(context, kCGBlendModeNormal);
                        CGContextBeginPath(context);
                        
                        for (int k2 = 0; k2 < elaborateModel.elaboratePoint.count; k2++)
                        {
                            
                            ComputePoint *points = elaborateModel.elaboratePoint[k2];
                            addLinesNew[k2].x = points.x;
                            addLinesNew[k2].y = points.y;
                            
                        }
                        CGContextAddLines(context, addLinesNew, elaborateModel.elaboratePoint.count);
                        
                        CGColorRef lineColorDetail;
                        if (elaborateModel.elaborateDeg == 1)
                        {
                            //…畅通
                            lineColorDetail = CGColorCreate(colorSpace, (CGFloat[]){80.0f/255.0f,191.0f/255.0f ,57.0f/255.0f,1});
                            
                        }
                        else if(elaborateModel.elaborateDeg == 2)
                        {
                            //…缓慢
                            lineColorDetail = CGColorCreate(colorSpace, (CGFloat[]){255.0f/255.0f,204.0f/255.0f ,51.0f/255.0f,1});
                        }
                        else if(elaborateModel.elaborateDeg == 3)
                        {
                            //…拥堵
                            lineColorDetail = CGColorCreate(colorSpace, (CGFloat[]){242.0f/255.0f,48.0f/255.0f ,48.0f/255.0f,1});
                        }
                        else if(elaborateModel.elaborateDeg == 0)
                        {
                            //…事件，不画
                            lineColorDetail = CGColorCreate(colorSpace, (CGFloat[]){32.0f/255.0f,37.0f/255.0f ,50.0f/255.0f,1});
                        }
                        
                        CGContextSetStrokeColorWithColor(context, lineColorDetail);
                        CGContextStrokePath(context);
                        CGContextRestoreGState(context);
                        CGColorRelease(lineColorDetail);
                    }
                    
                }
                
                
            }
        }
        
        CGImageRef tileImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        [userInfo setObject:[NSValue valueWithPointer:tileImage] forKey:@"tileImage"];
        
            
        

        // NSLog(@"dddddddksksks:%p",userInfo);
        [self performSelectorOnMainThread:@selector(updateDTMTileImage:) withObject:userInfo waitUntilDone:NO];//...多线程更新
    }

}

//通知显示DTM图片
- (void)updateDTMTileImage:(id)userInfo
{
    CNMKQueryElement *element = [userInfo objectForKey:@"queryElement"];
    CNMKDTMCache *tileCache = [userInfo objectForKey:@"tileCache"];
    CGImageRef tileImage = [[userInfo objectForKey:@"tileImage"] pointerValue];
    
    userInfo = nil;
    [tileCache.tileLock lock];
    if (tileImage)
    {
        tileCache.tileImage = [UIImage imageWithCGImage:tileImage];
    }
    else
    {
        tileCache.tileImage = nil;
        //NSLog(@"tileImage is nil:%ld_%ld_%ld",(long)element.tileID.X,(long)element.tileID.Y,(long)element.tileID.Z);
    }
    CGImageRelease(tileImage);
    
    [tileCache.tileLock unlock];
    
   // NSLog(@"dtmTileCaches:%ld",dtmTileCaches.count);
    
    //element.queryState = CNMKDTMQueryStateFinish;
    [self queryCompleted:element];
}

- (void)queryCompleted:(CNMKQueryElement *)element
{
    //NSLog(@"queryCompletedStart=%ld_%ld_%ld delegateCnt=%lu",(long)element.tileID.X,(long)element.tileID.Y,(long)element.tileID.Z, (unsigned long)element.delegates.count);
    for (NSNumber *number in element.delegates)
    {
        int delegateIndex = [number intValue];
        id <CNMKManagerInternalDelegate> delegate = [[CNMKManagerInternal alloc]  getDelegateForIndex:delegateIndex];
        //NSLog(@"delegateFor=%ld_%ld_%ld",(long)element.tileID.X,(long)element.tileID.Y,(long)element.tileID.Z);
        if (delegate && [delegate respondsToSelector:@selector(managerDownloadADTMTile:)])
        {
            //NSLog(@"queryCompleted=%ld_%ld_%ld",(long)element.tileID.X,(long)element.tileID.Y,(long)element.tileID.Z);
            [delegate managerDownloadADTMTile:element.tileID];
        }
    }
    [dataMgr queryCompleted:element];
    
}


//得到图片数据
- (UIImage *)getDTMTileImage:(TileID)tileID
{
    UIImage * tileImage = nil;
    //NSLog(@"getDTMTileImage:%ld_%ld_%ld", tileID.X, tileID.Y,tileID.Z);

    for (CNMKDTMCache *tileCache in dtmTileCaches)
    {
        if ([tileCache match:tileID])
        {
            tileImage = tileCache.tileImage;
            if (tileImage != nil)
            {
                //NSLog(@"getDTMTileImage:%ld_%ld_%ld", tileID.X, tileID.Y,tileID.Z);
            }
            break;
        }
    }
    
    return tileImage;
}


/**
 *  精细化数据获取方法
 *
 *  @param points           dtm路网的Rtic数据
 *  @param JamElaborateList dtm路况的Rtic数据
 *  @return 装有CNMKElaborate（精细化数据）的数组
 */
-(NSMutableArray *)bidElaborateDtmPoint:(CNMKDTMRticData *)points JamHeadElaborate:(CNMKRticModel *)JamElaborateList
{
    NSMutableArray *dtmElaborateList= [[NSMutableArray alloc] init];
    for (CNMKHeadElaborateModel *dtmHeadElaborate in JamElaborateList.subInf) {
        if (dtmHeadElaborate == nil || dtmHeadElaborate.dLen <= 0) {
            continue;
        }
        NSInteger startDis = dtmHeadElaborate.sLen;
        NSInteger endDis = dtmHeadElaborate.sLen + dtmHeadElaborate.dLen;
        NSMutableArray *pointList=[NSMutableArray array];
        // 每个点循环计算
        for (int i = 0; i < points.pointCnt; i++) {
            CNMKPointData *p = points.pointArrary[i];
            if (p.distance == startDis) {
                // 起点在P上
                [pointList addObject:p];
            } else if (p.distance < startDis) {
                if (i + 1 < points.pointCnt) {
                    CNMKPointData *p2 = points.pointArrary[i + 1];
                    if (p2 != nil && p2.distance > startDis) {
                        // 起点在p和p2之间
                        ComputePoint *startPoint =[self makeElaborateStartPoint:p endPoint:p2 distance:fabs(dtmHeadElaborate.sLen -p.distance)];
                                               if (startPoint != nil){
                            [pointList addObject:startPoint];
                        }
                    }
                }
            } else if (p.distance > startDis && p.distance < endDis) {
                // 中间点
                //pointList.add(p);
                [pointList addObject:p];
            } else if (p.distance == endDis) {
                // 终点在p上
                // pointList.add(p);
               

                [pointList addObject:p];
                break;
            } else if (p.distance > endDis) {
                // 终点在px-1 到px中
                if (i - 1 < points.pointCnt && i > 0) {
                    CNMKPointData *p0 = points.pointArrary[i - 1];
                    ComputePoint *endPoint=[self makeElaborateStartPoint:p0 endPoint:p distance:fabs(endDis -p0.distance)];
                   

                    if (endPoint != nil){
                        
                        [pointList addObject:endPoint];
                    }
                }
                break;
            }
        }
        
        if(pointList.count > 1)
        {
            CNMKElaborate *one =[[CNMKElaborate alloc]initWithElaboratePoint:pointList elaborateDeg:dtmHeadElaborate.subDeg];
            [dtmElaborateList addObject:one];
            
        }
        
    }
    
    if(dtmElaborateList.count < 1)
    {
        return nil;
    }
    return dtmElaborateList;
}




/**
 * 计算精细化点数据
 * @param tileID
 *
 * @param startPoint
 *            起点
 * @param endPoint
 *            终点
 * @param dis（米）
 *            距离startPoint点的距离
 * @return 在startPoint endPoint线段上startPoint，dis距离米的点
 */
-(ComputePoint *)makeElaborateStartPoint:(CNMKPointData *)startPoint endPoint:(CNMKPointData *)endPoint distance:(double)dis
{
    // 相似三角形
    // 线段的长度 sum = p2.d-p1.d
    // p到P1的距离 disen = slen-p1.d
    // (px - p1x)/disen = (p2x-p1x)/sum
    // (py-p1y)/deisn = (p2y-p1y)/sum
    
    if (startPoint == nil || endPoint == nil) {
        return nil;
    }
    float lenX = endPoint.x - startPoint.x;
    float lenY = endPoint.y - startPoint.y;
    double lenSum = fabs(endPoint.distance - startPoint.distance);
    double x = startPoint.x + dis  * lenX / lenSum;
    double y = startPoint.y + dis  * lenY / lenSum;
    ComputePoint *result =[[ComputePoint alloc] initWithComputePointX:(NSInteger)x ComputePointY:(NSInteger)y];
    return result;
}




@end
