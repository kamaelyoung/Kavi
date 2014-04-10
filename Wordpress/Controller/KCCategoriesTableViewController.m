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
#import "KCCategoriesTableViewController+filterSpecifiedCategories.h"

@interface KCCategoriesTableViewController ()
{
    UIActivityIndicatorView *rightIndicatorView;
    UIBarButtonItem *rightRefreshButtonView;
}
@property (strong, nonatomic) NSMutableArray *myCategories;
@property (strong, nonatomic) NSMutableArray *myPostsTableViewControllers;
@property (nonatomic,strong) KCGetTermsRequestManager *getTermsRequestManager;
@property (nonatomic,strong) KCPostRequestManager *postRequestManager;
@property NSInteger selectedCategory;
@end

@implementation KCCategoriesTableViewController
@synthesize myCategories = _myCategories;
@synthesize myPostsTableViewControllers = _myPostsTableViewControllers;
@synthesize getTermsRequestManager = _getTermsRequestManager;

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

        
    }
    return self;
}

#pragma mark - Getter & Setter
- (NSMutableArray *)myPostsTableViewControllers

{
    if (!_myPostsTableViewControllers) {
        _myPostsTableViewControllers = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.myCategories count]; i++) {
            [_myPostsTableViewControllers addObject:[NSNull null]];
        }
    }
    return _myPostsTableViewControllers;
}

- (KCGetTermsRequestManager *)getTermsRequestManager
{
    if (!_getTermsRequestManager) {
        _getTermsRequestManager = [[KCGetTermsRequestManager alloc] init];
    }
    return _getTermsRequestManager;
}

- (KCPostRequestManager *)postRequestManager
{
    if (!_postRequestManager) {
        _postRequestManager = [[KCPostRequestManager alloc] init];
    }
    return _postRequestManager;
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    rightIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:rightIndicatorView];
    [self.getTermsRequestManager sendGetTermsRequest];
    
    [rightIndicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.getTermsRequestManager.delegate = self;
    self.postRequestManager.delegate = self;
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

#pragma mark - UITableViewDelegate && UITableViewDataSource
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
    if ([self.myPostsTableViewControllers objectAtIndex:indexPath.row] == [NSNull null]) {
       [self createPostsTableViewControllerAndInsertIntoMyPostsTableViewControllersAtIndex:indexPath.row];
    }
        self.selectedCategory = indexPath.row;
        [self.navigationController pushViewController:[self.myPostsTableViewControllers objectAtIndex:indexPath.row] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)createPostsTableViewControllerAndInsertIntoMyPostsTableViewControllersAtIndex:(NSInteger)index
{
    KCPostsTableViewController *postsTableViewController = [[KCPostsTableViewController alloc] init];
//
    NSString *termID = [[self.myCategories objectAtIndex:index] objectForKey:@"term_id"];
    [self.postRequestManager.myFilter setValue:@"8" forKey:@"number"];
    [self.postRequestManager.myFilter setValue:termID forKey:@"category"];
    [self.postRequestManager.myFilter setValue:@"publish" forKey:@"post_status"];
    [self.postRequestManager.myFilter setValue:@"1" forKey:@"author"];
    
    [self.postRequestManager sendGetPostsRequest];

    [self.myPostsTableViewControllers replaceObjectAtIndex:index withObject:postsTableViewController];
    __weak KCCategoriesTableViewController *self_ = self;
    [postsTableViewController.tableView addPullToRefreshWithActionHandler:^(void){
        [self_.postRequestManager sendGetPostsRequest];
    }position:SVPullToRefreshPositionBottom];
    
    postsTableViewController.title = [[self.myCategories objectAtIndex:index] objectForKey:@"name"];
    [postsTableViewController startNetworkActivity];
}

#pragma mark - KCGetTermsRequestDelegate
- (void)achieveTermsResponse:(NSArray *)response
{
    self.myCategories = [self retrieveResponse:(NSMutableArray *)response];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [rightIndicatorView stopAnimating];
    [self.tableView reloadData];
}

#pragma mark - KCPostRequestManagerDelegate
- (void)achievePostResponse:(NSArray *)response
{
    KCPostsTableViewController *postsTableViewController = [self.myPostsTableViewControllers objectAtIndex:self.selectedCategory];
    [postsTableViewController handleResponse:^(KCPostsTableViewController *viewController){
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
        [viewController stopNetworkActivity];
    }];
    
    NSString *newOffSet = [NSString stringWithFormat:@"%lu",(unsigned long)[postsTableViewController.myPosts count]];
    [self.postRequestManager.myFilter setObject:newOffSet forKey:@"offset"];
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
    NSSet *ignoredCategories = [NSSet setWithObjects:@"其他", @"李孟蓉的日記", @"阅读收藏", nil]; // the name of ignored categories
    return [self trimCategaries:firstLevelCategories withIgnoredSet:ignoredCategories];
//    return firstLevelCategories;
}

#pragma  mark - handle error 
- (void)handleNetworkError
{

}

@end
