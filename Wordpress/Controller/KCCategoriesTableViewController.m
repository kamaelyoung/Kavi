//
//  KCCategoriesTableViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-20.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCategoriesTableViewController.h"
#import "WPRequestManager.h"
#import "KCPostsTableViewController.h"
#import "KCRootNavigationController.h"

@interface KCCategoriesTableViewController ()
{
    UIActivityIndicatorView *rightIndicatorView;
}
@property (strong, nonatomic) WPRequestManager *requestManager;
@property (strong, nonatomic) NSMutableArray *myCategories;
@property (strong, nonatomic) NSMutableArray *myPostViewControllers;
@property NSInteger selectedCategory;
@end

@implementation KCCategoriesTableViewController
@synthesize requestManager = _requestManager;
@synthesize myCategories = _myCategories;
@synthesize myPostViewControllers = _myPostViewControllers;

#pragma mark - inital method
+ (instancetype)sharedInstance
{
    static KCCategoriesTableViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KCCategoriesTableViewController alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        rightIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithCustomView:rightIndicatorView];
        [rightIndicatorView startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        WPRequest *getCategoriesRequest = [self.requestManager createRequest];
        [self.requestManager setWPRequest:getCategoriesRequest
                                   Method:@"wp.getTerms"
                           withParameters:@[@"1",getCategoriesRequest.myUsername,
                                            getCategoriesRequest.myPassword,
                                            @"category"]];
        
        [self.requestManager spawnConnectWithWPRequest:getCategoriesRequest
                                              delegate:self];
        
    }
    return self;
}

#pragma mark - Getter & Setter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

- (NSMutableArray *)myPostViewControllers
{
    if (!_myPostViewControllers) {
        _myPostViewControllers = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.myCategories count]; i++) {
            [_myPostViewControllers addObject:[NSNull null]];
        }
    }
    return _myPostViewControllers;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"文章分类";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - XMLRPCConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSString *methodName = request.method;
    NSArray *rawResponse = [response object];
    
    if([response isFault]){
        NSLog(@"Fault Code: %@",[response faultCode]);
        NSLog(@"Fault string: %@",[response faultString]);
    }else{
        if ([methodName isEqualToString:@"wp.getTerms"]) {
            self.myCategories = [self retrieveResponse:(NSMutableArray *)[response object]];
            [self.tableView reloadData];
            [rightIndicatorView stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else if([methodName isEqualToString:@"wp.getPosts"]){
            HandleResponseBlock WPBlock = ^(void){
                NSMutableArray *WPPostsArray = [NSMutableArray array];
                for (int i = 0; i < [rawResponse count]; i++) {
                    NSString *postID = [[rawResponse objectAtIndex:i] objectForKey:@"post_id"];
                    NSString *postTitle = [[rawResponse objectAtIndex:i] objectForKey:@"post_title"];
                    NSString *postContent = [[rawResponse objectAtIndex:i] objectForKey:@"post_content"];
                    NSDictionary *postDictionary = @{@"postID": postID,@"postTitle":postTitle,@"postContent":postContent};
                    [WPPostsArray addObject:postDictionary];
                }
                return WPPostsArray;
            };
            [[self.myPostViewControllers objectAtIndex:self.selectedCategory]
             handleResponse:WPBlock];
        }
    }
}

- (void)request:(XMLRPCRequest *)request
didSendBodyData:(float)percent
{
    NSLog(@"%@ %f",request.method,percent);
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

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"category_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"category_cell"];
    }
    cell.textLabel.text = [[self.myCategories objectAtIndex:indexPath.row]
                           objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.myPostViewControllers objectAtIndex:indexPath.row] == [NSNull null]) {
        KCPostsTableViewController *viewController = [self createPostsTableViewControllerAndInsertIntoMyPostViewControllersAtIndex:indexPath.row];
        self.selectedCategory  = indexPath.row;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        self.selectedCategory = indexPath.row;
        [self.navigationController pushViewController:[self.myPostViewControllers objectAtIndex:indexPath.row] animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (KCPostsTableViewController *)createPostsTableViewControllerAndInsertIntoMyPostViewControllersAtIndex:(NSInteger)index
{
    KCPostsTableViewController *postsTableViewController = [[KCPostsTableViewController alloc] init];
    
    NSString *termID = [[self.myCategories objectAtIndex:index] objectForKey:@"term_id"];
    NSDictionary *filter = @{@"number":@"10",@"category":termID,@"post_status": @"publish",@"author":@"1"};
    WPRequest *postsRequest = [self.requestManager createRequest];
    [self.requestManager setWPRequest:postsRequest
                               Method:@"wp.getPosts"
                       withParameters:@[@"1",postsRequest.myUsername,postsRequest.myPassword,filter]];
    [self.requestManager spawnConnectWithWPRequest:postsRequest delegate:self];
    [self.myPostViewControllers replaceObjectAtIndex:index withObject:postsTableViewController];
    
    postsTableViewController.title = [[self.myCategories objectAtIndex:index] objectForKey:@"name"];
    return postsTableViewController;
}

#pragma mark - Categories Function
- (NSMutableArray *)retrieveResponse:(NSArray *)response
{
    NSMutableArray *firstLevelCategories = [[NSMutableArray alloc] init];
    for (NSDictionary *category in response) {
        if ([[category objectForKey:@"parent"] isEqualToString:@"0"]) {
            [firstLevelCategories addObject:category];
        }
    }
    NSSet *ignoredCategories = [NSSet setWithObjects:@"其他", @"李孟蓉的日記", @"阅读收藏", nil];
    return [self trimCategaries:firstLevelCategories withIgnoredSet:ignoredCategories];
}

- (NSMutableArray *)trimCategaries:(NSMutableArray *)categories withIgnoredSet:(NSSet *)set
{
    for (int i = 0; i < [categories count]; i++) {
        NSDictionary *category = [categories objectAtIndex:i];
        if ([set containsObject:[category objectForKey:@"name"]]) {
            [categories removeObjectAtIndex:i];
        }
    }
    return categories;
}

@end
