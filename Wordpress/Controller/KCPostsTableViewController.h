//
//  KCPostsTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>
#import "KCPostRequestManager.h"

@interface KCPostsTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) NSMutableDictionary *myFilter;
@property (nonatomic,strong) NSMutableArray *myPosts;

typedef void (^HandleResponseBlock)(KCPostsTableViewController *);

- (instancetype)init;
- (void)handleResponse:(HandleResponseBlock)myTrimBlock;
- (void)startNetworkActivity;
- (void)stopNetworkActivity;


@end
