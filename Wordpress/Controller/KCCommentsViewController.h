//
//  KCCommentsViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCCommentsViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *myComments;
@property (nonatomic,strong) UILabel *noCommentLabel;
@end
