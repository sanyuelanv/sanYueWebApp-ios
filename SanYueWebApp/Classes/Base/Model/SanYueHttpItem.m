//
//  SanYueHttpItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueHttpItem.h"

@implementation SanYueHttpItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _url = [self getStringByName:@"url" and:dict andDef:nil];
        _data = dict[@"data"];
        _header = dict[@"header"];
        _timeout = [self getIntByName:@"timeout" and:dict andDef:0];
        _method = [self getStringByName:@"method" and:dict andDef:nil];
        if (_url == nil || _method == nil) {
            self = nil;
        }
    }
    return self;
}
@end
