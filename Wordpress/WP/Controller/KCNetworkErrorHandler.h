//
//  KCNetworkErrorHandler.h
//  Wordpress
//
//  Created by kavi chen on 14-4-12.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCNetworkErrorHandler : NSObject

- (instancetype)init;
- (void)addNetworkError:(NSError *)error
      withCompleteBlock:(void (^)(void))block;

- (void)handleNetworkError:(NSError *)error
                 withBlock:(void (^)(void))block;

@end
