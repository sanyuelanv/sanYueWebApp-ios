//
//  SanYuePickItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/14.
//

#import "SanYuePickItem.h"
#import "SanYueMultiPickListItem.h"
@implementation SanYuePickItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _listenChange = [self getBoolByName:@"listenChange" and:dict];
        NSString *mode = [self getStringByName:@"mode" and:dict andDef:@"normal"];
        _backGroundCancel = [self getBoolByName:@"backGroundCancel" and:dict];
        
        NSString *senseMode = [self getStringByName:@"senseMode" and:dict andDef:@"auto"];
        if ([senseMode isEqualToString:@"light"]) { _senseMode = 1; }
        else if ([senseMode isEqualToString:@"dark"]) { _senseMode = 2; }
        else{ _senseMode = 0; }
        
        if ([mode isEqualToString:@"normal"]) {
            _mode = 0;
            _list = [self getArrayByName:@"list" and:dict andDef:nil];
            _normalValue = [self getIntByName:@"value" and:dict andDef:0];
        }
        else if ([mode isEqualToString:@"multi"]) {
            _mode = 1;
            NSArray *list = [self getArrayByName:@"list" and:dict andDef:nil];
            _multiValue = [self getNumberArrayByName:@"value" and:dict andDef:nil];
            NSMutableArray<SanYueMultiPickListItem *> *arr = [NSMutableArray array];
            for (NSDictionary *listItem in list) {
                SanYueMultiPickListItem *item = [[SanYueMultiPickListItem alloc] initWithDict:listItem];
                [arr addObject:item];
            }
            _list = arr;
        }
        else if ([mode isEqualToString:@"time"]) {
            _mode = 2;
            NSString *timeStart = [self getStringByName:@"start" and:dict andDef:@"00:00"];
            NSString *timeEnd = [self getStringByName:@"end" and:dict andDef:@"23:59"];
            NSString *timeValue = [self getStringByName:@"value" and:dict andDef:@"00:00"];
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"HH:mm"];
            
            _timeStart = [dateFormater dateFromString:timeStart];
            _timeEnd = [dateFormater dateFromString:timeEnd];
            _timeValue = [dateFormater dateFromString:timeValue];
            _originTimeValue = timeValue;
        }
        else if ([mode isEqualToString:@"date"]) {
            _mode = 3;
            NSString *timeStart = [self getStringByName:@"start" and:dict andDef:nil];
            NSString *timeEnd = [self getStringByName:@"end" and:dict andDef:nil];
            NSString *timeValue = [self getStringByName:@"value" and:dict andDef:@""];
            
            NSDateFormatter *dateFormater = [[NSDateFormatter    alloc] init];
            [dateFormater setDateFormat:@"YYYY-MM-dd"];
            
            _timeStart = timeStart ? [dateFormater dateFromString:timeStart] : nil;
            _timeEnd = timeEnd ? [dateFormater dateFromString:timeEnd] : nil;
            _timeValue = timeValue ? [dateFormater dateFromString:timeValue] : [NSDate dateWithTimeIntervalSinceNow:0];
            _originTimeValue = timeValue;
        }
    }
    return self;
}
-(void)getItemByMultiList:(NSArray *)list{
    
}
@end
