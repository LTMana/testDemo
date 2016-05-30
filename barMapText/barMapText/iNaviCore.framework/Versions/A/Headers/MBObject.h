//
//  MBEngineDateObject.h
//  iNaviCore
//
//  Created by fanyl on 14-4-29.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBNaviCoreTypes.h"

/**
 *  数据类型基础类，客户端无需直接调用
 */
@interface MBObject : NSObject

-(id)initWithHandle:(void*)handle;
-(void*)getHandle;
@end
