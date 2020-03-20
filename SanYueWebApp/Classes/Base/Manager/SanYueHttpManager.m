//
//  SanYueHttpManager.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueHttpManager.h"
@interface SanYueHttpManager()
@property (nonatomic,assign)NSTimeInterval timeout;
@end
@implementation SanYueHttpManager
static SanYueHttpManager *_sharedInstance = nil;
+(id)shareInstance{
    // 线程安全
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}
+(void)deletInstance{
    _sharedInstance = nil;
}
// 确保所有渠道生成的对象都是同一个
+(id) allocWithZone:(struct _NSZone *)zone{
    return [SanYueHttpManager shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone{
    return [SanYueHttpManager shareInstance] ;
}
-(void)setUpInit{
    self.timeout = 15.0f;
    self.requestSerializer.timeoutInterval = self.timeout;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
}
- (void)setTimeout:(NSTimeInterval)timeout{
    _timeout = timeout;
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = _timeout;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
- (void)setHttpHeader:(nullable NSDictionary *)header{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self setTimeout:_timeout];
    if (header) {
        for (NSString *key in header) {
            NSString *value = [header objectForKey:key];
            [self.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    else{
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
}
- (nullable NSURLSessionDataTask *)fetch:(NSString *)methodType url:(NSString *)URLString parameters:(nullable id)parameters header:(nullable id)header progress:(nullable void (^)(NSProgress *downloadProgress))progress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task,NSError *error))failure;{
    NSURLSessionDataTask *task;
    [self setHttpHeader:header];
    if ([methodType isEqualToString:@"GET"]) {
        task = [self GET:URLString parameters:parameters progress:progress success:success failure:failure];
    }
    else if ([methodType isEqualToString:@"POST"]) {
        task = [self POST:URLString parameters:parameters progress:progress success:success failure:failure];
    }
    else if ([methodType isEqualToString:@"PUT"]) {
        task = [self PUT:URLString parameters:parameters success:success failure:failure];
    }
    else if ([methodType isEqualToString:@"PATCH"]) {
        task = [self PATCH:URLString parameters:parameters success:success failure:failure];
    }
    else if ([methodType isEqualToString:@"DELETE"]) {
        task = [self DELETE:URLString parameters:parameters success:success failure:failure];
    }
    return task;
}
@end
