//
//  MBRouteCollection.h
//  iNaviCore
//
//  Created by fanwei on 3/8/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBRouteBase;
/**
 *   路线集合
 */
@interface MBRouteCollection : NSObject<NSCopying ,NSMutableCopying>
/**
 *  初始化
 *  @return self
 */
-(id)init;
/**
 *  路线条数
 */
@property(assign,nonatomic)NSInteger num;
/**
 *  路线
 */
@property(retain,nonatomic)NSMutableArray *routeBases;
/**
 * 清空路线
 */
- (void) removeALL;
/**
 *  加入路线
 *
 *  @param route 路线
 *
 *  @since 4.9.x
 */
-(void) addRoute:(MBRouteBase*) route;
@end
