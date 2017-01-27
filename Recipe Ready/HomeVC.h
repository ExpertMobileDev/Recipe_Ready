//
//  HomeVC.h
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *exploreView;
@property (weak, nonatomic) IBOutlet UIView *myingredientView;
@property (weak, nonatomic) IBOutlet UIView *socialView;
@property (weak, nonatomic) IBOutlet UIView *myrecipeView;
@property (weak, nonatomic) IBOutlet UIView *profileView;

@property (weak, nonatomic) IBOutlet UIImageView *exploreIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *ingredientIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *socialIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *recipeIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *profileIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *lblExplore;
@property (weak, nonatomic) IBOutlet UILabel *lblIngredient;
@property (weak, nonatomic) IBOutlet UILabel *lblSocial;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipe;
@property (weak, nonatomic) IBOutlet UILabel *lblProfile;

@property (weak, nonatomic) IBOutlet UIView *exploreContainerView;
@property (weak, nonatomic) IBOutlet UIView *ingredientContainerView;
@property (weak, nonatomic) IBOutlet UIView *socialContainerView;
@property (weak, nonatomic) IBOutlet UIView *recipeContainerView;
@property (weak, nonatomic) IBOutlet UIView *profileContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *exploreBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ingredientBackground;
@property (weak, nonatomic) IBOutlet UIImageView *socialBackground;
@property (weak, nonatomic) IBOutlet UIImageView *recipeBackground;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;

- (IBAction)showExploreAction:(id)sender;
- (IBAction)showIngredientActioin:(id)sender;
- (IBAction)showSocialAction:(id)sender;
- (IBAction)showRecipeAction:(id)sender;
- (IBAction)showProfileAction:(id)sender;

@end
