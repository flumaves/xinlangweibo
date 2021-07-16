//
//  HeadTabView.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/27.
//

#import "HeadTabView.h"

@interface HeadTabView () <UIScrollViewDelegate>

//储存按钮的数组
@property (nonatomic ,strong)NSMutableArray *btnArray;

//scorllView
@property (nonatomic, strong)UIScrollView *scrollView;

//底部滑块
@property (nonatomic, strong)UIView *buttonView;

//记录滑块的位置
@property (nonatomic)CGRect rect;

@end

@implementation HeadTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubviews];
    }
    return self;
}

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}


#pragma mark - layout
- (void)layoutSubviews {
    //添加scrollView
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollViewH = 40;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    self.scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    
    float btns_inView = 4.5;  //一个屏幕宽度显示的按钮个数
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / btns_inView;
    CGFloat btnH = 40;
    CGFloat btnY = 0;
    
    //需要加载的类别
    NSArray *array = @[@"全部",@"数码",@"新闻",@"体育",@"音乐",@"娱乐"];
    //遍历数组添加btn
    for (int i = 0; i < array.count; i++) {
        NSString *title = array[i];
        CGFloat btnX = btnW * i;
        
        CGRect rect = CGRectMake(btnX, btnY, btnW, btnH);
        
        [self addBtnWithTitle:title andFrame:rect];
    }
    
    //设置滚动的范围
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(btnW * array.count, btnH);
    //取消弹簧效果
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    //添加buttonView
    CGFloat btnViewW = 30;
    CGFloat btnViewH = 5;
    CGFloat btnViewY = scrollViewH - btnViewH;
    CGFloat btnViewX = (btnW - btnViewW) / 2;
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(btnViewX, btnViewY, btnViewX, btnViewH)];
    //记录滑块位置
    self.rect = self.buttonView.frame;
    self.buttonView.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:_buttonView];
}

//添加按钮
- (void)addBtnWithTitle:(NSString *)title andFrame:(CGRect)rect {
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor  = [UIColor colorWithRed:248 /255.0 green:248 /255.0 blue:248 /255.0 alpha:1];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = rect;
    
    [self.scrollView addSubview:btn];
    //添加按钮到数组中
    [self.btnArray addObject:btn];
}


#pragma mark 按钮点击事件
- (void)btnClick:(UIButton *)button {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSLog(@"%@",button.titleLabel.text);
    
    //1.让选中的按钮变色，其他为黑色
    //先遍历全为黑色
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    //选中的btn为橙色
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    //2.移动滑块
    //按钮的X
    CGRect rect = [button convertRect:button.bounds toView:self.scrollView];
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat btnX = rect.origin.x - offsetX;
    //滑块与按钮的相对位置
    CGFloat btnViewX = btnX + (button.bounds.size.width - self.buttonView.bounds.size.width) / 2;
    [self moveButtonViewTo:btnViewX];
    //重新记录滑块位置
    rect.origin.x += (button.bounds.size.width - self.buttonView.bounds.size.width) / 2;
    self.rect = rect;
        
    //3.发送通知，显示对应类别的数据
    [center postNotificationName:@"headerTabBtnClick" object:button];
}

/// 移动滑块到对应位置
//点击按钮
- (void)moveButtonViewTo:(CGFloat)btnViewX {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.buttonView.frame;
        frame.origin.x = btnViewX;
        self.buttonView.frame = frame;
    }];
}

//拖动scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //滑块的位置
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat btnX = self.rect.origin.x - offsetX;

    CGRect frame = self.buttonView.frame;
    frame.origin.x = btnX;

    self.buttonView.frame = frame;
}

@end
