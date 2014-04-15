//
//  KCRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

@implementation KCRequestManager
@synthesize myRequestManager = _myRequestManager;

#pragma mark - Initial Method
- (instancetype)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

#pragma mark - Setter && Getter
- (WPRequestManager *)myRequestManager
{
    return [WPRequestManager sharedInstance];
}

#pragma mark - Functional Method
- (void)sendRequestFromOwner:(id)owner
{
    // must set delegate as self
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    
}

- (void)request:(XMLRPCRequest *)request
didSendBodyData:(float)percent
{

}


- (void)request:(XMLRPCRequest *)request
didFailWithError:(NSError *)error
{
    WPRequest *myRequest = (WPRequest *)request;
    NSDictionary *myUserInfo = @{@"requestOwner":myRequest.myOwner};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KCErrorOccurNotification" object:self userInfo:myUserInfo];
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
