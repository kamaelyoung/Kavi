//
//  KCNewCommentRequestManager.m
//  Wordpress
//
//  Created by kavi chen on 14-4-22.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCNewCommentRequestManager.h"

@implementation KCNewCommentRequestManager
@synthesize myPostID = _myPostID;
@synthesize delegate = _delegate;

- (NSMutableDictionary *)myComment
{
    if (!_myComment) {
        _myComment = [NSMutableDictionary
                      dictionaryWithDictionary:@{@"comment_parent":@"0",
                                                 @"content":@"",
                                                 @"author":@"",
                                                 @"author_url":@"",
                                                 @"author_email":@""}];
    }
    return _myComment;
}

- (void)sendRequestFromOwner:(id)owner
{
    WPRequest *newCommentRequest = [self.myRequestManager createRequestInOwner:owner];
    [self.myRequestManager setWPRequest:newCommentRequest
                                 Method:@"wp.newComment"
                         withParameters:@[@"1",
                                          @"",
                                          @"",
                                          self.myPostID,
                                          self.myComment]];
    [self.myRequestManager spawnConnectWithWPRequest:newCommentRequest delegate:self];
    
    NSLog(@"%@",self.myComment);
}

- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    NSArray *rawResponse = [response object];
    NSLog(@"%@",rawResponse);
    [self.delegate achieveNewCommentResponse:rawResponse];
}


@end
