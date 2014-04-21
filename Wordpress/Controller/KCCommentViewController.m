//
//  KCCommentViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-18.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCommentViewController.h"

@interface KCCommentViewController ()
@property (nonatomic,strong) DCCommentView *commentView;
@end

@implementation KCCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentView = [DCCommentView new];
    self.commentView.delegate = self;
    self.commentView.tintColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.commentView bindToScrollView:self.t superview:<#(UIView *)#>]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
