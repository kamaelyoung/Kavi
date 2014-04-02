//
//  KCPostPageViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-3-29.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC.h>

@interface KCPostPageViewController : UIViewController 

@property (nonatomic,strong) NSMutableDictionary *myPost;

- (instancetype)initWithMyPost:(NSMutableDictionary *)myPost;

@end
