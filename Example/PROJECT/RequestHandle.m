//
//  RequestHandle.m
//  ToastViewTest
//
//  Created by may on 2017/6/26.
//  Copyright © 2017年 may. All rights reserved.
//

#import "RequestHandle.h"

static RequestHandle *instance = nil;
@implementation RequestHandle
+ (id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestHandle alloc] init];
    });
    return instance;
}

- (void)requestUrl:(NSString *)urlString completed:(RequestCompletedHandleBlock)completeHandleBlock
            failed:(RequestFailedHandleBlock)failedHandleBlock {
    NSString *urlStr = [NSString stringWithFormat:@"https://www.baidu.com"];
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:5.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (error == nil) {
                if (completeHandleBlock) {
                    completeHandleBlock(response);
                }
            } else {
                if (failedHandleBlock) {
                    failedHandleBlock(error);
                }
            }
        });

    }];
    [dataTask resume];
}
@end
