//
//  KCCommentTableViewCell.m
//  Wordpress
//
//  Created by kavi chen on 14-4-22.
//  Copyright (c) 2014年 kavi chen. All rights reserved.
//

#import "KCCommentTableViewCell.h"

@implementation KCCommentTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 增大 textLabel 与 detailTextLabel 之间的距离
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 0.f, 10.f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
