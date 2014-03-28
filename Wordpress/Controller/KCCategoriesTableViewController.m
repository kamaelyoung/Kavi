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

@interface KCCategoriesTableViewController ()
@property (strong, nonatomic) WPRequestManager *requestManager;
@property (strong, nonatomic) NSMutableArray *myCategories;
@end

@implementation KCCategoriesTableViewController
@synthesize requestManager = _requestManager;
@synthesize myCategories = _myCategories;

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

#pragma mark - Getter & Setter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    WPRequest *getCategoriesRequest = [self.requestManager createRequest];
    [self.requestManager setWPRequest:getCategoriesRequest Method:@"wp.getTerms" withParameters:@[@"1",getCategoriesRequest.myUsername,getCategoriesRequest.myPassword,@"category"]];
    [self.requestManager spawnConnectWithWPRequest:getCategoriesRequest delegate:self];
    
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
    NSString *method = request.method;
    
    if([response isFault]){
        NSLog(@"Fault Code: %@",[response faultCode]);
        NSLog(@"Fault string: %@",[response faultString]);
    }else{
        if ([method isEqualToString:@"wp.getTerms"]) {
            self.myCategories = [self retrieveResponse:(NSMutableArray *)[response object]];
        }
        else{
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
    NSString *selectedTermID = [[self.myCategories objectAtIndex:indexPath.row] objectForKey:@"term_id"];
    NSDictionary *filter = @{@"number":@"20",@"category":selectedTermID};
    KCPostsTableViewController *postsTableViewController = [[KCPostsTableViewController alloc] initWithMethod:@"wp.getPosts" andFilter:filter];
    
    [self.navigationController pushViewController:postsTableViewController
                                         animated:YES];
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
    NSLog(@"%@",categories);
    return categories;
}

@end
