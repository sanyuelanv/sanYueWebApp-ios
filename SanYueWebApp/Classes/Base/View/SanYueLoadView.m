//
//  SanYueLoadView.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/4.
//

#import "SanYueLoadView.h"
@interface SanYueLoadView()
@property (nonatomic, weak) NSTimer* blockTimer;
@property (nonatomic, weak) UIView* loadView;
@property (nonatomic, assign) int pos;
@property (nonatomic,strong)UIColor *activeColor;
@property (nonatomic,strong)UIColor *normalColor;
@end
static int const max = 3;
@implementation SanYueLoadView
- (UIColor *)activeColor{
    if(!_activeColor) _activeColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    return _activeColor;
}
- (UIColor *)normalColor{
    if(!_normalColor) _normalColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    return _normalColor;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        //self.layer.anchorPoint = CGPointMake(0.5, 0);
        UIView *loadView = [[UIView alloc] init];
        for (int i = 0; i < max; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * 20, 0, 8, 8)];
            UIColor *color = self.normalColor;
            view.backgroundColor = color;
            view.layer.cornerRadius = 4;
            view.layer.masksToBounds = YES;
            [loadView addSubview:view];
        }
        CGFloat width = (max-1) * 20 + 8;
        CGFloat height = 8;
        loadView.frame = CGRectMake((frame.size.width - width) * 0.5, (frame.size.height - height) * 0.5,width, height);
        self.pos = 0;
        self.loadView = loadView;
        [self addSubview:loadView];
        [self startLoadAnimation];
    }
    return self;
}
-(void)startLoadAnimation{
    NSTimeInterval time = 0.25;
    _blockTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
}
-(void)stopLoadAnimation{
    [_blockTimer invalidate];
    _blockTimer = nil;
    for (int i = 0; i < max; i++) {
        UIView *view = _loadView.subviews[i];
        view.backgroundColor = self.normalColor;
    }
}
-(void)timeEvent{
    if(self.pos > -1){
        _loadView.subviews[self.pos].backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        self.pos += 1;
        self.pos = self.pos >= max ? -1 : self.pos;
        if(self.pos > -1){
            _loadView.subviews[self.pos].backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        }
    }
    else{
        self.pos += 1;
        _loadView.subviews[self.pos].backgroundColor = self.normalColor;
    }
}
- (void)dealloc{
    [_blockTimer invalidate];
    _blockTimer = nil;
    //NSLog(@"退出 -- loadView");
}

@end
