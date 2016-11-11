//
//  LTRequest.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/11.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTRequest.h"

@implementation LTRequest

+ (instancetype)request {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPSessionManager manager];
    }
    return self;
}


- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(LTRequest *, id ))success
    failure:(void (^)(LTRequest *, NSError *))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.operationManager GET:URLString parameters:parameters   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        NSLog(@" GET  请求成功 ");
        success(self,object);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"[JMRequest]: 请求失败 %@",error.localizedDescription);
        failure(self,error);
    }];
    
}


- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(LTRequest *request, id response))success
     failure:(void (^)(LTRequest *request, NSError *error))failure{
    
    self.operationQueue = self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.operationManager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        NSLog(@"[JMRequest]:POST 请求成功 %@",object);
        success(self,object);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"[JMRequest]: 请求失败 %@",error.localizedDescription);
        failure(self,error);
        
    }];
    
}


- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    [self POST:URLString
    parameters:parameters
       success:^(LTRequest *request, id  response) {
           if ([self.delegate respondsToSelector:@selector(LTRequest:finished:)]) {
               [self.delegate LTRequest:request finished:response];
               
           }
       }
       failure:^(LTRequest *request, NSError *error) {
           if ([self.delegate respondsToSelector:@selector(LTRequest:Error:)]) {
               [self.delegate LTRequest:request Error:error.description];
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(LTRequest *request, id response) {
        if ([self.delegate respondsToSelector:@selector(LTRequest:finished:)]) {
            [self.delegate LTRequest:request finished:response];
        }
    } failure:^(LTRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(LTRequest:Error:)]) {
            [self.delegate LTRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}




@end
