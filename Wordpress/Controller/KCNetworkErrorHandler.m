//
//  KCNetworkErrorHandler.m
//  Wordpress
//
//  Created by kavi chen on 14-4-12.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCNetworkErrorHandler.h"

@implementation KCNetworkErrorHandler

- (instancetype)init
{
    self  = [super init];
    if (self) {
        
    }
    return self;
}


- (void)addNetworkError:(NSError *)error
      withCompleteBlock:(void (^)(void))block;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNetworkErrorNotification" object:nil];
    block();
}

- (void)handleNetworkError:(NSError *)error
                   withBlock:(void (^)(void))block;
{
    block();
}

@end
