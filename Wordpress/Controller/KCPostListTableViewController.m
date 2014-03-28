//
//  KCPostListTableViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-20.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostListTableViewController.h"
#import "WPRequestManager.h"

@interface KCPostListTableViewController ()
@property (strong, nonatomic) WPRequestManager *requestManager;
@end

@implementation KCPostListTableViewController
@synthesize requestManager = _requestManager;

#pragma mark - Getter & Setter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

#pragma mark - ViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WPRequest *getTerm = [self.requestManager createRequest];
    NSDictionary *filter = @{@"post_type":@"post",@"post_status":@"publish",@"category":@"9"};
    [self.requestManager setWPRequest:getTerm Method:@"wp.getPosts" withParameters:@[@"1",getTerm.myUsername,getTerm.myPassword,filter]];
    [self.requestManager spawnConnectWithWPRequest:getTerm delegate:self];
    
//    WPRequest *test = [self.requestManager createRequest];
//    [self.requestManager setWPRequest:test Method:@"wp.getPost" withParameters:@[@"1",test.myUsername,test.myPassword,@"2410"]];
//    [self.requestManager spawnConnectWithWPRequest:test delegate:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"category_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"category_cell"];
    }
    return cell;
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
            NSLog(@"wp.getTerms = %@",[response object]);
        }
        else if ([method isEqualToString:@"wp.getTerm"]){
            NSLog(@"%@",[response object]);
            NSDictionary *term = [response object];
            NSDictionary *filter = @{@"post_type":@"post",@"post_status":@"publish"}; // 选择 post
            NSArray *fields = @[@"post",@"8",@""];
            WPRequest *getPosts = [self.requestManager createRequest];
            [self.requestManager setWPRequest:getPosts Method:@"wp.getPosts" withParameters:@[@"1",getPosts.myUsername,getPosts.myPassword,filter,fields]];
            [self.requestManager spawnConnectWithWPRequest:getPosts delegate:self];
                                                                                              
        }
        else {
            NSLog(@"other = %@",[response object]);
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

@end
