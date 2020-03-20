//
//  SanYueCacheItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueCacheItem : NSObject
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *cache;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
