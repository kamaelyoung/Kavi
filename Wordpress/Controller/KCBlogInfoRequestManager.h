//
//  KCBlogInfoRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPRequestManager.h"
#import <XMLRPC.h>

@protocol KCBlogInfoRequestManagerDelegate <NSObject>
@required
- (void)achieveBlogInfoResponse:(NSArray *)response;
@end

@interface KCBlogInfoRequestManager : NSObject <XMLRPCConnectionDelegate>
@property (nonatomic,strong) id<KCBlogInfoRequestManagerDelegate> delegate;

- (instancetype)init;
- (void)sendGetBlogInfoRequest;

@end
