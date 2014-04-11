//
//  KCPostListInCategoryManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCPostRequestManager.h"
#import "KCPostsTableViewController.h"
#import <SVProgressHUD.h>

@interface KCPostListInCategoryManager : NSObject <KCPostRequestManagerDelegate>
@property (nonatomic,strong) KCPostsTableViewController *myTableViewController;
@property (nonatomic,strong) KCPostRequestManager *postRequestManager;
@property (nonatomic,strong) NSDictionary *categoryInfomation;

- (instancetype)initWithCategoryInfo:(NSDictionary *)info;
- (void)sendGetPostsRequest;

@end
