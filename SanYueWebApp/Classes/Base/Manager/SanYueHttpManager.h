//
//  SanYueHttpManager.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface SanYueHttpManager : AFHTTPSessionManager
+ (instancetype)shareInstance;
+(void)deletInstance;
- (void)setTimeout:(NSTimeInterval)timeout;
- (void)setHttpHeader:(nullable NSDictionary *)header;
- (nullable NSURLSessionDataTask *)fetch:(NSString *)methodType url:(NSString *)URLString parameters:(nullable id)parameters header:(nullable id)header progress:(nullable void (^)(NSProgress *downloadProgress))progress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task,NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
