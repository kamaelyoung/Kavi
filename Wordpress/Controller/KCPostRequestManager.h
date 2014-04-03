//
//  KCPostRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-3.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPRequestManager.h"
#import <XMLRPC.h>

@protocol KCPostRequestManagerDelegate <NSObject>
@required
- (void)achievePostResponse:(NSArray *)response;
@end

typedef void *(^completeBlock)(void);

@interface KCPostRequestManager : NSObject <XMLRPCConnectionDelegate>
@property (nonatomic,strong) id<KCPostRequestManagerDelegate> delegate;

//+ (instancetype)sharedInstance;
- (instancetype)init;
- (void)sendGetPostsRequestWithFilter:(NSDictionary *)filter
                        CompleteBlock:(completeBlock)block;
@end
