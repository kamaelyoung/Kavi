//
//  KCErrorNotificationCenter.m
//  Wordpress
//
//  Created by kavi chen on 14-4-14.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCErrorNotificationCenter.h"

@implementation KCErrorNotificationCenter

- (instancetype)init
{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveErrorNotification:) name:@"KCErrorOccurNotification" object:nil];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static KCErrorNotificationCenter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KCErrorNotificationCenter alloc] init];
    });
    return _sharedInstance;
}

- (void)receiveErrorNotification:(NSNotification *)notification
{
    [self performSelector:@selector(showErrorWithStatus:) withObject:[notification.userInfo objectForKey:@"error"] afterDelay:0.5f];
    
    if ([[notification.userInfo objectForKey:@"requestOwner"] respondsToSelector:@selector(handleRequest:Error:)]){
        [[notification.userInfo objectForKey:@"requestOwner"] handleRequest:[notification.userInfo objectForKey:@"request"] Error:[notification.userInfo objectForKey:@"error"]];
    }
}

- (void)showErrorWithStatus:(NSError *)error
{
    NSString *errorDesc = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
    
    [SVProgressHUD showErrorWithStatus:errorDesc];
}

@end
