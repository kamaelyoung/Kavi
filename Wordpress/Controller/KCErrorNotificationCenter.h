//
//  KCErrorNotificationCenter.h
//  Wordpress
//
//  Created by kavi chen on 14-4-14.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@protocol KCErrorNotificationCenterProtocol <NSObject>
@required
- (void)handleError;
@end

@interface KCErrorNotificationCenter : NSObject

+ (instancetype)sharedInstance;

@end
