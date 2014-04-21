//
//  KCPostPageGetCommentsConnector.h
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCGetCommentsRequestManager.h"
#import "KCCommentsViewController.h"

@interface KCPostPageGetCommentsConnector : NSObject <KCGetCommentsRequestManagerDelegate>
@property (nonatomic,strong) KCGetCommentsRequestManager *getCommentsRequestManager;
@property (nonatomic,strong) KCCommentsViewController *commentsViewController;
//@property (nonatomic,strong) NSMutableDictionary *getCommentsRequestFilter;

- (instancetype)init;
- (void)sendGetCommentsRequestWith:(NSMutableDictionary *)filter;
@end
