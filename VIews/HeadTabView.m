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

//slider
@property (nonatomic, strong)UISlider *slider;

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
    
    //添加滚动条
    [self addSlider];
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


//添加slider
- (void)addSlider {
    CGFloat sliderX = 0;
    CGFloat sliderY = 40;   //40 为btn的高度
    CGFloat sliderW = [UIScreen mainScreen].bounds.size.width;
    CGFloat sliderH = 20;
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderW, sliderH)];
    _slider.backgroundColor = [UIColor colorWithRed:248 /255.0 green:248 /255.0 blue:248 /255.0 alpha:1];
    self.slider.userInteractionEnabled = YES;
    self.slider.enabled = YES;
    [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_slider setMinimumTrackTintColor:[UIColor orangeColor]];
    [_slider setValue:0];
    
    [self.slider addTarget:self action:@selector(changeContentOffset:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchDown];
    
    _slider.maximumValue = self.scrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width;
    
    [self addSubview:_slider];
}

#pragma mark 按钮点击事件
- (void)btnClick:(UIButton *)button {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSLog(@"%@",button.titleLabel.text);
    
    //让选中的按钮变色，其他为黑色
    //先遍历全为黑色
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    //选中的btn为橙色
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
    //发送通知，显示对应类别的数据
    [center postNotificationName:@"headerTabBtnClick" object:button];
}


#pragma mark - slider的方法
- (void)changeContentOffset:(UISlider *)slider {
    [self.scrollView setContentOffset:CGPointMake(slider.value, 0)];
}

#pragma mark - scrollView的代理方法
//监听偏移量，设置给slider
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.slider setValue:scrollView.contentOffset.x];
}

@end
