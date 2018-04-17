//
//  CMLLoginViewController.m
//  CCToastView
//
//  Created by may on 2017/7/3.
//  Copyright © 2017年 caomeili. All rights reserved.
//

#import "CMLLoginViewController.h"
#import <ToastCC/CCToastSupport.h>
#import "RequestHandle.h"

@interface CMLLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation CMLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginAction:(id)sender {
    [self.passwordTextField resignFirstResponder];
    if ([self.passwordTextField.text isEqualToString:@"111111"]) {
        CCToastSupport *CCToast = [[CCToastSupportFactory sharedInstance] createLoadingWithMesssage:@"正在登录..."];
        [CCToast show];
        [[RequestHandle shareInstance] requestUrl:@"https://api.ticktalk.chat/config/s3/" completed:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CCToast dissmiss];
                [[[CCToastSupportFactory sharedInstance] createMessage:@"登录成功"] showInTime:3.0];
            });
            
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[CCToastSupportFactory sharedInstance] createErrorWithMessage:@"网络错误"] showInTime:2.0];
            });
        }];
    } else {
        [[[CCToastSupportFactory sharedInstance] createErrorWithMessage:@"密码错误"] showInTime:2.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
