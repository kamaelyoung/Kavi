//
//  WPRequest.m
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "WPRequest.h"

NSString *const WP_USERNAME = @"iOS_Client";
NSString *const WP_PASSWORD = @"nokian81";
NSString *const XMLPRC_URL = @"http://chenqiwei.com/blog/xmlrpc.php";

@implementation WPRequest

@synthesize myUsername = _myUsername;
@synthesize myPassword = _myPassword;
@synthesize myURL = _myURL;

- (NSString *)myUsername
{
    return WP_USERNAME;
}

- (NSString *)myPassword
{
    return WP_PASSWORD;
}

- (NSURL *)myURL
{
    return [NSURL URLWithString:XMLPRC_URL];
}

- (instancetype)init
{
    self = [super initWithURL:[NSURL URLWithString:XMLPRC_URL]];
    if (self) {
        
    }
    return self;
}

@end
