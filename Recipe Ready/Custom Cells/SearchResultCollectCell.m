//
//  SearchResultCollectCell.m
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SearchResultCollectCell.h"

@implementation SearchResultCollectCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
	
	self.starView.maximumValue = 5;
	self.starView.minimumValue = 0;
	self.starView.tintColor = [UIColor yellowColor];
}

@end
