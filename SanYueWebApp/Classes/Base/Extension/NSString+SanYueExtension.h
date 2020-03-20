//
//  NSString+SanYueExtension.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SanYueExtension)
+(NSString*)getCurrentTimes;
- (BOOL)isValidUrl;
+ (NSString *)initWithDict:(NSDictionary *)dict;
+(NSString *)getCachePath;
-(BOOL)DirIsExists:(BOOL)isCache;
-(BOOL)FileIsExists:(BOOL)isCache;
-(void)createDirIfNotExistsInCache;
-(void)delIfExists;
-(void)delIfExistsForAboustURL;
-(NSString *)getCacheSize:(BOOL)isAboustURL;
+(NSString *)callBack:(NSString *)callBack widthParame:(nullable NSDictionary *)dict andError:(nullable NSDictionary *)err andType:(int)type;
@end

NS_ASSUME_NONNULL_END
