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

@interface KCPostsTableViewController ()
{
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic,strong) NSString *myNavigationBarTitle;
@property (nonatomic,strong) NSMutableArray *myPosts;
@property (nonatomic,strong) NSMutableArray *postPageArray;

@end

@implementation KCPostsTableViewController
@synthesize myPosts = _myPosts;
@synthesize myNavigationBarTitle = _myNavigationBarTitle;
@synthesize postPageArray = _postPageArray;

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.myNavigationBarTitle;
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
- (void)handleResponse:(HandleResponseBlock)block
{
    self.myPosts = block();
    [self.tableView reloadData];
    [indicatorView stopAnimating];
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
