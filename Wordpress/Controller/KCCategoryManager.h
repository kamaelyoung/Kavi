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

@interface KCCategoryManager : NSObject <KCGetTermsRequestDelegate>

@property (nonatomic,strong) KCGetTermsRequestManager *getTermsRequestManager;
@property (nonatomic,strong) KCCategoryTableViewController *tableViewController;
@property (nonatomic,strong) NSMutableArray *myCategories;

+ (instancetype)sharedInstance;
//- (instancetype)init;
@end
