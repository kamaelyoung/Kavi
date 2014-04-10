//
//  KCCategoryViewController.m
//  Wordpress
//
//  Created by kavi chen on 14-4-9.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCategoryViewController.h"

@interface KCCategoryViewController ()
@property (nonatomic,strong) KCGetTermsRequestManager *getTermsRequestManager;
@property (nonatomic,strong) KCCategoryTableViewController *tableViewController;
@end

@implementation KCCategoryViewController
@synthesize getTermsRequestManager = _getTermsRequestManager;

#pragma mark - Getter && Setter
- (KCGetTermsRequestManager *)getTermsRequestManager
{
    if (!_getTermsRequestManager) {
        _getTermsRequestManager = [[KCGetTermsRequestManager alloc] init];
    }
    return _getTermsRequestManager;
}

- (KCCategoryTableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[KCCategoryTableViewController alloc] init];
    }
    return _tableViewController;
}

#pragma mark - Initial method
+ (instancetype)sharedInstance
{
    static KCCategoryViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KCCategoryViewController alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - View Controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

#pragma mark - KCGetTermsRequestDelegate
- (void)achieveTermsResponse:(NSArray *)response
{
    
}

@end
