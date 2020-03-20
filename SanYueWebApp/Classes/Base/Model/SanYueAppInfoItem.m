//
//  SanYueAppInfoItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//

#import "SanYueAppInfoItem.h"
#import "NSString+SanYueExtension.h"
#import "SanYueWebAppItem.h"
#include <sys/utsname.h>
@interface SanYueAppInfoItem()
@property (nonatomic,assign)int maxRouterNumber;
@property (nonatomic,strong)NSString *phoneName;
@property (nonatomic,strong)NSString *system;
@property (nonatomic,strong)NSString *systemVersion;
@property (nonatomic,assign)CGFloat screenWidth;
@property (nonatomic,assign)CGFloat screenHeight;
@property (nonatomic,assign)CGFloat statusBarHeight;
@end
@implementation SanYueAppInfoItem
static SanYueAppInfoItem *_sharedInstance = nil;
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
    return [SanYueAppInfoItem shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone{
    return [SanYueAppInfoItem shareInstance] ;
}

- (NSString *)phoneName{
    if(!_phoneName){
        struct utsname systemInfo;
        uname(&systemInfo); // 获取系统设备信息
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        
        NSDictionary *dict = @{
                               // iPhone
                               @"iPhone5,3" : @"iPhone 5c",
                               @"iPhone5,4" : @"iPhone 5c",
                               @"iPhone6,1" : @"iPhone 5s",
                               @"iPhone6,2" : @"iPhone 5s",
                               @"iPhone7,1" : @"iPhone 6 Plus",
                               @"iPhone7,2" : @"iPhone 6",
                               @"iPhone8,1" : @"iPhone 6s",
                               @"iPhone8,2" : @"iPhone 6s Plus",
                               @"iPhone8,4" : @"iPhone SE",
                               @"iPhone9,1" : @"iPhone 7",
                               @"iPhone9,2" : @"iPhone 7 Plus",
                               @"iPhone10,1" : @"iPhone 8",
                               @"iPhone10,4" : @"iPhone 8",
                               @"iPhone10,2" : @"iPhone 8 Plus",
                               @"iPhone10,5" : @"iPhone 8 Plus",
                               @"iPhone10,3" : @"iPhone X",
                               @"iPhone10,6" : @"iPhone X",
                               @"iPhone11,2" : @"iPhone XS",
                               @"iPhone11,4" : @"iPhone XS Max",
                               @"iPhone11,6" : @"iPhone XS Max",
                               @"iPhone11,8" : @"iPhone XR",
                               @"iPhone12,1" : @"iPhone 11",
                               @"iPhone12,3" : @"iPhone 11 Pro",
                               @"iPhone12,5" : @"iPhone 11 Pro Max",
                               @"i386" : @"iPhone Simulator",
                               @"x86_64" : @"iPhone Simulator",
                               // iPad
                               @"iPad4,1" : @"iPad Air",
                               @"iPad4,2" : @"iPad Air",
                               @"iPad4,3" : @"iPad Air",
                               @"iPad5,3" : @"iPad Air 2",
                               @"iPad5,4" : @"iPad Air 2",
                               @"iPad6,7" : @"iPad Pro 12.9",
                               @"iPad6,8" : @"iPad Pro 12.9",
                               @"iPad6,3" : @"iPad Pro 9.7",
                               @"iPad6,4" : @"iPad Pro 9.7",
                               @"iPad6,11" : @"iPad 5",
                               @"iPad6,12" : @"iPad 5",
                               @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                               @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                               @"iPad7,3" : @"iPad Pro 10.5",
                               @"iPad7,4" : @"iPad Pro 10.5",
                               @"iPad7,5" : @"iPad 6",
                               @"iPad7,6" : @"iPad 6",
                               // iPad mini
                               @"iPad2,5" : @"iPad mini",
                               @"iPad2,6" : @"iPad mini",
                               @"iPad2,7" : @"iPad mini",
                               @"iPad4,4" : @"iPad mini 2",
                               @"iPad4,5" : @"iPad mini 2",
                               @"iPad4,6" : @"iPad mini 2",
                               @"iPad4,7" : @"iPad mini 3",
                               @"iPad4,8" : @"iPad mini 3",
                               @"iPad4,9" : @"iPad mini 3",
                               @"iPad5,1" : @"iPad mini 4",
                               @"iPad5,2" : @"iPad mini 4",
                               };
        NSString *name = dict[platform];
        _phoneName = name ? name : platform;
    }
    return _phoneName;
}
- (NSString *)system{
    if(!_system){
        _system = @"iOS";
    }
    return _system;
}
- (NSString *)systemVersion{
    if(!_systemVersion){
        _systemVersion = [[UIDevice currentDevice] systemVersion];
    }
    return _systemVersion;
}
- (CGFloat)screenWidth{
    if (!_screenWidth) {
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenWidth;
}
- (CGFloat)screenHeight{
    if (!_screenHeight) {
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenHeight;
}
- (CGFloat)statusBarHeight{
    if (!_statusBarHeight) {
        _statusBarHeight = self.screenHeight >= 812 ? 44.0 : 20.0;
    }
    return _statusBarHeight;
}
-(NSDictionary *)getAllMsgDictBy:(BOOL)hideNav{
    NSNumber *width = [NSNumber numberWithFloat:self.screenWidth];
    NSNumber *height = [NSNumber numberWithFloat:self.screenHeight];
    CGFloat h = hideNav ? self.screenHeight : self.screenHeight - self.statusBarHeight - 44;
    NSNumber *wh = [NSNumber numberWithFloat:h];
    NSNumber *statusH = [NSNumber numberWithFloat:self.statusBarHeight];
    SanYueWebAppItem *item = [SanYueWebAppItem shareInstance];
    NSDictionary *dict = @{
        @"phoneName":self.phoneName,
        @"system":self.system,
        @"systemVersion":self.systemVersion,
        @"screenWidth":width,
        @"screenHeight":height,
        @"windowWidth":width,
        @"windowHeight":wh,
        @"statusBarHeight":statusH,
        @"size":item.size,
        @"date":item.date
    };
    return dict;
}
@end
