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

@interface KCPostsTableViewController ()
@property (nonatomic,strong) WPRequestManager *requestManager;
@property (nonatomic,strong) NSString *myBlogName;
//@property (nonatomic,strong) NSDictionary *myFilter;
@property (nonatomic,strong) NSArray *myPosts;
@property (nonatomic,strong) HandleResponseBlock block;
@end

@implementation KCPostsTableViewController
@synthesize requestManager = _requestManager;
@synthesize myBlogName = _myBlogName;
@synthesize myPosts = _myPosts;

#pragma mark - Inital Method
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (instancetype)initWithMethod:(NSString *)myMethod andFilter:(id)myFilter
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        WPRequest *postRequest = [self.requestManager createRequest];
        NSMutableArray *myParameters = [NSMutableArray arrayWithObjects:@"1",postRequest.myUsername,postRequest.myPassword, nil];
        [myParameters addObject:myFilter];
        [self.requestManager setWPRequest:postRequest
                                   Method:myMethod
                           withParameters:myParameters];
        [self.requestManager spawnConnectWithWPRequest:postRequest delegate:self];
    }
    return self;
}


#pragma mark - Getter & Setter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - XMLRPCConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    if([response isFault]){
        NSLog(@"Fault Code: %@",[response faultCode]);
        NSLog(@"Fault string: %@",[response faultString]);
    }else{
        if ([request.method isEqualToString:@"wp.getUsersBlogs"]) {
            NSLog(@"%@",[response object]);
        }else if([request.method isEqualToString:@"mt.getRecentPostTitles"]){
            self.myPosts = [self handleResponse:[response object] withMethodName:@"mt.getRecentPostTitles"];;
        }else if([request.method isEqualToString:@"wp.getPosts"]){
            self.myPosts = [self handleResponse:[response object] withMethodName:@"wp.getPosts"];
            NSLog(@"%@",[response object]);
        }
    }
    
    [self.tableView reloadData];
}

- (void)request:(XMLRPCRequest *)request
    didSendBodyData:(float)percent
{
    NSLog(@"%f",percent);
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
    return [self.myPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"post_cell";
    KCPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KCPostTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.postTitleLabel.text = [[self.myPosts objectAtIndex:indexPath.row]
                                               objectForKey:@"postTitle"];
    NSLog(@"%@",cell.postTitleLabel.text);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

#pragma mark - Handle Response Wrapper
- (NSArray *)handleResponse:(id)myResponse withMethodName:(NSString *)methodName
{
    NSMutableArray *postsArray = [NSMutableArray array];
    
    if ([methodName isEqualToString:@"mt.getRecentPostTitles"]) {
        for (int i = 0; i < [myResponse count]; i++) {
            NSString *postID = [[myResponse objectAtIndex:i] objectForKey:@"postid"];
            NSString *postTitle = [[myResponse objectAtIndex:i] objectForKey:@"title"];
            
            NSDictionary *postDictionary = @{@"postID": postID,@"postTitle":postTitle};
            [postsArray addObject:postDictionary];
        }
    }else if([methodName isEqualToString:@"wp.getPosts"]){
        for (int i = 0; i < [myResponse count]; i++) {
            NSString *postID = [[myResponse objectAtIndex:i] objectForKey:@"post_id"];
            NSString *postTitle = [[myResponse objectAtIndex:i] objectForKey:@"post_title"];
            NSString *postContent = [[myResponse objectAtIndex:i] objectForKey:@"post_content"];
            
            NSDictionary *postDictionary = @{@"postID": postID,@"postTitle":postTitle,@"postContent":postContent};
            
            [postsArray addObject:postDictionary];
        }
    }
    
    return postsArray;
}

@end
