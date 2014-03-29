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
        

        
        WPRequest *getRecentPostTitlesRequest = [self.requestManager createRequest];
        [self.requestManager setWPRequest:getRecentPostTitlesRequest
                                   Method:@"mt.getRecentPostTitles"
                           withParameters:@[@"1",getRecentPostTitlesRequest.myUsername,getRecentPostTitlesRequest.myPassword,@"10"]];
        [self.requestManager spawnConnectWithWPRequest:getRecentPostTitlesRequest delegate:self];
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
    }else if ([methodName isEqualToString:@"mt.getRecentPostTitles"]){
        HandleResponseBlock MTBlock = ^(void){
            NSMutableArray *MTPostsArray = [NSMutableArray array];
            for (int i = 0; i < [rawResponse count]; i++) {
                NSString *postID = [[rawResponse objectAtIndex:i] objectForKey:@"postid"];
                NSString *postTitle = [[rawResponse objectAtIndex:i] objectForKey:@"title"];
                NSDictionary *postDictionary = @{@"postID": postID,
                                                 @"postTitle":postTitle,
                                                 @"postContent":[NSNull null]};
                
                [MTPostsArray addObject:postDictionary];
                self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithTitle:@"分类"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(selectCategoriesTableViewController)];
            }
            return MTPostsArray;
        };
        [self.recentPostsTableViewController handleResponse:MTBlock];
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
