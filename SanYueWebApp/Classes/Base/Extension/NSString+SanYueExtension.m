//
//  NSString+SanYueExtension.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import "NSString+SanYueExtension.h"



@implementation NSString (SanYueExtension)

+(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
- (BOOL)isValidUrl{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
+ (NSString *)initWithDict:(NSDictionary *)dict{
    NSError *parseError = nil;
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
+(NSString *)getCachePath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}
-(BOOL)DirIsExists:(BOOL)isCache{
    NSString *dirPath = self;
    if (isCache) {
        NSString *path = [NSString getCachePath];
        dirPath = [path stringByAppendingPathComponent:self];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    return (existed && isDir);
}
-(BOOL)FileIsExists:(BOOL)isCache{
    NSString *dirPath = self;
    if (isCache) {
        NSString *path = [NSString getCachePath];
        dirPath = [path stringByAppendingPathComponent:self];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    return (existed && !isDir);
}
-(void)createDirIfNotExistsInCache{
    NSString *path = [NSString getCachePath];
    NSString *dirPath = [path stringByAppendingPathComponent:self];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![self DirIsExists:YES]){
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
-(void)delIfExists{
    NSString *path = [NSString getCachePath];
    NSString *dirPath = [path stringByAppendingPathComponent:self];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if(existed){
        [fileManager removeItemAtPath:dirPath error:nil];
    }
}
-(void)delIfExistsForAboustURL{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    if(existed){
        [fileManager removeItemAtPath:self error:nil];
    }
}
+ (NSString *)callBack:(NSString *)callBack widthParame:(nullable NSDictionary *)dict andError:(nullable NSDictionary *)err andType:(int)type{
    NSString *parame = dict == nil ? @"null" : [NSString initWithDict:dict];
    NSString *error = err == nil ? @"null" : [NSString initWithDict:err];
    NSString *res;
    switch (type) {
        // 普通的接口ID返回，返回后消去前端的ID，不可再用
        case 0:{
            res = [NSString stringWithFormat:@"SanYueWebApp.CALLBACK[%@](%@,%@)",callBack,parame,error];
            break;
        }
        // 接口ID，但不会消去前端的ID，能多次返回，直到调用 0 号接口才会消去。
        case 1:{
            res = [NSString stringWithFormat:@"SanYueWebApp.CALLBACK[%@](%@,%@,true)",callBack,parame,error];
            break;
        }
        // 前端监听 API 返回
        case 2:{
            res = [NSString stringWithFormat:@"SanYueWebApp.pub('%@',%@,%@)",callBack,parame,error];
            break;
        }
        
    }
    return res;
}

-(NSString *)getCacheSize:(BOOL)isAboustURL{
    NSString *path = self;
    if (!isAboustURL) {
        NSString *cachePath = [NSString getCachePath];
        path = [NSString stringWithFormat:@"%@/%@",cachePath,self];
    }
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        filePath =[path stringByAppendingPathComponent:subPath];
        BOOL isDirectory = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            continue;
        }
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        totleSize += size;
    }
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

@end
