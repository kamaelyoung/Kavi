//
//  KCPostPageViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-29.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageViewController.h"

@interface KCPostPageViewController ()
//@property (nonatomic,strong) UIWebView *webView;
@end

@implementation KCPostPageViewController
@synthesize myPost = _myPost;
//@synthesize webView = _webView;

#pragma mark - Initial Function
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Setter & Getter
//- (UIWebView *)webView
//{
//    if(!_webView){
//        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    }
//    return _webView;
//}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableString *postContent = [NSMutableString stringWithString:@"<link rel=\"stylesheet\" href = \"style.css\" type=\"text/css\"/>"];
    [postContent appendString:[self.myPost objectForKey:@"postContent"]];
    NSString *mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [webView loadHTMLString:postContent
                    baseURL:[NSURL fileURLWithPath:mainBundleDirectory]];
    [self.view addSubview:webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.myPost objectForKey:@"postTitle"];
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
