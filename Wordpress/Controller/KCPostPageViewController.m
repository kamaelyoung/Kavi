//
//  KCPostPageViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-29.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageViewController.h"

@interface KCPostPageViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation KCPostPageViewController
@synthesize myPost = _myPost;
@synthesize webView = _webView;

#pragma mark - Initial Function
- (instancetype)initWithMyPost:(NSMutableDictionary *)myPost
{
    self = [super init];
    if (self) {
        self.myPost = myPost;
        [self.view addSubview:self.webView];
    }
    return self;
}

#pragma mark - Setter & Getter

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *prefix = @"<link rel=\"stylesheet\" href = \"style.css\" type=\"text/css\"/>";
    NSMutableString *postContent = [NSMutableString string];
    [postContent appendString:prefix];
    [postContent appendString:[self.myPost objectForKey:@"postContent"]];
    
    NSString *mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
    [self.webView loadHTMLString:postContent
                    baseURL:[NSURL fileURLWithPath:mainBundleDirectory]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.myPost objectForKey:@"postTitle"];
    // webView 的 Size 要与 self.view.frame.size 保持一致
    self.webView.frame = CGRectMake(CGPointZero.x,
                                    CGPointZero.y,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
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
