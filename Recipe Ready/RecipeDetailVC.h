//
//  RecipeDetailVC.h
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface RecipeDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet UITableView *ingredientTblView;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UILabel *lblAddedCount;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeItems;
@property (weak, nonatomic) IBOutlet UIView *alertView2;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UIButton *btnGiveRate;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;

@property (weak, nonatomic) IBOutlet UIView *giveCommentView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *commentStarView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) IBOutlet UIView *momView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruction;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (nonatomic, assign) int nId;
@property (nonatomic, assign) int nStarMark;

- (IBAction)addIngredientsToBasket:(id)sender;
- (IBAction)addRecipeToFavorite:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)seeItemsAction:(id)sender;
- (IBAction)giveRate:(id)sender;
- (IBAction)cancelComment:(id)sender;
- (IBAction)submitComment:(id)sender;
- (IBAction)showUsersPostedData:(id)sender;

@end
