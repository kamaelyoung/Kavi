//
//  KCBlogInfoRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCBlogInfoRequestManager.h"

@interface KCBlogInfoRequestManager()
@property (nonatomic,strong) WPRequestManager *myRequestManager;
@property (nonatomic,strong) NSMutableArray *myRequestQueue;
@end

@implementation KCBlogInfoRequestManager
@synthesize myRequestManager = _myRequestManager;
@synthesize myRequestQueue = _myRequestQueue;

#pragma mark - Initial Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Setter && Getter
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

#pragma mark - Functional Method
- (void)sendGetBlogInfoRequest
{
    WPRequest *getBlogInfoRequest = [self.myRequestManager createRequestInOwner:self];
    [self.myRequestManager setWPRequest:getBlogInfoRequest
                                 Method:@"wp.getUsersBlogs"
                         withParameters:@[getBlogInfoRequest.myUsername,
                                          getBlogInfoRequest.myPassword]];
    [self.myRequestManager spawnConnectWithWPRequest:getBlogInfoRequest delegate:self];
    [self.myRequestQueue addObject:getBlogInfoRequest];
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    if ([self.myRequestQueue containsObject:request]) {
        [self.delegate achieveBlogInfoResponse:rawResponse];
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
