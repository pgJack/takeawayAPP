//
//  DPAPI.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPRequest.h"
#import "HMSingleton.h"

typedef void (^DPSuccess)(id json);
typedef void(^DPFailure)(NSError *error);

@interface DPAPI : NSObject

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate;

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate;


// ^(id json) --> void (^)(id json)
// ^(NSError *error) --> void(^)(NSError *error)
/*
 void (^block)(int age) = ^(int age) {
 
 };
 
 block(10);
 */
//- (DPRequest *)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

- (DPRequest *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure;

/**
 *  共享的实例对象
 */
HMSingleton_H

@end
