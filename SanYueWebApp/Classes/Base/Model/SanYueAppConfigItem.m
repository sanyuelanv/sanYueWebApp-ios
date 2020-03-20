//
//  SanYueAppConfigItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/10.
//

#import "SanYueAppConfigItem.h"

@implementation SanYueAppConfigItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _hideNav = [self getBoolByName:@"hideNav" and:dict];
        _bounces = [self getBoolByName:@"bounces" and:dict];
        _networkTimeout = [self getIntByName:@"networkTimeout" and:dict andDef:20];
        _statusStyle = [self getStringByName:@"statusStyle" and:dict andDef:@"dark"];
        _backgroundColor = [self getStringByName:@"backgroundColor" and:dict andDef:@"#f1f1f1"];
        if(!_hideNav){
            _navBackgroundColor = [self getStringByName:@"navBackgroundColor" and:dict andDef:@"#f1f1f1"];
            _title = [self getStringByName:@"title" and:dict andDef:@""];
            _titleColor = [self getStringByName:@"titleColor" and:dict andDef:@"#000000"];
        }
    }
    return self;
}
-(instancetype)initWithDict:(NSDictionary *)dict andDef:(SanYueAppConfigItem *)item{
    self = [super init];
    if(self){
        _hideNav = item.hideNav;
        _bounces = item.bounces;
        _networkTimeout = item.networkTimeout;
        _backgroundColor = item.backgroundColor;
        // 重新设置
        _statusStyle = [self getStringByName:@"statusStyle" and:dict andDef:@"dark"];
        _navBackgroundColor = [self getStringByName:@"navBackgroundColor" and:dict andDef:item.backgroundColor];
        _title = [self getStringByName:@"title" and:dict andDef:item.title];
        _titleColor = [self getStringByName:@"titleColor" and:dict andDef:item.titleColor];
    }
    return self;
}
@end
