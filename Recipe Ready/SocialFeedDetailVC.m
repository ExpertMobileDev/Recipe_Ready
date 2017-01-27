//
//  SocialFeedDetailVC.m
//  Recipe Ready
//
//  Created by mac on 12/15/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SocialFeedDetailVC.h"
#import "MBProgressHUD.h"
#import "IngredientCell.h"
#import "UIImageView+WebCache.h"
#import "Ingredient.h"
#import "HomeVC.h"
#import "FollowVC.h"

@interface SocialFeedDetailVC ()
{
	NSMutableArray* arrIngredients;
	NSMutableArray* arrFavorite;
	NSMutableArray* arrBasket;
	NSMutableArray* arrRate;
	BOOL bAddFavorite;
	int nReviewMark;
	
	UserInfo* selectedUser;
	NSString* strSelectedUserId;
}

@end

@implementation SocialFeedDetailVC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//arrFavorite = [appdata.arrFavorite mutableCopy];
	arrRate = [[NSMutableArray alloc] init];
	arrBasket = [appdata.arrBasket mutableCopy];
	
	bAddFavorite = NO;
	self.favoriteView.layer.cornerRadius = self.favoriteView.frame.size.width / 2;
	self.favoriteView.clipsToBounds = YES;
	self.avatarImgView.layer.cornerRadius = self.avatarImgView.frame.size.width / 2;
	self.avatarImgView.clipsToBounds = YES;
	
	self.mainView.contentSize = self.containerView.bounds.size;
	
	self.commentStarView.value = 0;
	[self.commentStarView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
	
	[self refreshAccountData];
	[self refreshFavoriteData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"PostedData"]) {
		FollowVC* vcDetail = (FollowVC*) [segue destinationViewController];
		vcDetail.strUserId = strSelectedUserId;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	self.ingredientTblView.hidden = YES;
	
	[self.avatarImgView setImage:[UIImage imageNamed:@"anonymous"]];
	if (self.nStarMark == 0) {
		self.starView.hidden = YES;
		
	} else {
		[self.btnGiveRate setTitle:@"" forState:UIControlStateNormal];
		[self.btnGiveRate setBackgroundColor:[UIColor clearColor]];
		self.starView.hidden = NO;
		self.starView.maximumValue = self.nStarMark;
		self.starView.minimumValue = 0;
		self.starView.tintColor = [UIColor yellowColor];
		self.starView.value = self.nStarMark;
		self.starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, 20*self.nStarMark, 20);
	}
	
	[self showRecipeDetail];
}

- (void)didChangeValue:(id) sender {
	HCSStarRatingView* review = (HCSStarRatingView*)sender;
	nReviewMark = review.value;
}

//getting the registerd account infos
- (void)refreshAccountData {
	[FIRUsers observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap];
			
			if ([aUser.user_id isEqualToString:self.aRecipeDetail.userid]) {
				selectedUser = aUser;
				self.lblUserName.text = [NSString stringWithFormat:@"%@'s recipe", selectedUser.username];
				if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId])
					[self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:selectedUser.avatarName]
			placeholderImage:[UIImage imageNamed:@"anonymous"]];
				break;
			}
		}
	}];
}

- (void)refreshFavoriteData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRFavoriteRecipe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrFavorite removeAllObjects];
		arrFavorite = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			RecipeDetail* aRecipe = [[RecipeDetail alloc] initWithDictionary:dicSnap snapKey:snap.key];
			[arrFavorite addObject:aRecipe];
		}
		
		NSArray *sortedArray = [arrFavorite sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p1.title compare:p2.title];
			
		}];
		arrFavorite = [sortedArray mutableCopy];
		appdata.arrFavorite = [arrFavorite mutableCopy];
		
		for (RecipeDetail* detail in arrFavorite) {
			if (detail.index == self.aRecipeDetail.index) {
				bAddFavorite = YES;
				[self.btnFavorite setImage:[UIImage imageNamed:@"heart_icon_checked"] forState:UIControlStateNormal];
				break;
			}
		}
		
		[self refreshRate];
	}];
}

- (void)refreshRate {
	[FIRRate observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[arrRate removeAllObjects];
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
	}];
}

- (void)showRecipeDetail {
	arrIngredients = self.aRecipeDetail.arrIngredients;
	
	self.ingredientTblView.hidden = NO;
	
	int nTblHeight = 44.f * arrIngredients.count;
	CGRect frame = self.ingredientTblView.frame;
	self.ingredientTblView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, nTblHeight);
	self.ingredientTblView.scrollEnabled = NO;
	
	self.lblRecipeName.text = self.aRecipeDetail.title;
	
	frame = self.lblInstruction.frame;
	self.lblInstruction.frame = CGRectMake(frame.origin.x, self.ingredientTblView.frame.origin.y + nTblHeight + 3, frame.size.width, frame.size.height);
	
	
	NSString* strInstruction = @"";
	if (![AppData isNullOrEmptyString:self.aRecipeDetail.instructions])
		strInstruction = self.aRecipeDetail.instructions;
	
	self.lblInstructions.text = strInstruction;
	
	CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
	
	CGSize expectedLabelSize = [self.lblInstructions.text sizeWithFont:[UIFont fontWithName:@"Arial" size:15] constrainedToSize:maximumLabelSize lineBreakMode:self.lblInstructions.lineBreakMode];
	
	//adjust the label the the new height.
	CGRect newFrame = self.lblInstructions.frame;
	newFrame.size.height = expectedLabelSize.height + 10;
	newFrame.origin.y = self.lblInstruction.frame.origin.y + self.lblInstruction.frame.size.height + 3;
	self.lblInstructions.frame = newFrame;
	
	self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, self.lblInstructions.frame.origin.y + self.lblInstructions.frame.size.height);
	
	self.mainView.contentSize = self.containerView.bounds.size;
	
	NSString *imageUrlString = self.aRecipeDetail.imageName;
	[self.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
						  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
	[self.ingredientTblView reloadData];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrIngredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"IngredientCell";
	IngredientCell *cell= (IngredientCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
	if (cell == nil)
	{
		cell = [[IngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	Ingredient* aIngredient = arrIngredients[indexPath.row];
	cell.lblInggredientName.text = [NSString stringWithFormat:@"%@%@\n", @"• ", aIngredient.name];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

- (IBAction)addIngredientsToBasket:(id)sender {
	self.alertView.hidden = NO;
	self.alertView.alpha = 1.0f;
	self.lblAddedCount.text = [NSString stringWithFormat:@"Added %d Ingredients",arrIngredients.count];
	self.alertView.userInteractionEnabled = NO;
	self.topView.userInteractionEnabled = NO;
	self.mainView.userInteractionEnabled = NO;
	self.momView.userInteractionEnabled = YES;
	
	// Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
	[UIView animateWithDuration:0.5 delay:3.0 options:0 animations:^{
		// Animate the alpha value of your imageView from 1.0 to 0.0 here
		self.alertView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		// Once the animation is completed and the alpha has gone to 0.0, hide the view for good
		self.alertView.hidden = YES;
		self.mainView.userInteractionEnabled = YES;
		self.alertView.userInteractionEnabled = NO;
		self.topView.userInteractionEnabled = YES;
	}];
	
	for (Ingredient* aIngredient in arrIngredients) {
		BOOL bFind = NO;
		for (Ingredient* aBasket in arrBasket) {
			if (aBasket.index == aIngredient.index) {
				bFind = YES;
				break;
			}
		}
		if (!bFind) {
			NSString* strKey = [appdata addIngredientToFirebase:aIngredient];
			aIngredient.snapkey = strKey;
			[arrBasket addObject:aIngredient];
		}
	}
	
	NSArray *sortedArray = [arrBasket sortedArrayUsingComparator:^NSComparisonResult(Ingredient *p1, Ingredient *p2){
		
		return [p1.name compare:p2.name];
		
	}];
	arrBasket = [sortedArray mutableCopy];
	appdata.arrBasket = [arrBasket mutableCopy];
}

- (void) animationAlert {
	self.alertView2.hidden = NO;
	self.alertView2.alpha = 1.0f;
	// Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
	[UIView animateWithDuration:0.5 delay:3.0 options:0 animations:^{
		// Animate the alpha value of your imageView from 1.0 to 0.0 here
		self.alertView2.alpha = 0.0f;
	} completion:^(BOOL finished) {
		// Once the animation is completed and the alpha has gone to 0.0, hide the view for good
		self.alertView2.hidden = YES;
	}];
}

- (IBAction)addRecipeToFavorite:(id)sender {
	if (!bAddFavorite) {
		for (RecipeDetail* recipe in arrFavorite) {
			if (recipe.index == self.aRecipeDetail.index) {
				self.lblMessage.text = @"Already exist!";
				[self animationAlert];
				return;
			}
		}
		bAddFavorite = YES;
		self.lblMessage.text = @"Saved recipe to Favorites";
		[self.btnFavorite setImage:[UIImage imageNamed:@"heart_icon_checked"] forState:UIControlStateNormal];
		[appdata addRecipeToFavorite:self.aRecipeDetail];
	} else {
		bAddFavorite = NO;
		self.lblMessage.text = @"Removed recipe from Favorites";
		[self.btnFavorite setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
		NSLog(@"%d", arrFavorite.count);
		
		int index = 0;
		for (int i = 0; i < arrFavorite.count; i++) {
			RecipeDetail* detail = arrFavorite[i];
			if (detail.index == self.aRecipeDetail.index) {
				index = i;
				break;
			}
		}
		
		RecipeDetail* detail = arrFavorite[index];
		[[FIRFavoriteRecipe child:detail.snapkey] removeValue];
	}
	[self animationAlert];
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeItemsAction:(id)sender {
	HomeVC* vcHome = (HomeVC*)appdata.homeVC;
	[vcHome showIngredientActioin:nil];
}

- (IBAction)giveRate:(id)sender {
	self.commentStarView.value = 0;
	self.giveCommentView.hidden = NO;
	self.maskView.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self.alertView];
	CGRect frame = self.btnSeeItems.frame;
	if (CGRectContainsPoint(frame, touchLocation)) {
		HomeVC* vcHome = (HomeVC*)appdata.homeVC;
		[vcHome showIngredientActioin:nil];
	}
}
- (IBAction)cancelComment:(id)sender {
	self.commentStarView.value = 0;
	self.giveCommentView.hidden = YES;
	self.maskView.hidden = YES;
}

- (IBAction)submitComment:(id)sender {
	self.commentStarView.value = 0;
	self.giveCommentView.hidden = YES;
	self.maskView.hidden = YES;
	
	NSMutableDictionary* dicRate = [[NSMutableDictionary alloc] init];
	
	dicRate[kRecipeId] = [NSNumber numberWithInteger: self.aRecipeDetail.index];
	dicRate[kRateMark] = [NSNumber numberWithInteger:nReviewMark];
	dicRate[kRateMemberCount] = [NSNumber numberWithInteger:1];
	
	NSString* strKey = @"";
	Rate* existRate;
	for (Rate* rate in appdata.arrRate) {
		if (rate.index == self.aRecipeDetail.index) {
			strKey = rate.snapKey;
			existRate = rate;
			break;
		}
	}
	
	
	if (![strKey isEqualToString:@""]) {
		self.nStarMark = (existRate.mark * existRate.member + nReviewMark) / (existRate.member + 1);
		[self.btnGiveRate setTitle:@"" forState:UIControlStateNormal];
		[self.btnGiveRate setBackgroundColor:[UIColor clearColor]];
		self.starView.hidden = NO;
		self.starView.maximumValue = self.nStarMark;
		self.starView.minimumValue = 0;
		self.starView.tintColor = [UIColor yellowColor];
		self.starView.value = self.nStarMark;
		self.starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, 20*self.nStarMark, 20);
		
		[[[FIRRate child:strKey] child:kRateMark] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			currentData.value = [NSNumber numberWithInt:self.nStarMark];
			return [FIRTransactionResult successWithValue:currentData];
		}];
		[[[FIRRate child:strKey] child:kRateMemberCount] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			currentData.value = [NSNumber numberWithInt:existRate.member + 1];
			return [FIRTransactionResult successWithValue:currentData];
		}];
	} else {
		FIRDatabaseReference* rateRef = [FIRRate childByAutoId];
		[rateRef setValue:dicRate];
		
		self.nStarMark = nReviewMark;
		
		[self.btnGiveRate setTitle:@"" forState:UIControlStateNormal];
		[self.btnGiveRate setBackgroundColor:[UIColor clearColor]];
		self.starView.hidden = NO;
		self.starView.maximumValue = self.nStarMark;
		self.starView.minimumValue = 0;
		self.starView.tintColor = [UIColor yellowColor];
		self.starView.value = self.nStarMark;
		self.starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, 20*self.nStarMark, 20);
	}
}

- (IBAction)gotoPersonalData:(id)sender {
	strSelectedUserId = self.aRecipeDetail.userid;
	
	[self performSegueWithIdentifier:@"PostedData" sender:nil];
}

@end
