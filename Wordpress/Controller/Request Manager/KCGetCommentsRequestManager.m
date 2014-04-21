//
//  KCGetCommentsRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCGetCommentsRequestManager.h"

@implementation KCGetCommentsRequestManager
@synthesize delegate = _delegate;
@synthesize myFilter = _myFilter;

- (void)sendRequestFromOwner:(id)owner
{
    WPRequest *getCommentsRequest = [self.myRequestManager createRequestInOwner:owner];
//    NSDictionary *filter = @{@"post_id": postID};
    [self.myRequestManager setWPRequest:getCommentsRequest
                                 Method:@"wp.getComments"
                         withParameters:@[@"1",
                                          getCommentsRequest.myUsername,
                                          getCommentsRequest.myPassword,
                                          self.myFilter]];
    [self.myRequestManager spawnConnectWithWPRequest:getCommentsRequest delegate:self];
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    [self.delegate achieveGetCommentsResponse:rawResponse];
}
@end
