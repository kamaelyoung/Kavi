//
//  KCRootNavigationController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-26.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//
//  

#import <UIKit/UIKit.h>
#import <XMLRPC.h>
#import "KCPostRequestManager.h"
#import "KCBlogInfoRequestManager.h"

@interface KCRootNavigationController : UINavigationController<KCPostRequestManagerDelegate,KCBlogInfoRequestManagerDelegate>

+ (instancetype)sharedInstance;

@end
