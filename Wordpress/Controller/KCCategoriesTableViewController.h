//
//  KCCategoriesTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-20.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>
#import "KCGetTermsRequestManager.h"
#import "KCPostRequestManager.h"
@interface KCCategoriesTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,KCGetTermsRequestDelegate,KCPostRequestManagerDelegate>

+ (instancetype)sharedInstance;

@end
