//
//  HomeVC.m
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "HomeVC.h"
#import "MyIngredientVC.h"
#import "MyRecipeVC.h"
#import "SocialFeedVC.h"
#import "ProfileVC.h"

@interface HomeVC ()
{
	UINavigationController* navigationExplore;
	UINavigationController* navigationIngredient;
	UINavigationController* navigationMyRecipe;
	UINavigationController* navigationSocial;
	UINavigationController* navigationProfile;

}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.exploreContainerView.hidden = NO;
	self.ingredientContainerView.hidden = YES;
	self.socialContainerView.hidden = YES;
	self.recipeContainerView.hidden = YES;
	self.profileContainerView.hidden = YES;
	
	appdata.homeVC = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectExploreTab:(BOOL) bSelect {
	if (bSelect) {
		self.exploreView.backgroundColor = SelectedColor;
		self.exploreIconImgView.image = [UIImage imageNamed:@"explore_icon_selected"];
		self.lblExplore.textColor = [UIColor whiteColor];
		self.exploreContainerView.hidden = NO;
		self.exploreBackground.hidden = NO;
		[navigationExplore popToRootViewControllerAnimated:NO];
	} else {
		self.exploreView.backgroundColor = [UIColor whiteColor];
		self.exploreIconImgView.image = [UIImage imageNamed:@"explore_icon"];
		self.lblExplore.textColor = UnSelectedWordColor;
		self.exploreContainerView.hidden = YES;
		self.exploreBackground.hidden = YES;
	}
}

- (void)selectIngredientTab:(BOOL) bSelect {
	if (bSelect) {
		self.myingredientView.backgroundColor = SelectedColor;
		self.ingredientIconImgView.image = [UIImage imageNamed:@"myingredient_icon_selected"];
		self.lblIngredient.textColor = [UIColor whiteColor];
		self.ingredientContainerView.hidden = NO;
		self.ingredientBackground.hidden = NO;
		[navigationIngredient popToRootViewControllerAnimated:NO];
		
		MyIngredientVC* vcMyIngredient = (MyIngredientVC*) navigationIngredient.viewControllers[0];
		[vcMyIngredient refreshData];
	} else {
		self.myingredientView.backgroundColor = [UIColor whiteColor];
		self.ingredientIconImgView.image = [UIImage imageNamed:@"myingredient_icon"];
		self.lblIngredient.textColor = UnSelectedWordColor;
		self.ingredientContainerView.hidden = YES;
		self.ingredientBackground.hidden = YES;
	}
}

- (void)selectSocialTab:(BOOL) bSelect {
	if (bSelect) {
		self.socialView.backgroundColor = SelectedColor;
		self.socialIconImgView.image = [UIImage imageNamed:@"social_icon_selected"];
		self.lblSocial.textColor = [UIColor whiteColor];
		self.socialContainerView.hidden = NO;
		self.socialBackground.hidden = NO;
		[navigationSocial popToRootViewControllerAnimated:NO];
		
		SocialFeedVC* vcMyIngredient = (SocialFeedVC*) navigationSocial.viewControllers[0];
		[vcMyIngredient refreshFollowInfo];
	} else {
		self.socialView.backgroundColor = [UIColor whiteColor];
		self.socialIconImgView.image = [UIImage imageNamed:@"social_icon"];
		self.lblSocial.textColor = UnSelectedWordColor;
		self.socialContainerView.hidden = YES;
		self.socialBackground.hidden = YES;
	}
}

- (void)selectRecipeTab:(BOOL) bSelect {
	if (bSelect) {
		self.myrecipeView.backgroundColor = SelectedColor;
		self.recipeIconImgView.image = [UIImage imageNamed:@"myrecipe_icon_selected"];
		self.lblRecipe.textColor = [UIColor whiteColor];
		self.recipeContainerView.hidden = NO;
		self.recipeBackground.hidden = NO;
		[navigationMyRecipe popToRootViewControllerAnimated:NO];
		
		MyRecipeVC* vcMyRecipe = (MyRecipeVC*) navigationMyRecipe.viewControllers[0];
		[vcMyRecipe refreshFavoriteData];
	} else {
		self.myrecipeView.backgroundColor = [UIColor whiteColor];
		self.recipeIconImgView.image = [UIImage imageNamed:@"myrecipe_icon"];
		self.lblRecipe.textColor = UnSelectedWordColor;
		self.recipeContainerView.hidden = YES;
		self.recipeBackground.hidden = YES;
	}
}

- (void)selectProfileTab:(BOOL) bSelect {
	if (bSelect) {
		self.profileView.backgroundColor = SelectedColor;
		self.profileIconImgView.image = [UIImage imageNamed:@"profile_icon_selected"];
		self.lblProfile.textColor = [UIColor whiteColor];
		self.profileContainerView.hidden = NO;
		self.profileBackground.hidden = NO;
		
		[navigationProfile popToRootViewControllerAnimated:NO];
		
	} else {
		self.profileView.backgroundColor = [UIColor whiteColor];
		self.profileIconImgView.image = [UIImage imageNamed:@"profile_icon"];
		self.lblProfile.textColor = UnSelectedWordColor;
		self.profileContainerView.hidden = YES;
		self.profileBackground.hidden = YES;
	}
}

- (IBAction)showExploreAction:(id)sender {
	[self selectExploreTab:YES];
	[self selectRecipeTab:NO];
	[self selectIngredientTab:NO];
	[self selectSocialTab:NO];
	[self selectProfileTab:NO];
}

- (IBAction)showIngredientActioin:(id)sender {
	[self selectExploreTab:NO];
	[self selectRecipeTab:NO];
	[self selectIngredientTab:YES];
	[self selectSocialTab:NO];
	[self selectProfileTab:NO];
}

- (IBAction)showSocialAction:(id)sender {
	[self selectExploreTab:NO];
	[self selectRecipeTab:NO];
	[self selectIngredientTab:NO];
	[self selectSocialTab:YES];
	[self selectProfileTab:NO];
}

- (IBAction)showRecipeAction:(id)sender {
	[self selectExploreTab:NO];
	[self selectRecipeTab:YES];
	[self selectIngredientTab:NO];
	[self selectSocialTab:NO];
	[self selectProfileTab:NO];
}

- (IBAction)showProfileAction:(id)sender {
	[self selectExploreTab:NO];
	[self selectRecipeTab:NO];
	[self selectIngredientTab:NO];
	[self selectSocialTab:NO];
	[self selectProfileTab:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"Explore"]) {
		navigationExplore = (UINavigationController *) [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString: @"Ingredient"]) {
		navigationIngredient = (UINavigationController *) [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString: @"Recipe"]) {
		navigationMyRecipe = (UINavigationController *) [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString: @"Social"]) {
		navigationSocial = (UINavigationController *) [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString: @"Profile"]) {
		navigationProfile = (UINavigationController *) [segue destinationViewController];
	}
}

@end
