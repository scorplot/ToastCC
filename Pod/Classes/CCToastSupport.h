//
//  CCToastSupport.h
//  Pods
//
//  Created by may on 2017/7/3.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TOAST_DURATION_SHORT,
    TOAST_DURATION_MIDDLE,
    TOAST_DURATION_LONG,
}TOAST_DURATION ;

@protocol CustomCCToastViewDelegate <NSObject>

@optional

//自定义toast -- only text 回调
- (UIView*)toastViewWithTitle:(NSString *)title subTitle:(NSString*)subTitle context:(void *)context;
//自定义toast -- loading   回调
- (UIView*)toastViewWithLoadingTitle:(NSString *)title subTitle:(NSString*)subTitle context:(void *)context;

- (UIView *)toastViewSuccessWithTitle:(NSString *)title context:(void *)context;
- (UIView *)toastViewErrorWithTitle: (NSString *)title context:(void *)context;
- (void)toastViewCompletionWithContext:(void *)context;
@end

// control CCToast show & dismiss
@class CCToastSupport;
typedef void(^CompletionBlock)(void);

@interface CCToastSupport : NSObject
@property (nonatomic, strong, readonly) UIView* view; // the toast view
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;// get is showing
@property (nonatomic, weak) UIView* superView;

@property (nonatomic, copy) CompletionBlock completionBlock;

-(void)show;// make view showing ， if need keep showing ,you must refer it by yourself

-(CCToastSupport *)showInTime:(NSTimeInterval)time; // give the time that you need to show
-(void)showWithDuration:(TOAST_DURATION)duration; // choose a privode time

-(void)dissmiss; // remove toast
-(void)dissmissWithDelayTime:(NSTimeInterval)time;

@end

// control toast how to display
@interface CCToastSupportFactory: NSObject

+(instancetype)sharedInstance;

// ------ defaultStyle

@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIFont *labelFont;

@property (nonatomic, copy) NSString *detailLabelText;
@property (nonatomic, strong) UIColor *detailLabelColor;
@property (nonatomic, strong) UIFont *detailLabelFont;

@property (nonatomic, strong) UIColor *activityIndicatorColor;
@property (nonatomic, assign) CGFloat ringThickness;
// position of toast
@property (nonatomic, assign) CGPoint toastCenter;
// default: blackColor
@property (nonatomic, strong) UIColor *toastColor;
// default: 0.7
@property (nonatomic, assign) CGFloat backViewAlpha;
// default: 5
@property (nonatomic, assign) CGFloat backViewCornerRadius;
// ------ customStyle

// Set up a unified format : customViewClassName
- (void)setCustomViewWithClassName:(Class<CustomCCToastViewDelegate>)viewClass;


// only loading
- (CCToastSupport *)createLoading;

// loading with title
- (CCToastSupport *)createLoadingWithMesssage:(NSString *)msg;
// context : 自定义数据，与createLoadingWithMessage:关联，可以在CustomCCToastViewDelegate 中获得该数据
- (CCToastSupport *)createLoadingWithMesssage:(NSString *)msg context:(void *)context;

// loading with title and subTitle
- (CCToastSupport *)createLoadingWithMessage:(NSString *)msg detial:(NSString *)detail;
// context : 自定义数据，与createLoadingWithMessage:detial:关联，可以在CustomCCToastViewDelegate 中获得该数据
- (CCToastSupport*)createLoadingWithMessage:(NSString *)msg detial:(NSString *)detail context:(void *)context;

- (CCToastSupport *)createSuccessWithMessage:(NSString *)msg;
- (CCToastSupport *)createSuccessWithMessage:(NSString *)msg context:(void *)context;
- (CCToastSupport *)createErrorWithMessage:(NSString *)msg;
- (CCToastSupport *)createErrorWithMessage:(NSString *)msg context:(void *)context;

// only title
- (CCToastSupport *)createMessage:(NSString *)msg;
// context : 自定义数据，与createMessage:关联，可以在CustomCCToastViewDelegate 中获得该数据
- (CCToastSupport *)createMessage:(NSString *)msg context:(void *)context;
// set title and subtitle and durationTime
- (CCToastSupport *)createMessage:(NSString *)msg detail:(NSString *)detail;
// context : 自定义数据，与createMessage:detail:durationTime:completionBlock:关联，可以在CustomCCToastViewDelegate 中获得该数据
- (CCToastSupport *)createMessage:(NSString *)msg detail:(NSString *)detail context:(void *)context;
// customLoadingView
- (CCToastSupport *)createLoadingWithCustomView:(UIView *)toastView;

@end

