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
@synthesize postRequestManager = _postRequestManager;
@synthesize categoryInfomation = _categoryInfomation;

#pragma mark - Initial method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.postRequestManager.delegate = self;
        
        __weak KCPostListInCategoryManager *self_ = self;
        [self.myTableViewController.tableView addPullToRefreshWithActionHandler:^(void){
            [self_.postRequestManager sendGetPostsRequest];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }position:SVPullToRefreshPositionBottom];
        
        self.myTableViewController.title = [self.categoryInfomation objectForKey:@"name"];
    }
    return self;
}

- (instancetype)initWithCategoryInfo:(NSDictionary *)info
{
    self  = [self init];
    self.categoryInfomation = info;

    return self;
}

- (void)sendGetPostsRequest
{
    NSString *termID = [self.categoryInfomation objectForKey:@"term_id"];
    
    [self.postRequestManager.myFilter setValue:@"8" forKey:@"number"];
    [self.postRequestManager.myFilter setValue:termID forKey:@"category"];
    [self.postRequestManager.myFilter setValue:@"publish" forKey:@"post_status"];
    [self.postRequestManager.myFilter setValue:@"1" forKey:@"author"];
    [self.postRequestManager.myFilter setValue:@"standard" forKey:@"post_format"];
    
    [self.postRequestManager sendGetPostsRequest];
    
    [SVProgressHUD showWithStatus:@"载入..." maskType:SVProgressHUDMaskTypeClear];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - Setter && Getter
- (KCPostRequestManager *)postRequestManager
{
    if (!_postRequestManager) {
        _postRequestManager = [[KCPostRequestManager alloc] init];
    }
    return _postRequestManager;
}

- (KCPostsTableViewController *)myTableViewController
{
    if (!_myTableViewController) {
        _myTableViewController = [[KCPostsTableViewController alloc] init];
    }
    return _myTableViewController;
}

#pragma mark - KCPostRequestManagerDelegate
- (void)achievePostResponse:(NSArray *)response
{
//    NSLog(@"%@",response);
    [self.myTableViewController handleMyPostsWithRawResponse:response];
    
    NSString *newOffSet = [NSString stringWithFormat:@"%lu",(unsigned long)[self.myTableViewController.myPosts count]];
    [self.postRequestManager.myFilter setObject:newOffSet forKey:@"offset"];
    
    [self.myTableViewController.tableView.pullToRefreshView stopAnimating];
    
    [SVProgressHUD popActivity];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
