//
//  KCPostListInCategoryManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCPostsTableViewController.h"
#import "KCGetPostsRequestManager.h"
#import <SVProgressHUD.h>
#import "KCErrorNotificationCenter.h"

@interface KCPostListInCategoryManager : NSObject <KCGetPostsRequestManagerDelegate,KCErrorNotificationCenterProtocol>
@property (nonatomic,strong) KCPostsTableViewController *myTableViewController;
@property (nonatomic,strong) KCGetPostsRequestManager *getPostsRequestManager;
@property (nonatomic,strong) NSDictionary *categoryInfomation;

- (instancetype)initWithCategoryInfo:(NSDictionary *)info;
//- (void)sendGetPostsRequest;

- (void)handleError;

@end
