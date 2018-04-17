//
//  RequestHandle.h
//  ToastViewTest
//
//  Created by may on 2017/6/26.
//  Copyright © 2017年 may. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCompletedHandleBlock)(id responseObject);
typedef void (^RequestFailedHandleBlock)(NSError *error);
@interface RequestHandle : NSObject
+ (id)shareInstance;
- (void)requestUrl:(NSString *)urlString completed:(RequestCompletedHandleBlock)completeHandleBlock
            failed:(RequestFailedHandleBlock)failedHandleBlock;
@end
