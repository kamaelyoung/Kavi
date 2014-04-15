//
//  KCGetTermsRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-12.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCGetTermsRequestManager.h"

@implementation KCGetTermsRequestManager

- (void)sendRequestFromOwner:(id)owner
{
    WPRequest *getTermsRequest = [self.myRequestManager createRequestInOwner:owner];
    [self.myRequestManager setWPRequest:getTermsRequest
                                 Method:@"wp.getTerms"
                         withParameters:@[@"1",
                                          getTermsRequest.myUsername,
                                          getTermsRequest.myPassword,
                                          @"category"]];
    [self.myRequestManager spawnConnectWithWPRequest:getTermsRequest delegate:self];
}

- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    [self.delegate achieveGetTermsResponse:rawResponse];
}
@end
