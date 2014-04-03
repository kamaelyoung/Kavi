//
//  KCRootNavigationController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-26.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRootNavigationController.h"
#import "WPRequestManager.h"
#import "KCPostsTableViewController.h"
#import "KCCategoriesTableViewController.h"
#import <SVProgressHUD.h>

@interface KCRootNavigationController ()
{
    UIBarButtonItem *leftNavigationBarButtomItem;
}
@property (nonatomic,strong) WPRequestManager *requestManager;
@property (nonatomic,strong) KCPostsTableViewController *recentPostsTableViewController;
@property (nonatomic,strong) KCCategoriesTableViewController *categoriesTableViewController;
@end

@implementation KCRootNavigationController
@synthesize requestManager = _requestManager;
@synthesize recentPostsTableViewController = _recentPostsTableViewController;
@synthesize categoriesTableViewController = _categoriesTableViewController;

#pragma mark - Setter & Getter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

- (KCPostsTableViewController *)recentPostsTableViewController
{
    if (!_recentPostsTableViewController) {
        _recentPostsTableViewController = [[KCPostsTableViewController alloc] init];
        _recentPostsTableViewController.view.frame = [[UIScreen mainScreen] bounds];
    }
    return _recentPostsTableViewController;
}

- (KCCategoriesTableViewController *)categoriesTableViewController
{
    return [KCCategoriesTableViewController sharedInstance];
}

#pragma mark - inital method
/**
 *  Send getBlogNameRequest to get your blog information.
 *  Send getPostsRequest to get recent 10 posts.
 *  Both request set delegate as self.
 *
 *  @param nibNameOrNil
 *  @param nibBundleOrNil
 *
 *  @return self
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // if the navigation bar is translucent, SVPullToRefresh give rise to first tableview cell cut-off.
        self.navigationBar.translucent = NO;
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self sendInitialGetUsersBlogsRequest];
        [self sendInitialGetPostsRequest];
        
        [self pushViewController:self.recentPostsTableViewController animated:YES];
        [self.recentPostsTableViewController.myFilter setValue:@"publish" forKey:@"post_status"];
        [self.recentPostsTableViewController.myFilter setValue:@"10" forKey:@"number"];
        [self.recentPostsTableViewController.myFilter setValue:@"1" forKey:@"author"];
        
        leftNavigationBarButtomItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                      target:self
                                                      action:@selector(sendInitialGetPostsRequest)];
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static KCRootNavigationController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KCRootNavigationController alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSString *methodName = request.method;
    NSArray *rawResponse = [response object];
    
    if ([methodName isEqualToString:@"wp.getUsersBlogs"]) {
        
        self.recentPostsTableViewController.title =
        [[rawResponse lastObject] objectForKey:@"blogName"];
        
    }else if ([methodName isEqualToString:@"wp.getPosts"]){
        
        HandleResponseBlock WPBlock = ^(void){
            NSMutableArray *WPPostsArray = [NSMutableArray array];
            for (int i = 0; i < [rawResponse count]; i++) {
                
                NSString *postID = [[rawResponse objectAtIndex:i] objectForKey:@"post_id"];
                NSString *postTitle = [[rawResponse objectAtIndex:i] objectForKey:@"post_title"];
                NSString *postContent = [[rawResponse objectAtIndex:i] objectForKey:@"post_content"];
                NSDictionary *postDictionary = @{@"postID": postID,
                                                 @"postTitle":postTitle,
                                                 @"postContent":postContent};
                [WPPostsArray addObject:postDictionary];
                
            }
            return WPPostsArray;
        };
        


        // Handle the raw response and return the value to self.recentPostsTableViewController.myPosts
        [self.recentPostsTableViewController handleResponse:WPBlock];
        
        // Set offset in filter to 10 (10 recent posts loaded)
        [self.recentPostsTableViewController.myFilter setValue:@"10" forKey:@"offset"];
    }
    
    self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"分类"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(selectCategoriesTableViewController)];
    
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
    NSString *methodName = request.method;
    
    if ([methodName isEqualToString:@"wp.getUsersBlogs"]) {
        self.recentPostsTableViewController.title = @"Blog";
        
    }else if ([methodName isEqualToString:@"wp.getPosts"]){
        [SVProgressHUD showErrorWithStatus:@"Network Error"];
        [self.recentPostsTableViewController.tableView reloadData];
        [self.recentPostsTableViewController.tableView setHidden:NO];
//        self.recentPostsTableViewController.navigationItem.leftBarButtonItem = leftNavigationBarButtomItem;
    }
    NSLog(@"error");
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

#pragma mark - Switch View Controller
- (void)selectCategoriesTableViewController
{
    [self pushViewController:self.categoriesTableViewController animated:YES];
}

#pragma mark - Send Request Method
- (void)sendInitialGetUsersBlogsRequest
{
    WPRequest *getBlogNameRequest = [self.requestManager createRequest];
    [self.requestManager setWPRequest:getBlogNameRequest
                               Method:@"wp.getUsersBlogs"
                       withParameters:@[getBlogNameRequest.myUsername,
                                        getBlogNameRequest.myPassword]];
    [self.requestManager spawnConnectWithWPRequest:getBlogNameRequest delegate:self];
}

- (void)sendInitialGetPostsRequest
{
    WPRequest *getPostsRequest = [self.requestManager createRequest];
    [getPostsRequest setTimeoutInterval:30];
    [self.requestManager setWPRequest:getPostsRequest
                               Method:@"wp.getPosts"
                       withParameters:@[@"1",getPostsRequest.myUsername,
                                        getPostsRequest.myPassword,
                                        self.recentPostsTableViewController.myFilter
                                        ]];
    [self.requestManager spawnConnectWithWPRequest:getPostsRequest delegate:self];
}

#pragma mark - Network Activity
- (void)startNetworkActivity
{
//    [indicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopNetworkActivity
{
//    [indicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
