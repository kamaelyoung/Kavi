//
//  KCPostPageViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-29.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageViewController.h"
#import "KCPostPageGetCommentsConnector.h"

@interface KCPostPageViewController ()
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) KCPostPageGetCommentsConnector *myConnector;
@end

@implementation KCPostPageViewController
@synthesize myPost = _myPost;
@synthesize webView = _webView;
@synthesize myConnector = _myConnector;

#pragma mark - Initial Function
- (instancetype)initWithMyPost:(NSMutableDictionary *)myPost
{
    self = [super init];
    if (self) {
        self.myPost = myPost;
        NSLog(@"%@",self.myPost);
        
        [self.view addSubview:self.webView];
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setFrame:CGRectMake(0.0f, 0.0f, 44.0f, 41.0f)];
        [commentButton setImage:[UIImage imageNamed:@"CommentIcon"]
                       forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(pushCommentView) forControlEvents:UIControlEventTouchUpInside];
    
        [commentButton setImage:[UIImage imageNamed:@"TouchedCommentIcon"]
                       forState:UIControlStateHighlighted];
        
        UIBarButtonItem *commentButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
        self.navigationItem.rightBarButtonItem = commentButtonItem;
    }
    return self;
}

#pragma mark - Setter & Getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (KCPostPageGetCommentsConnector *)myConnector
{
    if (!_myConnector){
        _myConnector = [[KCPostPageGetCommentsConnector alloc] init];
    }
    return _myConnector;
}

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
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
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

- (void)pushCommentView
{
    NSString *postID = [self.myPost objectForKey:@"postID"];
    NSMutableDictionary *myFilter = [NSMutableDictionary dictionaryWithObject:postID forKey:@"post_id"];

    
    self.myConnector = [[KCPostPageGetCommentsConnector alloc] init];
    [self.myConnector sendGetCommentsRequestWith:myFilter];
    
    [self.navigationController pushViewController:self.myConnector.commentsViewController
                                         animated:YES];

}

@end
