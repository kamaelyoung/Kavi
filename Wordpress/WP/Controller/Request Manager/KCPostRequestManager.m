//
//  KCPostRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-3.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostRequestManager.h"

@interface KCPostRequestManager()
@property (nonatomic,strong) WPRequestManager *myRequestManager;
@property (nonatomic,strong) NSMutableArray *myRequestQueue;
@end
@implementation KCPostRequestManager
@synthesize myRequestManager = _myRequestManager;
@synthesize myRequestQueue = _myRequestQueue;
@synthesize delegate = _delegate;
@synthesize myFilter = _myFilter;

#pragma mark - Initial Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myOffset = 0;
    }
    return self;
}



#pragma mark - Setter & Getter
- (WPRequestManager *)myRequestManager
{
    return [WPRequestManager sharedInstance];
}

- (NSMutableArray *)myRequestQueue
{
    if (!_myRequestQueue) {
        _myRequestQueue = [[NSMutableArray alloc] init];
    }
    return _myRequestQueue;
}

- (NSMutableDictionary *)myFilter
{
    if (!_myFilter){
        _myFilter = [[NSMutableDictionary alloc] init];
    }
    return _myFilter;
}

#pragma mark - Functional Method
- (void)sendGetPostsRequest
{
    WPRequest *getPostsRequest = [self.myRequestManager createRequestInOwner:self];
    [self.myRequestManager setWPRequest:getPostsRequest
                                 Method:@"wp.getPosts"
                         withParameters:@[@"1",
                                          getPostsRequest.myUsername,
                                          getPostsRequest.myPassword,
                                          self.myFilter]];
    [self.myRequestManager spawnConnectWithWPRequest:getPostsRequest
                                            delegate:self];
    [self.myRequestQueue addObject:getPostsRequest];
}

- (void)sendGetPostsRequestWithCompleteBlock:(CompleteBlock)block
{
    [self sendGetPostsRequest];
    block(self);
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    if ([self.myRequestQueue containsObject:request]) {
        [self.delegate achievePostResponse:rawResponse];
        [self.myRequestQueue removeObject:request];
    }else{
        NSLog(@"Unrecognition Request in KCPostRequestController");
    }
}

- (void)request:(XMLRPCRequest *)request
didSendBodyData:(float)percent
{
    NSString *methodName = request.method;
    NSLog(@"%@,%f",methodName,percent);
}


- (void)request:(XMLRPCRequest *)request
didFailWithError:(NSError *)error
{
    
}

- (BOOL)request:(XMLRPCRequest *)request
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return NO;
}

- (void)request:(XMLRPCRequest *)request
didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)request:(XMLRPCRequest *)request
didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}
@end
