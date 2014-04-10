//
//  WPRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPRequest.h"

@interface WPRequestManager : NSObject

+ (instancetype)sharedInstance;

- (WPRequest *)createRequest;
- (WPRequest *)setWPRequest:(WPRequest *)theRequest
                     Method:(NSString *)method
             withParameters:(NSArray *)parameters;
- (NSString *)spawnConnectWithWPRequest:(WPRequest *)request
                               delegate:(id)delegate;

@end
