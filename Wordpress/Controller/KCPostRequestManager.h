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

//typedef void *(^completeBlock)(void);

@interface KCPostRequestManager : NSObject <XMLRPCConnectionDelegate>

typedef void (^CompleteBlock)(KCPostRequestManager *);
typedef NSDictionary* (^FilterBlock)(void);

@property (nonatomic,strong) id<KCPostRequestManagerDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *myFilter;
@property NSUInteger myOffset;

- (instancetype)init;
- (void)sendGetPostsRequest;
- (void)sendGetPostsRequestWithCompleteBlock:(CompleteBlock)block;
- (void)setMyOffset:(NSUInteger)myOffset;

@end
