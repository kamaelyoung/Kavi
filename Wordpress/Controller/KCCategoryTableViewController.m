//
//  KCCategoryTableViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCategoryTableViewController.h"
#import "KCPostsTableViewController.h"
#import "KCPostListInCategoryManager.h"

@interface KCCategoryTableViewController ()
@end

@implementation KCCategoryTableViewController
@synthesize myCategories = _myCategories;
@synthesize myPostListManagers = _myPostListManagers;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"文章分类";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)assignCategories:(NSMutableArray *)categories
{
    self.myCategories = categories;
    
    for (int i = 0; i < [self.myCategories count]; i++) {
        KCPostListInCategoryManager *manager = [[KCPostListInCategoryManager alloc] init];
        [self.myPostListManagers addObject:manager];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Getter && Setter



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myCategories ? [self.myCategories count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"category_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"category_cell"];
    }
    cell.textLabel.text = [[self.myCategories objectAtIndex:indexPath.row]
                           objectForKey:@"name"];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCPostListInCategoryManager *manager = [[KCPostListInCategoryManager alloc] initWithCategoryInfo:[self.myCategories objectAtIndex:indexPath.row]];
    [self.myPostListManagers replaceObjectAtIndex:indexPath.row withObject:manager];
    [manager sendGetPostsRequest];
    [self.navigationController pushViewController:manager.myTableViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
