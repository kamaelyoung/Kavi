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
@synthesize addNewCommentViewController = _addNewCommentViewController;
@synthesize newCommentRequestManager = _newCommentRequestManager;


- (KCGetCommentsRequestManager *)getCommentsRequestManager
{
    if (!_getCommentsRequestManager){
        _getCommentsRequestManager = [[KCGetCommentsRequestManager alloc] init];
    }
    return _getCommentsRequestManager;
}

- (KCNewCommentRequestManager *)newCommentRequestManager
{
    if (!_newCommentRequestManager) {
        _newCommentRequestManager = [[KCNewCommentRequestManager alloc] init];
    }
    return _newCommentRequestManager;
}

- (KCCommentsViewController *)commentsViewController
{
    if (!_commentsViewController){
        _commentsViewController = [[KCCommentsViewController alloc] init];
        UIBarButtonItem *addCommentButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewCommentView)];
        
        _commentsViewController.navigationItem.rightBarButtonItem = addCommentButton;
    }
    return _commentsViewController;
}

- (KCAddNewCommentViewController *)addNewCommentViewController
{
    if (!_addNewCommentViewController) {
        _addNewCommentViewController = [[KCAddNewCommentViewController alloc] init];
        
        UIBarButtonItem *sendCommentButton =
        [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(sendNewCommentReuqest)];
        
        _addNewCommentViewController.navigationItem.rightBarButtonItem = sendCommentButton;
    }
    return _addNewCommentViewController;
}

- (void)sendGetCommentsRequestWith:(NSMutableDictionary *)filter
{
    self.myPostID = [filter objectForKey:@"post_id"];
    self.getCommentsRequestManager.delegate = self;
    self.getCommentsRequestManager.myFilter = filter;
    [self.getCommentsRequestManager sendRequestFromOwner:self];
    [SVProgressHUD showWithStatus:@"正在获取评论" maskType:SVProgressHUDMaskTypeClear];
}

- (void)sendNewCommentReuqest
{
    self.newCommentRequestManager.delegate = self;
    self.newCommentRequestManager.myPostID = self.myPostID;
    [self.addNewCommentViewController.view endEditing:YES];
    
    // Configure request parameter
    NSString *commentContent = self.addNewCommentViewController.commentTextView.text;
    NSString *nickName = self.addNewCommentViewController.nickNameTextField.text;
    NSString *email = self.addNewCommentViewController.emailTextField.text;
//    
//    NSLog(@"%@",self.addNewCommentViewController.commentTextView.text);
//    NSLog(@"%@",self.addNewCommentViewController.emailTextField.text);
//    NSLog(@"%@",self.addNewCommentViewController.nickNameTextField.text);
//    
    [self.newCommentRequestManager.myComment setObject:@"0" forKey:@"comment_parent"];
    [self.newCommentRequestManager.myComment setObject:commentContent forKey:@"content"];
    if ([nickName isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    [self.newCommentRequestManager.myComment setObject:nickName forKey:@"author"];
    
    if ([email isEqualToString:@""]) email = @"empty@mail.com";
    [self.newCommentRequestManager.myComment setObject:email forKey:@"author_email"];
    
    [self.newCommentRequestManager sendRequestFromOwner:self];
    [SVProgressHUD showWithStatus:@"正在发送评论" maskType:SVProgressHUDMaskTypeClear];
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
    [self.commentsViewController.tableView reloadData];
    NSLog(@"%@",self.commentsViewController.myComments);
    if ([self.commentsViewController.myComments count] == 0) {
        [self.commentsViewController.view addSubview:self.commentsViewController.noCommentLabel];
    }
    [SVProgressHUD dismiss];
}

- (void)achieveNewCommentResponse:(NSArray *)response
{
    [self.getCommentsRequestManager sendRequestFromOwner:self];
    [self.commentsViewController.tableView reloadData];
    [self.commentsViewController.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
}

- (void)addNewCommentView
{
    [self.commentsViewController.navigationController pushViewController:self.addNewCommentViewController animated:YES];
}

@end
