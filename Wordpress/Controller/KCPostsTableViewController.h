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

typedef NSMutableArray *(^HandleResponseBlock)(void);

@interface KCPostsTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,XMLRPCConnectionDelegate,KCPostRequestManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *myFilter;
- (instancetype)init;
- (void)handleResponse:(HandleResponseBlock)myTrimBlock;

@end
