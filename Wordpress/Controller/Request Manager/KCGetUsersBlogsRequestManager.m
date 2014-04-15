//
//  KCGetUsersBlogsRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCGetUsersBlogsRequestManager.h"

@implementation KCGetUsersBlogsRequestManager

- (void)sendRequestFromOwner:(id)owner
{
    WPRequest *getBlogInfoRequest = [self.myRequestManager createRequestInOwner:owner];
    [self.myRequestManager setWPRequest:getBlogInfoRequest
                                 Method:@"wp.getUsersBlogs"
                         withParameters:@[getBlogInfoRequest.myUsername,
                                          getBlogInfoRequest.myPassword]];
    [self.myRequestManager spawnConnectWithWPRequest:getBlogInfoRequest delegate:self];
}

- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    [self.delegate achieveGetUsersBlogsResponse:rawResponse];
}
@end
