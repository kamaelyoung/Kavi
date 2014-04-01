//
//  KCPostsTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>

typedef NSMutableArray *(^HandleResponseBlock)(void);

@interface KCPostsTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,XMLRPCConnectionDelegate>

@property (nonatomic,strong) NSMutableDictionary *myFilter;
- (instancetype)init;
- (void)handleResponse:(HandleResponseBlock)myTrimBlock;

@end
