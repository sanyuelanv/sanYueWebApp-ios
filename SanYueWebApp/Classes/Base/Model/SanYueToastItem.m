//
//  SanYueToastItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueToastItem.h"

@implementation SanYueToastItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _mask = [self getBoolByName:@"mask" and:dict];
        _time = [self getFloatByName:@"time" and:dict andDef:1.5];
        _content = [self getStringByName:@"content" and:dict andDef:@""];
    }
    return self;
}
@end
