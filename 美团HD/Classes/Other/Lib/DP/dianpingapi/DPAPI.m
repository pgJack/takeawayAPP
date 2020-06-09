//
//  DPAPI.m
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import "DPAPI.h"
#import "DPConstants.h"

typedef void (^DPBlock)(id result, NSError *error);

@interface DPAPI () <DPRequestDelegate>
{
    NSMutableSet *_requests;
}
/** 存放所有请求的 block */
@property (nonatomic, strong) NSMutableDictionary *blocks;

@end


@implementation DPAPI
#pragma mark - 懒加载
- (NSMutableDictionary *)blocks
{
    if (_blocks == nil) {
        _blocks = [[NSMutableDictionary alloc] init];
    }
    return _blocks;
}

#pragma mark - 后来自己添加的代码
- (DPRequest *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure
{
    // 发送请求
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    DPRequest *request = [self requestWithURL:url params:mutableParams delegate:self];
    
    // 存储这次请求对应的 block
    NSString *key = request.description;
    self.blocks[key] = ^(id result, NSError *error) {
        if (result && success) {
            success(result);
        } else if (error && failure) {
            failure(error);
        }
    };
    
    // 返回请求对象
    return request;
}
#pragma mark - 单例模式
HMSingleton_M

#pragma mark - <DPRequestDelegate>
/**
 *  请求成功
 *
 *  @param request 请求
 *  @param result  成功的信息
 */
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    DPBlock block = self.blocks[request.description];
    block(result, nil);
    
//    ^(id result, NSError *error) {
//        if (result && success) {
//            success(result);
//        } else if (error && failure) {
//            failure(error);
//        }
//    }(result, nil);
}

/**
 *  请求失败
 *
 *  @param request 请求
 *  @param error   失败的信息
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    DPBlock block = self.blocks[request.description];
    block(nil, error);
}


#pragma mark - 大众点评原来的代码
- (id)init {
	self = [super init];
    if (self) {
        _requests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate {
	if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
	NSString *fullURL = [kDPAPIDomain stringByAppendingString:url];
	
	DPRequest *_request = [DPRequest requestWithURL:fullURL
											 params:params
										   delegate:delegate];
	_request.dpapi = self;
	[_requests addObject:_request];
	[_request connect];
	return _request;
}

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate {
	return [self requestWithURL:[NSString stringWithFormat:@"%@?%@", url, paramsString] params:nil delegate:delegate];
}

- (void)requestDidFinish:(DPRequest *)request
{
    [_requests removeObject:request];
    request.dpapi = nil;
}

- (void)dealloc
{
    for (DPRequest* _request in _requests)
    {
        _request.dpapi = nil;
    }
}

@end
