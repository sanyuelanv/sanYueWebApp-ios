//
//  SanYueActionSheetItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueActionSheetItem.h"

@implementation SanYueActionSheetItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSArray *list = [self getArrayByName:@"itemList" and:dict andDef:@[]];
        if (list.count > 6) {
            _itemList = [list subarrayWithRange:NSMakeRange(0, 6)];
        }
        else{
            _itemList = list;
        }
        _itemColor = [self getStringByName:@"itemColor" and:dict andDef:@"#353535"];
        NSString *senseMode = [self getStringByName:@"senseMode" and:dict andDef:@"auto"];
        if ([senseMode isEqualToString:@"light"]) { _senseMode = 1; }
        else if ([senseMode isEqualToString:@"dark"]) { _senseMode = 2; }
        else{ _senseMode = 0; }
        _itemColorDark = [self getStringByName:@"itemColorDark" and:dict andDef:@"#BBBBBB"];;
        _title = [self getStringByName:@"title" and:dict andDef:nil];
        _cancelText = [self getStringByName:@"cancelText" and:dict andDef:@"取消"];
        _cancelColor = [self getStringByName:@"cancelColor" and:dict andDef:@"#e64340"];
        _cancelColorDark = [self getStringByName:@"cancelColorDark" and:dict andDef:@"#CD5C5C"];
        _backGroundCancel = [self getBoolByName:@"backGroundCancel" and:dict];
    }
    return self;
}
@end
