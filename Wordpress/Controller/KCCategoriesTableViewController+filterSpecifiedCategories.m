//
//  KCCategoriesTableViewController+filterSpecifiedCategories.m
//  Wordpress
//
//  Created by kavi chen on 14-4-1.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCategoriesTableViewController+filterSpecifiedCategories.h"

@implementation KCCategoriesTableViewController (filterSpecifiedCategories)
/**
 *  Return specified categories without ignored ones
 *
 *  @param categories the raw category list from response
 *  @param set        ignored categories
 *
 *  @return specified categories
 */

- (NSMutableArray *)trimCategaries:(NSMutableArray *)categories withIgnoredSet:(NSSet *)set
{
    for (int i = 0; i < [categories count]; i++) {
        NSDictionary *category = [categories objectAtIndex:i];
        if ([set containsObject:[category objectForKey:@"name"]]) {
            [categories removeObjectAtIndex:i];
        }
    }
    return categories;
}

@end
