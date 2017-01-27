//
//  IngredientCell.h
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyIngredientVC;
@class CreateRecipeVC;

@interface IngredientCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblInggredientName;
@property (weak, nonatomic) MyIngredientVC* viewController;
@property (weak, nonatomic) CreateRecipeVC* viewController1;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnUnits;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIImageView *ingredientImgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;

- (IBAction)minusAmount:(id)sender;
- (IBAction)plusAmount:(id)sender;
- (IBAction)changeUnit:(id)sender;

@end
