//
//  KCCategoryViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCGetTermsRequestManager.h"
#import "KCCategoryTableViewController.h"

@interface KCCategoryViewController : UIViewController <KCGetTermsRequestDelegate>

+ (instancetype)sharedInstance;
@end
