//
//  RefreshView.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/20.
//

#import "RefreshView.h"
///下拉刷新view的封装

@interface RefreshView ()

//箭头
@property (nonatomic, strong)UIImageView *arrowView;

//文字1 下拉刷新
@property (nonatomic, strong)UILabel *lbl_1;
//文字2 释放刷新
@property (nonatomic, strong)UILabel *lbl_2;
//文字3 加载中
@property (nonatomic, strong)UILabel *lbl_3;

//小菊花
@property (nonatomic, strong)UIActivityIndicatorView *flower;

@end

@implementation RefreshView

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.overLine = YES;
        //lbl
        CGFloat lblW = 80;
        CGFloat lblX = (frame.size.width - lblW) / 2;
        CGFloat lblH = frame.size.height - 10;
        self.lbl_1 = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 5, lblW, lblH)];
        self.lbl_1.text = @"下拉刷新";
        self.lbl_1.textColor = [UIColor orangeColor];
        [self addSubview:_lbl_1];
        self.lbl_1.hidden = YES;
        
        self.lbl_2 = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 5, lblW, lblH)];
        self.lbl_2.text = @"释放刷新";
        self.lbl_2.textColor = [UIColor orangeColor];
        [self addSubview:_lbl_2];
        self.lbl_2.hidden = YES;
        
        self.lbl_3 = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 5, lblW, lblH)];
        self.lbl_3.text = @"加载中...";
        self.lbl_3.textColor = [UIColor orangeColor];
        [self addSubview:_lbl_3];
        self.lbl_3.hidden = YES;
        
        //arrow
        CGFloat imgW = lblH;
        CGFloat imgX = lblX - 10 - imgW;
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 5, imgW, imgW)];
        self.arrowView.backgroundColor = [UIColor whiteColor];
        self.arrowView.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:_arrowView];
        
        //flower
        self.flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleMedium)];
        self.flower.frame = self.arrowView.frame;
        self.flower.color = [UIColor orangeColor];
        self.flower.backgroundColor = [UIColor whiteColor];
        self.flower.hidden = YES;
    }
    return self;
}

- (void)changeTheViewWithOverLine:(BOOL)overLine {
    if (overLine == self.overLine) {
        return;
    }
    if (overLine) {
        //改变文字
        self.lbl_1.hidden = YES;
        self.lbl_2.hidden = NO;
        
        //旋转箭头
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        self.overLine = YES;
    } else {
        //改变文字
        self.lbl_1.hidden = NO;
        self.lbl_2.hidden = YES;
        
        //旋转箭头
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0);
        }];
        self.overLine = NO;
    }
}

///正在刷新
- (void)changeRefreshingView {
    
}
@end
