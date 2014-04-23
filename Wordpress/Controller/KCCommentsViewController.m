//
//  KCCommentsViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCommentsViewController.h"
#import "KCCommentTableViewCell.h"

@interface KCCommentsViewController ()
@end

@implementation KCCommentsViewController
@synthesize noCommentLabel = _noCommentLabel;
@synthesize myComments = _myComments;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UILabel *)noCommentLabel
{
    if (!_noCommentLabel) {
        _noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 25.f)];
        _noCommentLabel.textAlignment = NSTextAlignmentCenter;
        _noCommentLabel.text = @"还没有评论，赶紧抢沙发吧";
        _noCommentLabel.textColor = [UIColor grayColor];
        _noCommentLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 , [UIScreen mainScreen].bounds.size.height/2 - 30);
    }
    return _noCommentLabel;
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
    self.tableView.tableFooterView = [UIView new];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"评论";
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
    KCCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (cell == nil) {
        cell = [[KCCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"comment_cell"];
    }
    
    cell.textLabel.numberOfLines = 0;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [self.myComments[indexPath.row] objectForKey:@"content"];
    
    cell.detailTextLabel.text = [self.myComments[indexPath.row] objectForKey:@"author"];
    cell.detailTextLabel.tintColor = [UIColor grayColor];
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    
    CGRect frame = [[self.myComments[indexPath.row] objectForKey:@"content"]
                    boundingRectWithSize:maxSize
                    options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName: cell.textLabel.font} context:nil];
    
//    NSLog(@"cell.textLabel frame = %@",NSStringFromCGRect(frame));
    [cell.textLabel setFrame:frame];
    
//    NSLog(@"cell.textLabel.frame = %@",NSStringFromCGRect(cell.textLabel.frame));
    
//    cell.textLabel.layer.borderWidth = 3.f;
//    cell.layer.borderWidth = 3.f;
    
    [cell setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (frame.size.height + 64.f)*1.2)];
    
//    NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));
    
//    NSLog(@"cell frame = %@",NSStringFromCGRect(cell.frame));
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



@end
