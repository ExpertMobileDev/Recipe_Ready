//
//  CreateRecipeVC.h
//  Recipe Ready
//
//  Created by mac on 12/9/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateRecipeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UITableView *myIngredientTblView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;
@property (weak, nonatomic) IBOutlet UITableView *ingredientTblView;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruction;
@property (weak, nonatomic) IBOutlet UIButton *btnAddInstruction;
@property (weak, nonatomic) IBOutlet UIButton *btnAddIngredients;
@property (weak, nonatomic) IBOutlet UILabel *lblIngredient;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *ingredientView;
@property (weak, nonatomic) IBOutlet UIView *instructionView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextView *instructionTxtView;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImgView;
@property (weak, nonatomic) IBOutlet UIView *myingredientView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIView *selectUnitView;
@property (weak, nonatomic) IBOutlet UITableView *unitTblView;

- (IBAction)backAction:(id)sender;
- (IBAction)addRecipeImage:(id)sender;
- (IBAction)addIngredients:(id)sender;
- (IBAction)addInstructions:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

- (void)minusAmount:(int) nId;
- (void)plusAmount:(int) nId;
- (void)changeUnits:(int)nId;

@end
