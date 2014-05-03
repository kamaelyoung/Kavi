//
//  KCNewCommentRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-22.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

@protocol KCNewCommentRequestManagerDelegate <NSObject>
@required
- (void)achieveNewCommentResponse:(NSArray *)response;
@end
@interface KCNewCommentRequestManager : KCRequestManager
@property (nonatomic,strong) id<KCNewCommentRequestManagerDelegate> delegate;
@property (nonatomic,strong) NSString *myPostID;
@property (nonatomic,strong) NSMutableDictionary *myComment;


- (void)sendRequestFromOwner:(id)owner;

@end
