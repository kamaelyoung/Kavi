//
//  KCPostPageViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-3-29.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCPostPageViewController.h"
#import "WPRequestManager.h"

@interface KCPostPageViewController ()
@property (nonatomic,strong) WPRequestManager *requestManager;
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation KCPostPageViewController
@synthesize myPost = _myPost;
@synthesize webView = _webView;

#pragma mark - Initial Function
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Setter & Getter
- (WPRequestManager *)requestManager
{
    return [WPRequestManager sharedInstance];
}

- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _webView;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.myPost objectForKey:@"postTitle"];
    if([self.myPost objectForKey:@"postContent"] == [NSNull null]){
        //        NSString *postID = [self.myPost objectForKey:@"postID"];
        if([self.myPost objectForKey:@"postID"] != [NSNull null]){
            WPRequest *postRequest = [self.requestManager createRequest];
            [self.requestManager setWPRequest:postRequest
                                       Method:@"wp.getPost"
                               withParameters:@[@"1",
                                                postRequest.myUsername,
                                                postRequest.myPassword,
                                                [self.myPost objectForKey:@"postID"]]];
            [self.requestManager spawnConnectWithWPRequest:postRequest
                                                  delegate:self];
        }
    }else{
        NSMutableString *postContent = [NSMutableString stringWithString:@"<link rel=\"stylesheet\" href = \"style.css\" type=\"text/css\"/>"];
        [postContent appendString:[self.myPost objectForKey:@"postContent"]];
//        NSLog(@"%@",postContent);
        NSString *mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
        [self.webView loadHTMLString:postContent
                             baseURL:[NSURL fileURLWithPath:mainBundleDirectory]];
        [self.view addSubview:self.webView];
        NSLog(@"My view frame: %@", NSStringFromCGRect(self.webView.frame));
    }
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

#pragma mark - XMLRPCConnectionDelegate
- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response
{
    if ([request.method isEqualToString:@"wp.getPost"]){
        NSLog(@"%@",[response object]);
        NSMutableString *postContent = [NSMutableString stringWithString:@"<link rel=\"stylesheet\" href = \"style.css\" type=\"text/css\"/>"];
        NSString *rawContent = [[response object] objectForKey:@"post_content"];
        [postContent appendString:rawContent];
        //        NSLog(@"%@",postContent);
        NSString *mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
        [self.webView loadHTMLString:postContent
                             baseURL:[NSURL fileURLWithPath:mainBundleDirectory]];
//        self.webView.frame = CGRectMake(0.0f, 64.0f, [UIScreen mainScreen].bounds.size.width, [uisc]);
        [self.view addSubview:self.webView];
//        [self.navigationController pushViewController:self animated:YES];
        NSLog(@"My view frame: %@", NSStringFromCGRect(self.view.frame));
    }
}

- (void)request:(XMLRPCRequest *)request
didSendBodyData:(float)percent
{
    NSLog(@"%@ %f",request.method,percent);
}


- (void)request:(XMLRPCRequest *)request
didFailWithError:(NSError *)error
{
    
}

- (BOOL)request:(XMLRPCRequest *)request
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return NO;
}

- (void)request:(XMLRPCRequest *)request
didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)request:(XMLRPCRequest *)request
didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
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
