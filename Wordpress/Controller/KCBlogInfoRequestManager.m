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
    WPRequest *getBlogInfoRequest = [self.myRequestManager createRequest];
    [self.myRequestManager setWPRequest:getBlogInfoRequest Method:@"wp.getUsersBlogs" withParameters:<#(NSArray *)#>]
}
@end
