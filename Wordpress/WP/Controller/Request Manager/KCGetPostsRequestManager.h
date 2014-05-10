//
//  KCGetPostsRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

//@protocol KCGetPostsRequestManagerDelegate <NSObject>
//@required
//- (void)achieveGetPostsResponse:(NSArray *)response;
//@end

@protocol KCGetPostsRequestManagerDelegate <NSObject>
@required
- (void)achieveGetPostsResponse:(NSArray *)response;
@end

@interface KCGetPostsRequestManager : KCRequestManager
@property (nonatomic,strong) id<KCGetPostsRequestManagerDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *myFilter;

- (void)sendRequestFromOwner:(id)owner;// implement it
@end