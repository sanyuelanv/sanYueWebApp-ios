//
//  SanYueErrorView.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import "SanYueErrorView.h"

@implementation SanYueErrorView

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)reason addTarget:(nullable id)target reloadAction:(SEL)reloadAction closeAction:(SEL)closeAction needReload:(BOOL)needReload{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        self.backgroundColor = UIColor.whiteColor;
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = reason;
        //[descLabel sizeToFit];
        CGFloat TextH = [reason boundingRectWithSize:CGSizeMake(width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : descLabel.font} context:nil].size.height;
        descLabel.frame = CGRectMake(15, (height - TextH - 30) * 0.5, width - 30, TextH);
        [self addSubview:descLabel];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 24];
        titleLabel.textColor = UIColor.blackColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Error";
        CGRect TextSize = [reason boundingRectWithSize:CGSizeMake(width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : descLabel.font} context:nil];
        titleLabel.frame = CGRectMake(15, CGRectGetMidY(descLabel.frame) - 60, width - 30, TextSize.size.height);
        [self addSubview:titleLabel];
        
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [reloadBtn setTitle:@"重试" forState:UIControlStateNormal];
        [reloadBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        reloadBtn.frame = CGRectMake(0,0, 200, 40);
        backBtn.frame = CGRectMake(0,0, 200, 40);
        reloadBtn.layer.cornerRadius = 20;
        backBtn.layer.cornerRadius = 20;
        reloadBtn.layer.borderWidth = 1;
        backBtn.layer.borderWidth = 1;
        reloadBtn.layer.borderColor = [UIColor colorWithRed:0/255.0 green:192/255.0 blue:108/255.0 alpha:1.0].CGColor;
        backBtn.layer.borderColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0].CGColor;
        
        reloadBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        
        
        [backBtn addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:backBtn];
        if(needReload){
            reloadBtn.frame = CGRectMake((width - 200) * 0.5,CGRectGetMaxY(descLabel.frame) + 40, 200, 40);
            backBtn.frame = CGRectMake((width - 200) * 0.5,CGRectGetMaxY(reloadBtn.frame) + 20, 200, 40);
            [self addSubview:reloadBtn];
            [reloadBtn addTarget:target action:reloadAction forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            backBtn.frame = CGRectMake((width - 200) * 0.5,CGRectGetMaxY(descLabel.frame) + 35, 200, 40);
        }
    }
    return self;
}

@end
