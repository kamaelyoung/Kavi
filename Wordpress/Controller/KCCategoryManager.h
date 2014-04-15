//
//  KCCategoryManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCGetTermsRequestManager.h"
#import "KCCategoryTableViewController.h"
#import "KCErrorNotificationCenter.h"
#import "KCPostListInCategoryManager.h"


@interface KCCategoryManager : NSObject <KCGetTermsRequestManagerDelegate,KCErrorNotificationCenterProtocol>

@property (nonatomic,strong) KCGetTermsRequestManager *getTermsRequestManager;
@property (nonatomic,strong) KCCategoryTableViewController *tableViewController;
@property (nonatomic,strong) NSMutableArray *myCategories;

+ (instancetype)sharedInstance;

- (void)handleRequest:(WPRequest *)request Error:(NSError *)error;
//- (instancetype)init;
@end
