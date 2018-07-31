//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewController.h"
#import "CMLLoginViewController.h"
#import <ToastCC/CCToastSupport.h>

@interface CPDViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CCToastSupport *toast;
@end

@implementation CPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.segmentedControl.selectedSegmentIndex = 0;
    [[[CCToastSupportFactory sharedInstance] createLoading] showWithDuration:TOAST_DURATION_SHORT];
    
}
- (IBAction)loading:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createLoading];
            self.toast.superView = [UIApplication sharedApplication].delegate.window;

            [self.toast show];
//                        self.toast = [[CCToastSupportFactory sharedInstance] createLoading];
//                       self.toast.completionBlock = ^{
//                           NSLog(@"completion");
//                       };
//                        [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createLoading] showInTime:2.0].completionBlock = ^{
                NSLog(@"toast结束");
            };
//                    [[[CCToastSupportFactory sharedInstance] createLoading] showInTime:2.0].completionBlock = ^{
//                        NSLog(@"qqq");
//                    };
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createLoading] showWithDuration:TOAST_DURATION_SHORT];
//                    [[[CCToastSupportFactory sharedInstance] createLoading] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
    
}
- (IBAction)loadingWithMessage:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createLoadingWithMesssage:@"loading..." context:(__bridge void *)(self)];
            [self.toast show];
            
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createLoadingWithMesssage:@"loading..." context:(__bridge void *)(self)] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createLoadingWithMesssage:@"loading..."] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
}
- (IBAction)loadingWithDetail:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createLoadingWithMessage:@"loading..." detial:@"loadingWithDetail"];
            [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createLoadingWithMessage:@"loading" detial:@"loadingWithDetail"] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createLoadingWithMessage:@"loading" detial:@"loadingWithDetail"] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
}
- (IBAction)success:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createSuccessWithMessage:nil];
            [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createSuccessWithMessage:@"success"] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createSuccessWithMessage:@"success"] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
}
- (IBAction)error:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createErrorWithMessage:nil];
            [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createErrorWithMessage:@"network error"] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createErrorWithMessage:@"error"] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
    
}
- (IBAction)message:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createMessage:@"this is a message"];
            [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createMessage:@"success" context:(__bridge void *)(self)] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createMessage:@"success"] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
    
}
- (IBAction)messageAndDetail:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.toast = [[CCToastSupportFactory sharedInstance] createMessage:@"message and detail" detail:@"xxxxxx"];
            
            [self.toast show];
        }
            break;
        case 1:
            [[[CCToastSupportFactory sharedInstance] createMessage:@"message and detail" detail:@"ssssssaaaaaaaaaaaaaaaaaaaaa"] showInTime:2.0];
            break;
        case 2:
            [[[CCToastSupportFactory sharedInstance] createMessage:@"message and detail" detail:@"dddddd"] showWithDuration:TOAST_DURATION_SHORT];
            break;
        default:
            break;
    }
    
}
- (IBAction)customToastOnce:(id)sender {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 100)];
    aView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [[[CCToastSupportFactory sharedInstance] createLoadingWithCustomView:aView] showInTime:3.0];
}

- (IBAction)dismiss:(id)sender {
    [self.toast dissmiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
