//
//  KCGetTermsRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-12.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCRequestManager.h"

@protocol KCGetTermsRequestManagerDelegate <NSObject>
@required
- (void)achieveGetTermsResponse:(NSArray *)response;
@end

@interface KCGetTermsRequestManager : KCRequestManager
@property (nonatomic,strong) id<KCGetTermsRequestManagerDelegate> delegate;

- (void)sendRequestFromOwner:(id)owner;

@end

