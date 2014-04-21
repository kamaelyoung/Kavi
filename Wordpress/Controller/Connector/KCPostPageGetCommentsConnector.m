//
//  KCPostPageGetCommentsConnector.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageGetCommentsConnector.h"


@implementation KCPostPageGetCommentsConnector
@synthesize getCommentsRequestManager = _getCommentsRequestManager;
@synthesize commentsViewController = _commentsViewController;
//@synthesize getCommentsRequestFilter = _getCommentsRequestFilter;

- (KCGetCommentsRequestManager *)getCommentsRequestManager
{
    if (!_getCommentsRequestManager){
        _getCommentsRequestManager = [[KCGetCommentsRequestManager alloc] init];
    }
    return _getCommentsRequestManager;
}

- (KCCommentsViewController *)commentsViewController
{
    if (!_commentsViewController){
        _commentsViewController = [[KCCommentsViewController alloc] init];
        UIBarButtonItem *addCommentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewComment)];
        _commentsViewController.navigationItem.rightBarButtonItem = addCommentButton;
    }
    return _commentsViewController;
}

- (void)sendGetCommentsRequestWith:(NSMutableDictionary *)filter
{
    self.getCommentsRequestManager.delegate = self;
    self.getCommentsRequestManager.myFilter = filter;
    [self.getCommentsRequestManager sendRequestFromOwner:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)achieveGetCommentsResponse:(NSArray *)response
{
    self.commentsViewController.myComments = [NSMutableArray arrayWithArray:response];
    NSLog(@"%@",self.commentsViewController.myComments);
    [self.commentsViewController.tableView reloadData];
}

- (void)addNewComment
{
}
@end
