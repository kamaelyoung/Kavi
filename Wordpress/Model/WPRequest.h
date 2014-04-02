//
//  WPRequest.h
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "XMLRPCRequest.h"

@interface WPRequest : XMLRPCRequest
@property (nonatomic,readonly) NSString *myUsername;
@property (nonatomic,readonly) NSString *myPassword;
@property (nonatomic,readonly) NSURL *myURL;

- (instancetype)init;


@end
