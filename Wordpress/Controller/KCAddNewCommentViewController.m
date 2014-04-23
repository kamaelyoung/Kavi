//
//  KCAddNewCommentViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-21.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCAddNewCommentViewController.h"


@interface KCAddNewCommentViewController ()
@end

@implementation KCAddNewCommentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the code below to add a text field programmatically
    CGRect nameFrame = CGRectMake(20.f, 20.f, 273.f, 40.f);
    self.nickNameTextField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:nameFrame];
    self.nickNameTextField.backgroundColor = [UIColor whiteColor];
    self.nickNameTextField.layer.borderWidth = 1.0f;
    self.nickNameTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.nickNameTextField.floatingLabelActiveTextColor = [UIColor blackColor];
    self.nickNameTextField.floatingLabelInactiveTextColor = [UIColor grayColor];
    self.nickNameTextField.placeholder = @"昵称";
    self.nickNameTextField.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    self.nickNameTextField.animationDirection = RPFloatingPlaceholderAnimateDownward; // You can change animation direction
    [self.view addSubview:self.nickNameTextField];
    
    
    CGRect emailFrame = CGRectMake(20.f, 70.f, 273.f, 40.f);
    self.emailTextField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:emailFrame];
    self.emailTextField.backgroundColor = [UIColor whiteColor];
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.emailTextField.floatingLabelActiveTextColor = [UIColor blackColor];
    self.emailTextField.floatingLabelInactiveTextColor = [UIColor grayColor];
    self.emailTextField.placeholder = @"E-Mail地址(可不填写)";
    self.emailTextField.animationDirection = RPFloatingPlaceholderAnimateDownward;
    [self.view addSubview:self.emailTextField];
    
    
    CGRect commentFrame = CGRectMake(20.f, 130.f, 273.f, 273.f);
    self.commentTextView = [[RPFloatingPlaceholderTextView alloc] initWithFrame:commentFrame];
    self.commentTextView.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    self.commentTextView.backgroundColor = [UIColor whiteColor];
    self.commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.f;
    self.commentTextView.floatingLabelActiveTextColor = [UIColor blackColor];
    self.commentTextView.floatingLabelInactiveTextColor = [UIColor grayColor];
    self.commentTextView.placeholder = @"评论";
    self.commentTextView.animationDirection = RPFloatingPlaceholderAnimateDownward;
    
    [self.view addSubview:self.commentTextView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"添加评论";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
