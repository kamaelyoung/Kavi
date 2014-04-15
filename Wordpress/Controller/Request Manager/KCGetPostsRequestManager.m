//
//  KCGetPostsRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCGetPostsRequestManager.h"

@implementation KCGetPostsRequestManager
@synthesize myFilter = _myFilter;

- (NSMutableDictionary *)myFilter
{
    if (!_myFilter){
        _myFilter = [[NSMutableDictionary alloc] init];
    }
    return _myFilter;
}

- (void)sendRequestFromOwner:(id)owner
{
    WPRequest *getPostsRequest = [self.myRequestManager createRequestInOwner:owner];
    [self.myRequestManager setWPRequest:getPostsRequest
                                 Method:@"wp.getPosts"
                         withParameters:@[@"1",
                                          getPostsRequest.myUsername,
                                          getPostsRequest.myPassword,
                                          self.myFilter]];
    [self.myRequestManager spawnConnectWithWPRequest:getPostsRequest
                                            delegate:self];
}

- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
//    NSLog(@"%@",rawResponse);
    [self.delegate achieveGetPostsResponse:rawResponse];
}

@end
