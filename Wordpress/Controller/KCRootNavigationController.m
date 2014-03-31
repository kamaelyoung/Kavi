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
        _recentPostsTableViewController.view.frame = CGRectMake(0.0f, 64.0f, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX);
    }
    return _recentPostsTableViewController;
}

- (KCCategoriesTableViewController *)categoriesTableViewController
{
    return [KCCategoriesTableViewController sharedInstance];
}

#pragma mark - inital method
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        WPRequest *getBlogNameRequest = [self.requestManager createRequest];
        [self.requestManager setWPRequest:getBlogNameRequest
                                   Method:@"wp.getUsersBlogs"
                           withParameters:@[getBlogNameRequest.myUsername,getBlogNameRequest.myPassword]];
        [self.requestManager spawnConnectWithWPRequest:getBlogNameRequest delegate:self];
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self pushViewController:self.recentPostsTableViewController animated:YES];
        
        WPRequest *getPostsRequest = [self.requestManager createRequest];
        NSDictionary *filter = @{@"post_status": @"publish",@"number":@"10",@"author":@"1"};
        [self.requestManager setWPRequest:getPostsRequest
                                   Method:@"wp.getPosts"
                           withParameters:@[@"1",getPostsRequest.myUsername,
                                            getPostsRequest.myPassword,
                                            filter
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

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSString *methodName = request.method;
    NSArray *rawResponse = [response object];
    
    if ([methodName isEqualToString:@"wp.getUsersBlogs"]) {
        self.recentPostsTableViewController.title = [[rawResponse lastObject] objectForKey:@"blogName"];
    }else if ([methodName isEqualToString:@"wp.getPosts"]){
        HandleResponseBlock WPBlock = ^(void){
            NSMutableArray *WPPostsArray = [NSMutableArray array];
            for (int i = 0; i < [rawResponse count]; i++) {
                NSString *postID = [[rawResponse objectAtIndex:i] objectForKey:@"post_id"];
                NSString *postTitle = [[rawResponse objectAtIndex:i] objectForKey:@"post_title"];
                NSString *postContent = [[rawResponse objectAtIndex:i] objectForKey:@"post_content"];
                NSDictionary *postDictionary = @{@"postID": postID,@"postTitle":postTitle,@"postContent":postContent};
                [WPPostsArray addObject:postDictionary];
                
                self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithTitle:@"分类"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(selectCategoriesTableViewController)];
            }
            return WPPostsArray;
        };
        [self.recentPostsTableViewController handleResponse:WPBlock];
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

#pragma mark - Switch View Controller
- (void)selectCategoriesTableViewController
{
    [self pushViewController:self.categoriesTableViewController animated:YES];
}

@end
