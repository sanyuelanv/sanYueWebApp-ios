//
//  SanYueRouterItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/20.
//

#import "SanYueRouterItem.h"

@implementation SanYueRouterItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super self];
    if (self) {
        _name = [self getStringByName:@"name" and:dict andDef:nil];
        _isToRoot = [self getBoolByName:@"root" and:dict];
        _extra = dict[@"extra"];
    }
    return self;
}
@end
