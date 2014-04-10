//
//  KCGetTermsRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPRequestManager.h"
#import <XMLRPC.h>

@protocol KCGetTermsRequestDelegate <NSObject>
@required
- (void)achieveTermsResponse:(NSArray *)response;

@end
@interface KCGetTermsRequestManager : NSObject<XMLRPCConnectionDelegate>
@property (nonatomic,strong) id<KCGetTermsRequestDelegate> delegate;

- (instancetype)init;
- (void)sendGetTermsRequest;
@end
