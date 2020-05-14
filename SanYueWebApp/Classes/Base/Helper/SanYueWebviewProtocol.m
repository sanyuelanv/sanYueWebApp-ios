//
//  SanYueWebviewProtocol.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/5/11.
//

#import "SanYueWebviewProtocol.h"
#import "YYImage.h"
static NSString* const SanYueNSURLProtocolHKey = @"SanYueNSURLProtocolHKey";
@interface SanYueWebviewProtocol()<NSURLSessionDataDelegate>
@property (atomic, strong) NSURLSession *session;
@property (atomic, strong) NSMutableData *data;
@end
@implementation SanYueWebviewProtocol
#pragma mark - 拦截
// 判断是否需要拦截请求
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *scheme = [[request URL] scheme];
//    NSLog(@"2--- %@",[request URL].absoluteURL);
    if (
        (([scheme isEqualToString:@"webp"] || [scheme isEqualToString:@"webps"]  ) || ([scheme isEqualToString:@"file"] && [[[request URL] pathExtension] isEqualToString:@"webp"])) && ![NSURLProtocol propertyForKey:SanYueNSURLProtocolHKey inRequest:request]
        )
    {
        return YES;
    }
    return NO;
}
// 可以在这里修改请求
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    NSURL *url =  mutableReqeust.URL;
    NSString *urlString = url.absoluteString;
    NSString *scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"webp"]) {
        [mutableReqeust setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"webp://" withString:@"http://"]]];
    }
    else if ([scheme isEqualToString:@"webps"]) {
        [mutableReqeust setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"webps://" withString:@"https://"]]];
    }
    NSString *mimeType = @"image/webp";
    [mutableReqeust addValue:mimeType forHTTPHeaderField:@"Accept"];
    return mutableReqeust;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
#pragma mark - 转发
- (void)startLoading{
    NSString *scheme = [[[self request] URL] scheme];
    if ([scheme isEqualToString:@"file"]) {
        NSData *data = [NSData dataWithContentsOfURL:[[self request] URL] options:NSDataReadingMappedAlways error:nil];
        self.data = [data mutableCopy];
        [self changeDataToPng];
    }
    else {
        NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:SanYueNSURLProtocolHKey inRequest:mutableReqeust];
         self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
        [task resume];
    }
    
}
- (void)stopLoading{
    [self.session invalidateAndCancel];
    self.session = nil;
}
- (void)dealloc{
    [self.session invalidateAndCancel];
    self.session = nil;
}

/**  告诉delegate已经接受到服务器的初始应答, 准备接下来的数据任务的操作. */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSHTTPURLResponse *httpRep = [response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)response : nil;
    if (httpRep.statusCode != 200) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.data = [[NSMutableData alloc] init];
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.data appendData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self changeDataToPng];
        
    }
}
-(void)changeDataToPng{
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:self.data scale:1.0];
    UIImage *image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    if (!image) {
        NSError *decodeError = [NSError errorWithDomain:@"ERROR_DECODE" code:1 userInfo:@{}];
        [self.client URLProtocol:self didFailWithError:decodeError];
        return;
    }
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypePNG];
    [encoder addImage:image duration:0];
    NSData *imagePngData = [encoder encode];
    if (imagePngData) {
        [self.client URLProtocol:self didLoadData:imagePngData];
        [self.client URLProtocolDidFinishLoading:self];
    }
}
@end
