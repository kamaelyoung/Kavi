//
//  KCRootNavigationController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-26.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRootNavigationController.h"
#import "KCPostsTableViewController.h"
#import "KCCategoryManager.h"


@interface KCRootNavigationController ()
{
    UIBarButtonItem *leftNavigationBarButtomItem;
}
@property (nonatomic,strong) KCPostsTableViewController *recentPostsTableViewController;
@property (nonatomic,strong) KCCategoryManager *categoryManager;
@property (nonatomic,strong) KCGetUsersBlogsRequestManager *getUsersBlogsRequestManager;
@property (nonatomic,strong) KCGetPostsRequestManager *getPostsRequestManager;
@property (nonatomic,strong) KCErrorNotificationCenter *errorNotificationCenter;
@end

@implementation KCRootNavigationController

@synthesize recentPostsTableViewController = _recentPostsTableViewController;
@synthesize categoryManager = _categoryManager;
@synthesize getUsersBlogsRequestManager = _getUsersBlogsRequestManager;
@synthesize getPostsRequestManager = _getPostsRequestManager;
@synthesize errorNotificationCenter =  _errorNotificationCenter;

#pragma mark - Setter & Getter
- (KCPostsTableViewController *)recentPostsTableViewController
{
    if (!_recentPostsTableViewController) {
        _recentPostsTableViewController = [[KCPostsTableViewController alloc] init];
        _recentPostsTableViewController.view.frame = [[UIScreen mainScreen] bounds];
    }
    return _recentPostsTableViewController;
}


- (KCGetUsersBlogsRequestManager *)getUsersBlogsRequestManager
{
    if (!_getUsersBlogsRequestManager) {
        _getUsersBlogsRequestManager = [[KCGetUsersBlogsRequestManager alloc] init];
    }
    return _getUsersBlogsRequestManager;
}

- (KCCategoryManager *)categoryManager
{
    if (!_categoryManager) {
        _categoryManager = [[KCCategoryManager alloc] init];
    }
    return _categoryManager;
}

- (KCGetPostsRequestManager *)getPostsRequestManager
{
    if (!_getPostsRequestManager) {
        _getPostsRequestManager = [[KCGetPostsRequestManager alloc] init];
    }
    return _getPostsRequestManager;
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
        [self setupSVProgressHUD];
        self.errorNotificationCenter = [KCErrorNotificationCenter sharedInstance];
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

- (void)setupSVProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.blogInfoRequestManager sendGetBlogInfoRequest];
    self.getUsersBlogsRequestManager.delegate = self;
    self.getPostsRequestManager.delegate = self;
    
    [self.getUsersBlogsRequestManager sendRequestFromOwner:self];
    [self.getPostsRequestManager.myFilter setValue:@"publish" forKey:@"post_status"];
    [self.getPostsRequestManager.myFilter setValue:@"8" forKey:@"number"];
    [self.getPostsRequestManager.myFilter setValue:@"1" forKey:@"author"];
    [self.getPostsRequestManager.myFilter setValue:@"0" forKey:@"offset"];
    

    __weak KCRootNavigationController *self_ = self;
    [self pushViewController:self.recentPostsTableViewController animated:YES];
    [self.recentPostsTableViewController.tableView addPullToRefreshWithActionHandler:^(void){
        [self_.getPostsRequestManager sendRequestFromOwner:self_];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }position:SVPullToRefreshPositionBottom];
    
    
    [self.recentPostsTableViewController.tableView.pullToRefreshView setHidden:YES];
    [self.recentPostsTableViewController.tableView triggerPullToRefresh];
}


#pragma mark - Switch View Controller

- (void)selectCategoriesTableViewController
{
    [self pushViewController:self.categoryManager.tableViewController animated:YES];
//    [SVProgressHUD show];
}

- (void)resendRequests
{
    [self.getUsersBlogsRequestManager sendRequestFromOwner:self];
    [self.recentPostsTableViewController.tableView triggerPullToRefresh];
}

#pragma mark - KCGetUsersBlogsRequestManagerDelegate
-(void)achieveGetUsersBlogsResponse:(NSArray *)response
{
    self.recentPostsTableViewController.title = [[response lastObject] objectForKey:@"blogName"];
//    self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"分类"
//                                     style:UIBarButtonItemStylePlain
//                                    target:self
//                                    action:@selector(selectCategoriesTableViewController)];
    
    self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CategoryImage"]
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(selectCategoriesTableViewController)];
}

#pragma mark - KCGetPostsRequestManagerDelegate
- (void)achieveGetPostsResponse:(NSArray *)response
{
    [self.recentPostsTableViewController handleMyPostsWithRawResponse:response];
    
    NSString *newOffSet = [NSString stringWithFormat:@"%lu",(unsigned long)[self.recentPostsTableViewController.myPosts count]];
    [self.getPostsRequestManager.myFilter setObject:newOffSet forKey:@"offset"];
    
    [self.recentPostsTableViewController.tableView.pullToRefreshView setHidden:NO];
    [self.recentPostsTableViewController.tableView.pullToRefreshView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark  - KCErrorNotificationCenter Protocol
- (void)handleRequest:(WPRequest *)request Error:(NSError *)error
{
    if ([request.method isEqualToString:@"wp.getUsersBlogs"]) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        self.recentPostsTableViewController.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resendRequests)];
    } else if ([request.method isEqualToString:@"wp.getPosts"]){
        [self.recentPostsTableViewController.tableView.pullToRefreshView stopAnimating];
    }
}
@end
