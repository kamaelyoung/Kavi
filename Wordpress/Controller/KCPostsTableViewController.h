//
//  KCPostsTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>

typedef NSArray* (^HandleResponseBlock)(NSArray *rawResponse);

@interface KCPostsTableViewController : UITableViewController <XMLRPCConnectionDelegate,UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithMethod:(NSString *)myMethod
                     andFilter:(id)myFilter;

@end
