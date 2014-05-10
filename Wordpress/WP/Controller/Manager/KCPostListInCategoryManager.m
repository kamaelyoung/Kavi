//
//  KCPostListInCategoryManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostListInCategoryManager.h"

@implementation KCPostListInCategoryManager
@synthesize myTableViewController = _myTableViewController;
@synthesize getPostsRequestManager = _getPostsRequestManager;
@synthesize categoryInfomation = _categoryInfomation;

#pragma mark - Initial method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.postRequestManager.delegate = self;
        
        self.myTableViewController.title = [self.categoryInfomation objectForKey:@"name"];
        
        __weak KCPostListInCategoryManager *self_ = self;
        [self.myTableViewController.tableView addPullToRefreshWithActionHandler:^(void){
            [self_.getPostsRequestManager sendRequestFromOwner:self_];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }position:SVPullToRefreshPositionBottom];
    }
    return self;
}

- (instancetype)initWithCategoryInfo:(NSDictionary *)info
{
    self  = [self init];
    self.categoryInfomation = info;
    [self initalGetPostsRequest];
    
    return self;
}

- (void)initalGetPostsRequest
{
    NSString *termID = [self.categoryInfomation objectForKey:@"term_id"];
    
    [self.getPostsRequestManager.myFilter setValue:@"8" forKey:@"number"];
    [self.getPostsRequestManager.myFilter setValue:termID forKey:@"category"];
    [self.getPostsRequestManager.myFilter setValue:@"publish" forKey:@"post_status"];
    [self.getPostsRequestManager.myFilter setValue:@"1" forKey:@"author"];
    [self.getPostsRequestManager.myFilter setValue:@"standard" forKey:@"post_format"];
    
    [self.getPostsRequestManager sendRequestFromOwner:self];
    
    [SVProgressHUD showWithStatus:@"载入中..." maskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - Setter && Getter
- (KCGetPostsRequestManager *)postRequestManager
{
    if (!_getPostsRequestManager) {
        _getPostsRequestManager = [[KCGetPostsRequestManager alloc] init];
    }
    return _getPostsRequestManager;
}

- (KCPostsTableViewController *)myTableViewController
{
    if (!_myTableViewController) {
        _myTableViewController = [[KCPostsTableViewController alloc] init];
    }
    return _myTableViewController;
}

#pragma mark - KCPostRequestManagerDelegate
- (void)achieveGetPostsResponse:(NSArray *)response
{
    [self.myTableViewController handleMyPostsWithRawResponse:response];
    
    NSString *newOffSet = [NSString stringWithFormat:@"%lu",(unsigned long)[self.myTableViewController.myPosts count]];
    [self.getPostsRequestManager.myFilter setObject:newOffSet forKey:@"offset"];

    [self.myTableViewController.tableView.pullToRefreshView stopAnimating];
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - KCErrorNotificationCenterProtocol
- (void)handleRequest:(WPRequest *)request Error:(NSError *)error
{
//    [self.myTableViewController handleMyPostsWithRawResponse:nil];
    [self.myTableViewController.tableView.pullToRefreshView stopAnimating];
    [self.myTableViewController.tableView reloadData];
}
@end
