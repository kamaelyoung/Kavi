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

@interface KCRootNavigationController ()
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
//        _recentPostsTableViewController.view.frame = CGRectMake(0.0f, 64.0f, 320.0f, 528.0f);
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
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // if the navigation bar is translucent, SVPullToRefresh give rise to first tableview cell cut-off.
        self.navigationBar.translucent = NO;
        WPRequest *getBlogNameRequest = [self.requestManager createRequest];
        [self.requestManager setWPRequest:getBlogNameRequest
                                   Method:@"wp.getUsersBlogs"
                           withParameters:@[getBlogNameRequest.myUsername,
                                            getBlogNameRequest.myPassword]];
        [self.requestManager spawnConnectWithWPRequest:getBlogNameRequest delegate:self];
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self pushViewController:self.recentPostsTableViewController animated:YES];
        
        WPRequest *getPostsRequest = [self.requestManager createRequest];
        
        [self.recentPostsTableViewController.myFilter setValue:@"publish" forKey:@"post_status"];
        [self.recentPostsTableViewController.myFilter setValue:@"10" forKey:@"number"];
        [self.recentPostsTableViewController.myFilter setValue:@"1" forKey:@"author"];
        
        
        [self.requestManager setWPRequest:getPostsRequest
                                   Method:@"wp.getPosts"
                           withParameters:@[@"1",getPostsRequest.myUsername,
                                            getPostsRequest.myPassword,
                                            self.recentPostsTableViewController.myFilter
                                            ]];
        [self.requestManager spawnConnectWithWPRequest:getPostsRequest delegate:self];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static KCRootNavigationController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KCRootNavigationController alloc] initWithNibName:nil bundle:nil];
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

@end
