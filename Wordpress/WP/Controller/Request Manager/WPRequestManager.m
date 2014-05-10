//
//  WPRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "WPRequestManager.h"
#import <XMLRPC.h>

@interface WPRequestManager ()
@property (nonatomic,strong) XMLRPCConnectionManager *manager;
@end

@implementation WPRequestManager
@synthesize manager = _manager;

- (XMLRPCConnectionManager *)manager
{
    return [XMLRPCConnectionManager sharedManager];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static WPRequestManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WPRequestManager alloc] init];
    });
    return _sharedInstance;
}

- (WPRequest *)createRequestInOwner:(id)owner
{
    WPRequest *request = [[WPRequest alloc] init];
    request.myOwner = owner;
    NSTimeInterval timeout = 30;
    [request setTimeoutInterval:timeout];
    return request;
}

- (WPRequest *)setWPRequest:(WPRequest *)theRequest
                     Method:(NSString *)method
             withParameters:(NSArray *)parameters
{
    if ([theRequest isKindOfClass:[WPRequest class]]) {
        [theRequest setMethod:method withParameters:parameters];
    }
    return theRequest;
}

- (NSString *)spawnConnectWithWPRequest:(WPRequest *)request
                               delegate:(id)delegate
{
    return [self.manager spawnConnectionWithXMLRPCRequest:request
                                                 delegate:delegate];
}

@end
