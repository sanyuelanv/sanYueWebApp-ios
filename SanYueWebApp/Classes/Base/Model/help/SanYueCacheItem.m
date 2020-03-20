//
//  SanYueCacheItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import "SanYueCacheItem.h"

@implementation SanYueCacheItem
-(instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.date = dict[@"date"];
        self.cache = dict[@"cache"];
    }
    return self;
}

@end
