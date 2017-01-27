//
//  IngredientHintCell.h
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientHintCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblIngredientName;
@property (nonatomic, assign) BOOL bCheck;
@property (weak, nonatomic) IBOutlet UIImageView *checkImgVIew;

@end
