//
//  KCPostsTableViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//



#import "KCPostsTableViewController.h"
#import "WPRequestManager.h"
#import "KCPostTableViewCell.h"
#import "KCRootNavigationController.h"
#import "KCPostPageViewController.h"
#import <SVPullToRefresh.h>

@interface KCPostsTableViewController ()
{
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic,strong) NSString *myNavigationBarTitle;
@property (nonatomic,strong) NSMutableArray *myPosts;
@property (nonatomic,strong) NSMutableArray *postPageArray;
@property (nonatomic,strong) WPRequestManager *requestManager;

@end

@implementation KCPostsTableViewController
@synthesize myPosts = _myPosts;
@synthesize myNavigationBarTitle = _myNavigationBarTitle;
@synthesize postPageArray = _postPageArray;
@synthesize requestManager = _requestManager;
@synthesize myFilter = _myFilter;

#pragma mark - Inital Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

#pragma mark - Getter & Setter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (![title isEqualToString:@""]) {
        self.myNavigationBarTitle = title;
    }
}

/**
 *  The Getter of self.postPageArray
 *
 *  Insert loaded instances of KCPostPageViewController, the length of this array must be as 
 *  same as the length of self.myPosts. If some position in this array is empty, set object in
 *  this index as [NSNull null].
 *
 *  @return _postPageArray
 */
- (NSMutableArray *)postPageArray
{
    if (!_postPageArray){
        _postPageArray = [NSMutableArray array];
        for(int i = 0; i < [self.myPosts count]; i++){
            [_postPageArray addObject:[NSNull null]];
        }
    }
    return _postPageArray;
}

/**
 *  The Getter of self.myFilter
 *  Use this iVar in the request to filter the posts in response
 *  @return _myFilter
 */
- (NSMutableDictionary *)myFilter
{
    if (!_myFilter){
        _myFilter = [[NSMutableDictionary alloc] init];
    }
    return _myFilter;
}

#pragma mark - ViewController life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    indicatorView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:indicatorView];
    [indicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    /**
     *  SVPullToRefresh Stuff
     */
    
    __weak KCPostsTableViewController *self_ = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^(void){
        WPRequest *loadMorePostRequest = [self_.requestManager createRequest];
        [self_.requestManager setWPRequest:loadMorePostRequest
                                    Method:@"wp.getPosts"
                            withParameters:@[@"1",
                                             loadMorePostRequest.myUsername,
                                             loadMorePostRequest.myPassword,
                                             self_.myFilter]];
        [self_.requestManager spawnConnectWithWPRequest:loadMorePostRequest
                                               delegate:self_];
        [self_ startNetworkActivity];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.myNavigationBarTitle;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"post_cell";
    KCPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KCPostTableViewCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.postTitleLabel.text = [[self.myPosts objectAtIndex:indexPath.row]
                                objectForKey:@"postTitle"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCPostPageViewController *viewController;
    
    if ([self.postPageArray objectAtIndex:indexPath.row] == [NSNull null]){
        viewController= [[KCPostPageViewController alloc] initWithNibName:nil bundle:nil];
        viewController.myPost = self.myPosts[indexPath.row];
        [self.postPageArray replaceObjectAtIndex:indexPath.row withObject:viewController];
    }
    [self.navigationController pushViewController:
     [self.postPageArray objectAtIndex:indexPath.row] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Handle Response Wrapper
/**
 *  Handle posts in raw response object, trim and insert them into the specific array
 *
 *  @param block
 */
- (void)handleResponse:(HandleResponseBlock)block
{
    self.myPosts = block();
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    [self stopNetworkActivity];
}

#pragma mark - XMLRPCConnectionDelegate
#pragma mark - XMLRPConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSString *methodName = request.method;
    NSArray *rawResponse = [response object];
    
    if ([methodName isEqualToString:@"wp.getPosts"]){
        for(int i = 0; i < [rawResponse count]; i++){
            NSString *postID = [[rawResponse objectAtIndex:i] objectForKey:@"post_id"];
            NSString *postTitle = [[rawResponse objectAtIndex:i] objectForKey:@"post_title"];
            NSString *postContent = [[rawResponse objectAtIndex:i] objectForKey:@"post_content"];
            NSDictionary *postDictionary = @{@"postID": postID,
                                             @"postTitle":postTitle,
                                             @"postContent":postContent};
            [self.myPosts addObject:postDictionary];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        [self stopNetworkActivity];
        [self.tableView reloadData];
        [self.myFilter setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[self.myPosts count]]
                         forKey:@"offset"];
        
        NSInteger offset = [self.myPosts count] - [self.postPageArray count];
        for(int i = 0; i < offset; i++){
            [self.postPageArray addObject:[NSNull null]];
        }
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

#pragma mark - Network Activity
- (void)startNetworkActivity
{
    [indicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopNetworkActivity
{
    [indicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
