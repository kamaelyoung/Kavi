//
//  KCCategoryTableViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>

@interface KCCategoryTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *myCategories;
@property (nonatomic,strong) NSMutableArray *myPostListManagers;

- (void)assignCategories:(NSMutableArray *)categories;
- (void)showSVProgressHUD;
@end
