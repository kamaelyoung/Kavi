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
@property (nonatomic,strong) KCBlogInfoRequestManager *blogInfoRequestManager;
@end

@implementation KCRootNavigationController
@synthesize requestManager = _requestManager;
@synthesize recentPostsTableViewController = _recentPostsTableViewController;
@synthesize categoriesTableViewController = _categoriesTableViewController;
@synthesize postRequestManager = _postRequestManager;
@synthesize blogInfoRequestManager = _blogInfoRequestManager;

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

- (KCBlogInfoRequestManager *)blogInfoRequestManager
{
    if (!_blogInfoRequestManager) {
        _blogInfoRequestManager = [[KCBlogInfoRequestManager alloc] init];
    }
    return _blogInfoRequestManager;
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
    [self.blogInfoRequestManager sendGetBlogInfoRequest];
    self.postRequestManager.delegate = self;
    self.blogInfoRequestManager.delegate = self;
    
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

#pragma mark - Switch View Controller
- (void)selectCategoriesTableViewController
{
    [self pushViewController:self.categoriesTableViewController animated:YES];
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

#pragma mark - KCBlogInfoRequestManagerDelegate
- (void)achieveBlogInfoResponse:(NSArray *)response
{
    self.recentPostsTableViewController.title = [[response lastObject] objectForKey:@"blogName"];
    self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"分类"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(selectCategoriesTableViewController)];
}
@end
