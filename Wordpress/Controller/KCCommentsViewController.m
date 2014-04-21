//
//  KCCommentsViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCommentsViewController.h"

@interface KCCommentsViewController ()
@end

@implementation KCCommentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.rowHeight = 64.0f;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableFooterView = [UIView new];
    
//    UIBarButtonItem *addCommentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewComment)];
//    self.navigationItem.rightBarButtonItem  = addCommentButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.commentView willMoveToSuperview:self.navigationController.view];
    self.title = @"评论";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myComments ? [self.myComments count] : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"comment_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"comment_cell"];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [self.myComments[indexPath.row] objectForKey:@"content"];
    cell.detailTextLabel.text = [self.myComments[indexPath.row] objectForKey:@"author"];
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.height - 120, MAXFLOAT);
    
    CGRect frame = [[self.myComments[indexPath.row] objectForKey:@"content"]
                    boundingRectWithSize:maxSize
                    options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName: cell.textLabel.font} context:nil];
    
//    NSLog(@"textLabel frame = %@",NSStringFromCGRect(frame));
    [cell.textLabel setFrame:frame];
    [cell setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height + 64)];
//    NSLog(@"cell frame = %@",NSStringFromCGRect(cell.frame));
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



@end
