//
//  SocialFeedCell.m
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SocialFeedCell.h"
#import "SocialFeedVC.h"

@implementation SocialFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.starView.maximumValue = 5;
	self.starView.minimumValue = 0;
	self.starView.tintColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
