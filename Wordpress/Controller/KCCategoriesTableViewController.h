//
//  KCCategoriesTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-20.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>

@interface KCCategoriesTableViewController : UITableViewController <XMLRPCConnectionDelegate,UITableViewDelegate,UITableViewDataSource>

+ (instancetype)sharedInstance;

@end
