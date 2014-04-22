//
//  KCAddNewCommentViewController.h
//  Wordpress
//
//  Created by kavi chen on 14-4-21.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RPFloatingPlaceholderTextView.h>
#import <RPFloatingPlaceholderTextField.h>

@interface KCAddNewCommentViewController : UIViewController
@property (nonatomic,strong) RPFloatingPlaceholderTextField *nickNameTextField;
@property (nonatomic,strong) RPFloatingPlaceholderTextField *emailTextField;
@property (nonatomic,strong) RPFloatingPlaceholderTextView *commentTextView;
- (instancetype)init;

@end
