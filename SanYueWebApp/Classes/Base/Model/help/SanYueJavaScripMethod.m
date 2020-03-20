//
//  SanYueJavaScripMethod.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/8.
//

#import "SanYueJavaScripMethod.h"
@interface SanYueJavaScripMethod()
@property (nonatomic,strong)NSArray *customJsMethods;
@property (nonatomic,strong)NSArray *defaultJsMethods;
@end
@implementation SanYueJavaScripMethod
static SanYueJavaScripMethod *_sharedInstance = nil;
- (NSArray *)defaultJsMethods{
    if(!_defaultJsMethods){
        _defaultJsMethods = @[
            @"SanYue_init",
            @"SanYue_fetch",
            @"SanYue_getSystemInfo",
            @"SanYue_setStatusStyle",
            @"SanYue_showModal",
            @"SanYue_showActionSheet",
            @"SanYue_vibrateLong",
            @"SanYue_vibrateShort",
            @"SanYue_getNetworkType",
            @"SanYue_setClipboardData",
            @"SanYue_getClipboardData",
            @"SanYue_showToast",
            @"SanYue_showLoad",
            @"SanYue_hiddenLoad",
            @"SanYue_setNavBar",
            @"SanYue_showPick",
            @"SanYue_fetch_stop",
            @"SanYue_navPush",
            @"SanYue_navPop",
            @"SanYue_setPopExtra",
            @"SanYue_navReplace",
            @"SanYue_restart",
        ];
    }
    return _defaultJsMethods;
}
-(NSArray *)getAllMethods{
    return self.customJsMethods ? [self.defaultJsMethods arrayByAddingObjectsFromArray:self.customJsMethods] :self.defaultJsMethods;
}
-(NSArray *)getDefaultMethods{
    return self.defaultJsMethods;
}
-(NSArray *)getCustomMethods{
    return self.customJsMethods;
}
-(BOOL)setCustomMethods:(NSString *)name{
    NSArray *allJsMethods =  [self getAllMethods];
    BOOL flag = YES;
    for (NSString *methodName in allJsMethods) {
        if ([name isEqualToString:methodName]) {
            flag = NO;
            break;
        }
    }
    if (flag) {
        NSMutableArray *customJsMethods = self.customJsMethods ? [NSMutableArray arrayWithArray:self.customJsMethods] : [NSMutableArray array];
        [customJsMethods addObject:name];
        self.customJsMethods = customJsMethods;
    }
    return flag;
}


@end
