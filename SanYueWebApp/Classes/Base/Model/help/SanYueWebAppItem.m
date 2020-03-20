//
//  SanYueWebAppItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/20.
//

#import "SanYueWebAppItem.h"
#import "NSString+SanYueExtension.h"

@implementation SanYueWebAppItem
static SanYueWebAppItem *_sharedInstance = nil;
+(id)shareInstance{
    // 线程安全
    if(_sharedInstance == nil){
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}
+(void)deletInstance{
    _sharedInstance = nil;
}
// 确保所有渠道生成的对象都是同一个
+(id) allocWithZone:(struct _NSZone *)zone{
    return [SanYueWebAppItem shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone{
    return [SanYueWebAppItem shareInstance] ;
}
- (NSString *)size{
    if (!_size) {
        _size = [_rootPath getCacheSize:YES];
    }
    return _size;
}
@end
