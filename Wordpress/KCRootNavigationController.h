//
//  KCRootNavigationController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-26.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//
//  

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import "KCGetUsersBlogsRequestManager.h"
#import "KCGetPostsRequestManager.h"
#import "KCErrorNotificationCenter.h"

@interface KCRootNavigationController : UINavigationController<KCGetUsersBlogsRequestManagerDelegate,KCGetPostsRequestManagerDelegate,KCErrorNotificationCenterProtocol>

+ (instancetype)sharedInstance;
- (void)handleRequest:(WPRequest *)request Error:(NSError *)error;

@end
