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
#import <SVPullToRefresh.h>

@interface KCRootNavigationController ()
{
    UIBarButtonItem *leftNavigationBarButtomItem;
}
@property (nonatomic,strong) WPRequestManager *requestManager;
@property (nonatomic,strong) KCPostsTableViewController *recentPostsTableViewController;
@property (nonatomic,strong) KCCategoriesTableViewController *categoriesTableViewController;
@property (nonatomic,strong) KCPostRequestManager *postRequestManager;
@end

@implementation KCRootNavigationController
@synthesize requestManager = _requestManager;
@synthesize recentPostsTableViewController = _recentPostsTableViewController;
@synthesize categoriesTableViewController = _categoriesTableViewController;
@synthesize postRequestManager = _postRequestManager;

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

- (KCPostRequestManager *)postRequestManager
{
    if (!_postRequestManager) {
        _postRequestManager = [[KCPostRequestManager alloc] init];
    }
    return _postRequestManager;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendInitialGetUsersBlogsRequest];
    self.postRequestManager.delegate = self;
    
    __weak KCRootNavigationController *self_ = self;
    
    [self.postRequestManager.myFilter setValue:@"publish" forKey:@"post_status"];
    [self.postRequestManager.myFilter setValue:@"8" forKey:@"number"];
    [self.postRequestManager.myFilter setValue:@"1" forKey:@"author"];
    [self.postRequestManager.myFilter setValue:@"0" forKey:@"offset"];
    
    [self pushViewController:self.recentPostsTableViewController animated:NO];
    [self.recentPostsTableViewController.tableView addPullToRefreshWithActionHandler:^(void){
        [self_.postRequestManager sendGetPostsRequest];
    }position:SVPullToRefreshPositionBottom];
    
    [self.recentPostsTableViewController.tableView triggerPullToRefresh];
    [self.recentPostsTableViewController startNetworkActivity];
    
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSString *methodName = request.method;
    NSArray *rawResponse = [response object];
    
    if ([methodName isEqualToString:@"wp.getUsersBlogs"]) {
        
        self.recentPostsTableViewController.title =
        [[rawResponse lastObject] objectForKey:@"blogName"];
        
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

#pragma mark - KCPostRequestManagerDelegate
- (void)achievePostResponse:(NSArray *)response
{
    // Handle the raw response and return the value to self.recentPostsTableViewController.myPosts
    [self.recentPostsTableViewController handleResponse:^(KCPostsTableViewController *viewController){
//        NSMutableArray *WPPostsArray = [NSMutableArray array];
        for (int i = 0; i < [response count]; i++) {
    
            NSString *postID = [[response objectAtIndex:i] objectForKey:@"post_id"];
            NSString *postTitle = [[response objectAtIndex:i] objectForKey:@"post_title"];
            NSString *postContent = [[response objectAtIndex:i] objectForKey:@"post_content"];
            NSDictionary *postDictionary = @{@"postID": postID,
                                             @"postTitle":postTitle,
                                             @"postContent":postContent};
            [viewController.myPosts addObject:postDictionary];
        }
    }];
    NSString *newOffSet = [NSString stringWithFormat:@"%lu",(unsigned long)[self.recentPostsTableViewController.myPosts count]];
    [self.postRequestManager.myFilter setObject:newOffSet forKey:@"offset"];
    [self.recentPostsTableViewController.tableView reloadData];
    [self.recentPostsTableViewController.tableView.pullToRefreshView stopAnimating];
    
    [self.recentPostsTableViewController stopNetworkActivity];
}
@end
