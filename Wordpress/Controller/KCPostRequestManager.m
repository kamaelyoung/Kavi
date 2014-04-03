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

#pragma mark - Initial Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//+ (instancetype)sharedInstance
//{
//    static KCPostRequestManager *_sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[KCPostRequestManager alloc] init];
//    });
//    return _sharedInstance;
//}

#pragma mark - Setter & Getter
- (WPRequestManager *)myManager
{
    return [WPRequestManager sharedInstance];
}

#pragma mark - Functional Method
- (void)sendGetPostsRequestWithFilter:(NSDictionary *)filter
                        CompleteBlock:(completeBlock)block
{
    WPRequest *getPostsRequest = [self.myRequestManager createRequest];
    [self.myRequestManager setWPRequest:getPostsRequest
                                 Method:@"wp.getPosts"
                         withParameters:@[@"1",
                                          getPostsRequest.myUsername,
                                          getPostsRequest.myPassword,
                                          filter]];
    [self.myRequestManager spawnConnectWithWPRequest:getPostsRequest
                                            delegate:self];
    [self.myRequestQueue addObject:getPostsRequest];
    block();
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
