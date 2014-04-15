//
//  KCGetUsersBlogsRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

@protocol KCGetUsersBlogsRequestManagerDelegate <NSObject>
@required
- (void)achieveGetUsersBlogsResponse:(NSArray *)response;
@end

@interface KCGetUsersBlogsRequestManager : KCRequestManager
@property (nonatomic,strong) id<KCGetUsersBlogsRequestManagerDelegate> delegate;
- (void)sendRequestFromOwner:(id)owner; // implement it

@end
