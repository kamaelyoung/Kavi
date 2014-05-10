//
//  KCRequestManager.h
//  Wordpress
//
//  Created by kavi chen on 14-4-11.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMLRPC.h>
#import "WPRequestManager.h"
#import <SVProgressHUD.h>

//@protocol KCXXXXXRequestManagerDelegate <NSObject>
//@required
//- (void)achieveXXXXResponse:(NSArray *)response;
//@end

@interface KCRequestManager : NSObject <XMLRPCConnectionDelegate>
@property (nonatomic,strong) WPRequestManager *myRequestManager;
//@property (nonatomic,strong) id<KCXXXXRequestManagerDelegate> delegate;

- (instancetype)init;
- (void)sendRequestFromOwner:(id)owner; // implement it

@end
