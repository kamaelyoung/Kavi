//
//  KCPostPageGetCommentsConnector.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageGetCommentsManager.h"

@implementation KCPostPageGetCommentsManager

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
                                                      action:@selector(pushAddNewCommentView)];
        
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)sendNewCommentReuqest
{
    [self.addNewCommentViewController.view endEditing:YES];
    
    self.newCommentRequestManager.delegate = self;
    self.newCommentRequestManager.myPostID = self.myPostID;
    
    // Configure request parameter
    NSString *commentContent = self.addNewCommentViewController.commentTextView.text;
    NSString *trimmedString = [commentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedString isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效评论"];
        return;
    }
    
    NSString *nickName = self.addNewCommentViewController.nickNameTextField.text;
    if ([nickName isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    
    NSString *email = self.addNewCommentViewController.emailTextField.text;
    if ([email isEqualToString:@""]) email = @"empty@mail.com";
    if (![self NSStringIsValidEmail:email]) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效地址"];
        return;
    }
    
    
//    NSLog(@"%@",self.addNewCommentViewController.commentTextView.text);
//    NSLog(@"%@",self.addNewCommentViewController.emailTextField.text);
//    NSLog(@"%@",self.addNewCommentViewController.nickNameTextField.text);
//    
    [self.newCommentRequestManager.myComment setObject:@"0" forKey:@"comment_parent"];
    [self.newCommentRequestManager.myComment setObject:commentContent forKey:@"content"];
    [self.newCommentRequestManager.myComment setObject:nickName forKey:@"author"];
    
    
    [self.newCommentRequestManager.myComment setObject:email forKey:@"author_email"];
    
    [self.newCommentRequestManager sendRequestFromOwner:self];
//    [self.addNewCommentViewController becomeFirstResponder];
    [SVProgressHUD showWithStatus:@"正在发送评论" maskType:SVProgressHUDMaskTypeClear];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


-( BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.commentsViewController.myComments = [NSMutableArray arrayWithArray:response];
    [self.commentsViewController.tableView reloadData];
//    NSLog(@"%@",self.commentsViewController.myComments);
    if ([self.commentsViewController.myComments count] == 0) {
        [self.commentsViewController.view addSubview:self.commentsViewController.noCommentLabel];
    }
    [SVProgressHUD dismiss];
}

- (void)achieveNewCommentResponse:(NSArray *)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.commentsViewController.noCommentLabel removeFromSuperview];
    [self.commentsViewController.navigationController popViewControllerAnimated:YES];
    [self.getCommentsRequestManager sendRequestFromOwner:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"完成"];
}

- (void)pushAddNewCommentView
{
    [self.commentsViewController.navigationController pushViewController:self.addNewCommentViewController animated:YES];
}

@end
