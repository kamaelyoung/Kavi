//
//  KCErrorNotificationCenter.h
//  Wordpress
//
//  Created by kavi chen on 14-4-14.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>
#import "WPRequest.h"

@protocol KCErrorNotificationCenterProtocol <NSObject>
@required
- (void)handleRequest:(WPRequest *)request Error:(NSError *)error;
@end

@interface KCErrorNotificationCenter : NSObject

+ (instancetype)sharedInstance;

@end
