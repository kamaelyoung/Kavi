//
//  KCGetCommentsRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

@protocol KCGetCommentsRequestManagerDelegate <NSObject>
@required
- (void)achieveGetCommentsResponse:(NSArray *)response;
@end

@interface KCGetCommentsRequestManager : KCRequestManager
@property (nonatomic,strong) id<KCGetCommentsRequestManagerDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *myFilter;

- (void)sendRequestFromOwner:(id)owner;

@end
