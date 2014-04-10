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
        [self.myPostListManagers insertObject:[NSNull null] atIndex:i];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Getter && Setter
- (NSMutableArray *)myPostListManagers
{
    if (!_myPostListManagers) {
        _myPostListManagers = [NSMutableArray arrayWithCapacity:[_myCategories count]];
    }
    return _myPostListManagers;
}


#pragma mark - Table view data source
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
    KCPostListInCategoryManager *manager;
    
    if ( [self.myPostListManagers objectAtIndex:indexPath.row] == [NSNull null]) {
        manager = [[KCPostListInCategoryManager alloc] initWithCategoryInfo:[self.myCategories objectAtIndex:indexPath.row]];
        [self.myPostListManagers replaceObjectAtIndex:indexPath.row withObject:manager];
        [manager sendGetPostsRequest];
    }else{
        manager = [self.myPostListManagers objectAtIndex:indexPath.row];
    }
    
    manager.myTableViewController.title = [[self.myCategories objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:manager.myTableViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
