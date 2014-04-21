//
//  KCPostsTableViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-19.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//



#import "KCPostsTableViewController.h"
#import "WPRequestManager.h"
#import "KCPostTableViewCell.h"
#import "KCRootNavigationController.h"
#import "KCPostPageViewController.h"

@interface KCPostsTableViewController ()
{
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic,strong) NSString *myNavigationBarTitle;
@property (nonatomic,strong) NSMutableArray *postPageArray;
@property (nonatomic,strong) NSDictionary *rowHeight;

@end

@implementation KCPostsTableViewController
@synthesize myPosts = _myPosts;
@synthesize myNavigationBarTitle = _myNavigationBarTitle;
@synthesize postPageArray = _postPageArray;
@synthesize rowHeight = _rowHeight;

#pragma mark - Inital Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.tableView.showsPullToRefresh = YES;
        self.tableView.rowHeight = 64.0f;
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

#pragma mark - Getter & Setter

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (![title isEqualToString:@""]) {
        self.myNavigationBarTitle = title;
    }
}

- (NSMutableArray *)myPosts
{
    if (!_myPosts) {
        _myPosts = [[NSMutableArray alloc] init];
    }
    return _myPosts;
}

/**
 *  The Getter of self.postPageArray
 *
 *  Insert loaded instances of KCPostPageViewController, the length of this array must be as
 *  same as the length of self.myPosts. If some position in this array is empty, set object in
 *  this index as [NSNull null].
 *
 *  @return _postPageArray
 */
- (NSMutableArray *)postPageArray
{
    if (!_postPageArray){
        _postPageArray = [NSMutableArray array];
        for(int i = 1; i < [self.myPosts count]; i++){
            [_postPageArray addObject:[NSNull null]];
        }
    }
    return _postPageArray;
}

#pragma mark - ViewController life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.myNavigationBarTitle;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self.tableView triggerPullToRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myPosts ? [self.myPosts count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"post_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentity];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[self.myPosts objectAtIndex:indexPath.row]
                           objectForKey:@"postTitle"];
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    
    CGRect frame = [[[self.myPosts objectAtIndex:indexPath.row] objectForKey:@"postTitle"]
                    boundingRectWithSize:maxSize
                    options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:cell.textLabel.font}
                    context:nil];
    
    [cell.textLabel setFrame:frame];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCPostPageViewController *viewController;
    if ([self.postPageArray objectAtIndex:indexPath.row] == [NSNull null]){
        viewController = [[KCPostPageViewController alloc] initWithMyPost:[self.myPosts objectAtIndex:indexPath.row]];
        [self.postPageArray replaceObjectAtIndex:indexPath.row withObject:viewController];
    }
    [self.navigationController pushViewController:
     [self.postPageArray objectAtIndex:indexPath.row] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = 64.0;
    CGFloat textLabelHeight = cell.textLabel.frame.size.height;
    CGFloat textOriginalHeight = [UIFont systemFontSize];
    
    CGFloat offSet = textLabelHeight - textOriginalHeight;
    
    if(offSet > 0){
        return cellHeight + offSet;
    }else{
        return cellHeight;
    }
}

#pragma mark - Handle Response Wrapper
/**
 *  Handle posts in raw response object, trim and insert them into the specific array
 *
 *  @param block
 */

- (void)handleMyPostsWithRawResponse:(NSArray *)response
{
    for (int i = 0; i < [response count]; i++) {
        NSString *postID = [[response objectAtIndex:i] objectForKey:@"post_id"];
        NSString *postTitle = [[response objectAtIndex:i] objectForKey:@"post_title"];
        NSString *postContent = [[response objectAtIndex:i] objectForKey:@"post_content"];
        NSDictionary *postDictionary = @{@"postID": postID,
                                         @"postTitle":postTitle,
                                         @"postContent":postContent};
        [self addPostObject:postDictionary];
    }
    [self.tableView reloadData];
}


- (void)addPostObject:(NSDictionary *)postDictionary
{
    [self.myPosts addObject:postDictionary];
    [self.postPageArray addObject:[NSNull null]];
    
    //    NSLog(@"%d",[self.myPosts count]);
    //    NSLog(@"%@",self.postPageArray);
}




@end
