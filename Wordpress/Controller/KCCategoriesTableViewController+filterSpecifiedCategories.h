//
//  KCCategoriesTableViewController+filterSpecifiedCategories.h
//  Wordpress
//
//  Created by kavi chen on 14-4-1.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCategoriesTableViewController.h"

@interface KCCategoriesTableViewController (filterSpecifiedCategories)

- (NSMutableArray *)trimCategaries:(NSMutableArray *)categories withIgnoredSet:(NSSet *)set;

@end
