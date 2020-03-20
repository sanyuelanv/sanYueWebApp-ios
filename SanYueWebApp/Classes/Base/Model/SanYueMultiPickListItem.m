//
//  SanYueMultiPickListItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/19.
//

#import "SanYueMultiPickListItem.h"

@implementation SanYueMultiPickListItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super self];
    if (self) {
        _name = [self getStringByName:@"name" and:dict andDef:@""];
        NSArray *list = [self getArrayByName:@"children" and:dict andDef:nil];
        NSMutableArray<SanYueMultiPickListItem *> *arr = [NSMutableArray array];
        for (NSDictionary *listItem in list) {
            SanYueMultiPickListItem *item = [[SanYueMultiPickListItem alloc] initWithDict:listItem];
            [arr addObject:item];
        }
        _list = arr;
    }
    return self;
}
@end
