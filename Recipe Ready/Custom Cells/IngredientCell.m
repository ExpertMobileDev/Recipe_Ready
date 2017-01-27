//
//  IngredientCell.m
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "IngredientCell.h"
#import "MyIngredientVC.h"
#import "CreateRecipeVC.h"

@implementation IngredientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)minusAmount:(id)sender {
	UIButton* button = (UIButton*)sender;
	int nId = (int)button.tag;
	if (self.viewController)
		[self.viewController minusAmount:nId];
	else
		[self.viewController1 minusAmount:nId];
}

- (IBAction)plusAmount:(id)sender {
	UIButton* button = (UIButton*)sender;
	int nId = (int)button.tag;
	if (self.viewController)
		[self.viewController plusAmount:nId];
	else
		[self.viewController1 plusAmount:nId];
}

- (IBAction)changeUnit:(id)sender {
	UIButton* button = (UIButton*)sender;
	int nId = (int)button.tag;
	if (self.viewController)
		[self.viewController changeUnits:nId];
	else
		[self.viewController1 changeUnits:nId];
}
@end
