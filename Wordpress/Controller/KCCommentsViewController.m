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
    self.tableView.rowHeight = 64.0f;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *addCommentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewComment)];
    self.navigationItem.rightBarButtonItem  = addCommentButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.commentView willMoveToSuperview:self.navigationController.view];
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
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
    cell.textLabel.text = [self.myComments[indexPath.row] objectForKey:@"content"];
    cell.detailTextLabel.text = [self.myComments[indexPath.row] objectForKey:@"author"];
    
    return cell;
}

- (void)addNewComment
{
    
}

@end
