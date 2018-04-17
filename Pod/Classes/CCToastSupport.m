//
//  CCToastSupport.m
//  Pods
//
//  Created by may on 2017/7/3.
//
//


#import "CCToastSupport.h"
#import "CCToastDefaultView.h"

#define ShortDurationTime  1.5
#define MiddleDurationTime 2.5
#define LongDurationTime   3.5

typedef void(^customViewCompletionBlock)();
@interface CCToastSupport ()
@property (nonatomic, strong) UIView* view;
@property (nonatomic, strong) NSMutableArray *timerArray;
@property (nonatomic, copy) customViewCompletionBlock customBlock;

@end
static  __strong CCToastSupport *_pointer;
@implementation CCToastSupport 
- (instancetype)init {
    self = [super init];
    if (self) {
        self.superView = [[UIApplication sharedApplication].delegate window];
        self.timerArray = [NSMutableArray array];
        
    }
    return self;
}
- (void)show {
    _show = YES;
    [self.superView addSubview:_view];
    _pointer = self;
}

- (void)dissmiss {
    [self removeCCToast];
}
-(void)dissmissWithDelayTime:(NSTimeInterval)time {
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(removeCCToastTimerAction) userInfo:nil repeats:NO];
}
- (void)removeCCToastTimerAction {
    [self removeCCToast];
}
- (void)removeCCToast {
    if (_completionBlock) {
        self.completionBlock();
    }
    if (_customBlock) {
        self.customBlock();
    }
    _show = NO;
    _pointer = nil;
    [_view removeFromSuperview];
    _view = nil;
    for (NSTimer *t in self.timerArray) {
        [t invalidate];
    }
}
- (CCToastSupport *)showInTime:(NSTimeInterval)time {
    [self show];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    [self.timerArray addObject:timer];
    return self;
}
- (void)timerAction:(NSTimer *)timer {
    [self.timerArray removeObject:timer];
    [timer invalidate];
    timer = nil;
    if (self.timerArray.count <= 0) {
        [self dissmiss];
    }
    
}
- (void)showWithDuration:(TOAST_DURATION)duration {
    if (duration == TOAST_DURATION_SHORT) {
        [self showInTime:ShortDurationTime];
    } else if (duration == TOAST_DURATION_MIDDLE) {
        [self showInTime:MiddleDurationTime];
    } else if (duration == TOAST_DURATION_LONG) {
        [self showInTime:LongDurationTime];
    }
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [self dissmiss];
}
@end

static Class _Nullable customViewClass = nil;

@interface CCToastSupportFactory ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation CCToastSupportFactory

+(instancetype)sharedInstance {
    static CCToastSupportFactory *toastInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 自定义view
        toastInstance = [[CCToastSupportFactory alloc] init];
        toastInstance.backViewAlpha = 0.7;
        toastInstance.backViewCornerRadius = 5;
        toastInstance.toastColor = [UIColor blackColor];
        toastInstance.activityIndicatorColor = [UIColor whiteColor];
        toastInstance.ringThickness = 2.0;
        toastInstance.margin = 15.0;
        toastInstance.labelFont = [UIFont systemFontOfSize:13.0];
        toastInstance.labelColor = [UIColor whiteColor];
        toastInstance.detailLabelColor = [UIColor whiteColor];
        toastInstance.detailLabelFont = [UIFont systemFontOfSize:11.0];
        toastInstance.toastCenter = CGPointMake(CGRectGetMidX([[UIApplication sharedApplication].delegate window].bounds), CGRectGetMidY([[UIApplication sharedApplication].delegate window].bounds));
        
        
    });
    return toastInstance;
}

#pragma mark UI

- (void)setupUI {
    // 默认view
    self.backView = [[UIView alloc] init];
    self.backView.clipsToBounds = YES;
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.backViewAlpha];
    self.backView.layer.cornerRadius = self.backViewCornerRadius;
    
    self.label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = self.labelColor;
    _label.font = self.labelFont;
    _label.text = self.labelText;
    [self.backView addSubview:self.label];
    
    self.detailLabel = [[UILabel alloc] init];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = self.detailLabelText;
    _detailLabel.textColor = self.detailLabelColor;
    _detailLabel.font = self.detailLabelFont;
    _detailLabel.numberOfLines = 0;
    [self.backView addSubview:self.detailLabel];
}
- (void)setupIndicatorView {
    //        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //        [(UIActivityIndicatorView *)_indicatorView startAnimating];
    //        [(UIActivityIndicatorView *)_indicatorView setColor:self.activityIndicatorColor];
    _indicatorView = [[CCToastDefaultView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    // Update styling
    CCToastDefaultView *indefiniteAnimatedView = (CCToastDefaultView*)_indicatorView;
    indefiniteAnimatedView.strokeColor = self.activityIndicatorColor;
    indefiniteAnimatedView.strokeThickness = self.ringThickness;
    indefiniteAnimatedView.radius = 18;
    [self.backView addSubview:indefiniteAnimatedView];
}

- (void)setupImageViewWithImage:(UIImage *)image {
    self.imageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.imageView.tintColor = self.labelColor;
    [self.backView addSubview:self.imageView];
}

// 默认view改变布局时 backView loadingView label detailLabel 适应尺寸
- (void)layoutSubviews {
    // 计算backView frame
    CGRect backViewFrame = CGRectZero;
    CGRect indicatorFrame = self.indicatorView.frame;
    CGFloat maxWidth = [[UIApplication sharedApplication].delegate window].bounds.size.width - 2 * self.margin;
    CGFloat maxHeight = [[UIApplication sharedApplication].delegate window].bounds.size.height - 2 * self.margin;
    
    if (indicatorFrame.size.height > 0) {
        backViewFrame.size.width = MAX(CGRectGetWidth(indicatorFrame),(indicatorFrame.size.width + 2 * self.margin));
        backViewFrame.size.height += (self.margin + indicatorFrame.size.height);
    }
    if (self.imageView && CGRectGetWidth(self.imageView.frame) > 0) {
        backViewFrame.size.width = MAX(CGRectGetWidth(self.imageView.frame),(self.imageView.frame.size.width + 2 * self.margin));
        backViewFrame.size.height += (self.margin + self.imageView.frame.size.height);
        
    }
    CGRect labelFrame = [self.label.text boundingRectWithSize:CGSizeMake(maxWidth, 20000.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.label.font} context:nil];
    if (labelFrame.size.height > 0) {
        backViewFrame.size.width = MAX(CGRectGetWidth(backViewFrame), (labelFrame.size.width + self.margin));
        backViewFrame.size.height += (self.margin + labelFrame.size.height);
    }
    
    CGRect detailLabelFrame = [self.detailLabel.text boundingRectWithSize:CGSizeMake(maxWidth, 20000.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.detailLabel.font} context:nil];
    if (detailLabelFrame.size.height > 0) {
        backViewFrame.size.width = MAX(CGRectGetWidth(backViewFrame), (detailLabelFrame.size.width + self.margin));
        backViewFrame.size.height += (self.margin + detailLabelFrame.size.height);
    }
    // set backViewFrame
    backViewFrame.size.height += self.margin;
    backViewFrame.size.width = CGRectGetWidth(backViewFrame) > maxWidth ? maxWidth:CGRectGetWidth(backViewFrame);
    backViewFrame.size.height = CGRectGetHeight(backViewFrame) > maxHeight ? maxHeight : CGRectGetHeight(backViewFrame);
    self.backView.frame = backViewFrame;
    self.backView.center = self.toastCenter;
    // set indicator frame
    CGFloat originY = 0;
    if (indicatorFrame.size.height > 0) {
        indicatorFrame.origin.y = self.margin;
        indicatorFrame.origin.x = (CGRectGetWidth(backViewFrame)-CGRectGetWidth(indicatorFrame))/2;
        self.indicatorView.frame = indicatorFrame;
        originY = CGRectGetMaxY(indicatorFrame);
    }
    // setImageViewFrame
    if (self.imageView && self.imageView.frame.size.width > 0) {
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin.x = (CGRectGetWidth(backViewFrame)-CGRectGetWidth(imageFrame))/2;
        imageFrame.origin.y = originY + self.margin;
        self.imageView.frame = imageFrame;
        originY = CGRectGetMaxY(self.imageView.frame) - self.margin/2;
    }
    // set title frame
    if (labelFrame.size.height > 0) {
        labelFrame.origin.y = originY + self.margin;
        
        labelFrame.origin.x = (CGRectGetWidth(backViewFrame)-CGRectGetWidth(labelFrame))/2;
        self.label.frame = labelFrame;
        originY = CGRectGetMaxY(labelFrame);
    }
    // set detail frame
    if (detailLabelFrame.size.height > 0) {
        detailLabelFrame.origin.y = originY + self.margin;
        detailLabelFrame.origin.x = (CGRectGetWidth(backViewFrame)-CGRectGetWidth(detailLabelFrame))/2;
        self.detailLabel.frame = detailLabelFrame;
    }
}

// 外部使用方法
#pragma mark loading CCToast
- (CCToastSupport*)createLoading {
    return [self createLoadingWithMessage:nil detial:nil context:nil];
}

- (CCToastSupport*)createLoadingWithMesssage:(NSString *)msg {
    return [self createLoadingWithMessage:msg detial:nil context:nil];
}
- (CCToastSupport*)createLoadingWithMesssage:(NSString *)msg context:(void *)context {
    return [self createLoadingWithMessage:msg detial:nil context:context];
}

- (CCToastSupport*)createLoadingWithMessage:(NSString *)msg detial:(NSString *)detail {
    return [self createLoadingWithMessage:msg detial:detail context:nil];
}
- (CCToastSupport*)createLoadingWithMessage:(NSString *)msg detial:(NSString *)detail context:(void *)context {
    CCToastSupport *support = [[CCToastSupport alloc] init];
    if (customViewClass) {
        UIView<CustomCCToastViewDelegate> *customView = [[customViewClass alloc] init];
        if ([customView respondsToSelector:@selector(toastViewWithLoadingTitle:subTitle:context:)]) {
            UIView *view = [customView toastViewWithLoadingTitle:msg subTitle:detail context:context];
            support.customBlock = ^{
                if ([customView respondsToSelector:@selector(toastViewCompletionWithContext:)]) {
                    [customView toastViewCompletionWithContext:context];
                }
            };
            support.view = view;

            return support;
        }
    }
    [_imageView removeFromSuperview];
    _imageView = nil;
    self.labelText = msg;
    self.detailLabelText= detail;
    [self setupUI];
    [self setupIndicatorView];
    [self layoutSubviews];
    support.view = self.backView;
    return support;
}

- (CCToastSupport *)createSuccessWithMessage:(NSString *)msg {
    return [self createSuccessWithMessage:msg context:nil];
}
- (CCToastSupport *)createErrorWithMessage:(NSString *)msg {
    return [self createErrorWithMessage:msg context:nil];
}
- (CCToastSupport *)createErrorWithMessage:(NSString *)msg context:(void *)context {
    return [self createImageWithImageName:@"error" message:msg success:NO context:context];
}
- (CCToastSupport *)createSuccessWithMessage:(NSString *)msg context:(void *)context {
    return [self createImageWithImageName:@"success" message:msg success:YES context:context];
}
- (CCToastSupport *)createImageWithImageName:(NSString *)imageName message:(NSString *)msg success:(BOOL)success context:(void *)context{
    CCToastSupport *support = [[CCToastSupport alloc] init];
    if (success == YES) {
        if (customViewClass) {
            UIView<CustomCCToastViewDelegate> *customView = [[customViewClass alloc] init];
            if ([customView respondsToSelector:@selector(toastViewSuccessWithTitle:context:)]) {
                UIView *view = [customView toastViewSuccessWithTitle:msg context:context];
                support.customBlock = ^{
                    if ([customView respondsToSelector:@selector(toastViewCompletionWithContext:)]) {
                        [customView toastViewCompletionWithContext:context];
                    }
                };
                support.view = view;
                return support;
            }
        }
    } else if (success == NO) {
        UIView<CustomCCToastViewDelegate> *customView = [[customViewClass alloc] init];
        if ([customView respondsToSelector:@selector(toastViewErrorWithTitle:context:)]) {
            UIView *view = [customView toastViewErrorWithTitle:msg context:context];
            support.customBlock = ^{
                if ([customView respondsToSelector:@selector(toastViewCompletionWithContext:)]) {
                    [customView toastViewCompletionWithContext:context];
                }
            };
            support.view = view;
            return support;
        }
    }
    self.labelText = msg;
    self.detailLabelText = nil;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    [self setupUI];
    NSBundle *bundle = [NSBundle bundleForClass:[CCToastSupportFactory class]];
    NSURL *url = [bundle URLForResource:@"ToastCC" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:imageName ofType:@"png"];
    [self setupImageViewWithImage:[UIImage imageWithContentsOfFile:path]];
    [self layoutSubviews];
    support.view = self.backView;
    return support;
}
#pragma mark onlyText CCToast
- (CCToastSupport*)createMessage:(NSString *)msg{
    return [self createMessage:msg detail:nil context:nil];
}
- (CCToastSupport*)createMessage:(NSString *)msg context:(void *)context {
    return [self createMessage:msg detail:nil context:context];
}

- (CCToastSupport*)createMessage:(NSString *)msg detail:(NSString *)detail {
    return [self createMessage:msg detail:detail context:nil];
}
- (CCToastSupport*)createMessage:(NSString *)msg detail:(NSString *)detail context:(void *)context {
    CCToastSupport *support = [[CCToastSupport alloc] init];
    if (customViewClass) {
        UIView<CustomCCToastViewDelegate> *customView = [[customViewClass alloc] init];
        if ([customView respondsToSelector:@selector(toastViewWithTitle:subTitle:context:)]) {
            UIView *view = [customView toastViewWithTitle:msg subTitle:detail context:context];
            support.customBlock = ^{
                if ([customView respondsToSelector:@selector(toastViewCompletionWithContext:)]) {
                    [customView toastViewCompletionWithContext:context];
                }
            };
            support.view = view;
            
            return support;
        }
    }
    self.labelText = msg;
    self.detailLabelText= detail;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    [_imageView removeFromSuperview];
    _imageView = nil;
    [self setupUI];
    [self layoutSubviews];
    support.view = self.backView;
    return support;
}

// 设置自定义toast
- (CCToastSupport*)createLoadingWithCustomView:(UIView *)toastView {
    CCToastSupport *support = [[CCToastSupport alloc] init];
    support.view = toastView;
    return support;
}

// 设置customView
- (void)setCustomViewWithClassName:(Class<CustomCCToastViewDelegate>)viewClass {
    customViewClass = viewClass;
}

@end
