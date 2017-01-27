//
//  SearchRecipeVC.m
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SearchRecipeVC.h"
#import "MBProgressHUD.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "RecipeSearchResult.h"
#import "SearchResultCollectCell.h"
#import "IngredientHintCell.h"
#import "UIImageView+WebCache.h"
#import "RecipeDetailVC.h"
#import "Ingredient.h"
#import "FollowVC.h"

@interface SearchRecipeVC ()
{
	NSMutableArray* searchResult;
	NSMutableArray* searchResultDetail;
	NSMutableArray* arrIngredient;
	NSMutableArray* arrRate;
	NSMutableArray* arrUserInfos;
	NSMutableArray* arrPostedData;
	NSMutableArray* arrKeywords;
	
	int nSelectedMethod;
	NSMutableArray* arrSelected;
	
	NSString* strIngrdientNames;
	NSString* strKeyword;
	int nSelectedRecipeId;
	int nCallIndex;
	BOOL bCancelled;
	int nSelectedRateMark;
	
	NSString* strSelectedUserId;
}

@end

@implementation SearchRecipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	bCancelled = NO;
	arrIngredient = [appdata.arrBasket mutableCopy];
	
	arrSelected = [[NSMutableArray alloc] init];
	arrKeywords = [[NSMutableArray alloc] init];
	for (int i = 0; i < arrIngredient.count; i++) {
		[arrSelected addObject:@"NO"];
	}
	[self.ingredientTblView reloadData];
	
	strIngrdientNames = @"";
}

- (void)viewWillAppear:(BOOL)animated {
	[self refreshPostedData];
	[self refreshUserInfos];
	[self refreshRate];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification
											   object:nil];

}

- (void)keyboardWasShown:(NSNotification *)notification
{
	
	// Get the size of the keyboard.
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	//Given size may not account for screen rotation
	int height = MIN(keyboardSize.height,keyboardSize.width);
	
	//your other code here..........
	CGRect frame = self.ingredientTblView.frame;
	frame.size.height -= height;
	self.ingredientTblView.frame = frame;
	[self.ingredientTblView reloadData];
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
	
	// Get the size of the keyboard.
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	//Given size may not account for screen rotation
	int height = MIN(keyboardSize.height,keyboardSize.width);
	
	//your other code here..........
	CGRect frame = self.ingredientTblView.frame;
	frame.size.height += height;
	self.ingredientTblView.frame = frame;
	[self.ingredientTblView reloadData];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"Detail"]) {		
		RecipeDetailVC* vcDetail = (RecipeDetailVC *) [segue destinationViewController];
		vcDetail.nId = nSelectedRecipeId;
		vcDetail.nStarMark = nSelectedRateMark;
	}
	
	if ([segue.identifier isEqualToString: @"PostedData"]) {
		FollowVC* vcDetail = (FollowVC*) [segue destinationViewController];
		vcDetail.strUserId = strSelectedUserId;
	}
}

- (IBAction)selectSearchMode:(id)sender {
	UISegmentedControl* segment = sender;
	nSelectedMethod = (int)segment.selectedSegmentIndex;
	
	[searchResult removeAllObjects];
	[self.searchResultView reloadData];
	
	strIngrdientNames = @"";
	[self.recipeSearch resignFirstResponder];
	self.recipeSearch.text = @"";
	
	if (nSelectedMethod == BYNAME) {
		self.ingredientTblView.hidden = YES;
		
	} else if (nSelectedMethod == BYINGREDIENT) {
		self.ingredientTblView.hidden = NO;
		[searchResult removeAllObjects];
		arrSelected = [[NSMutableArray alloc] init];
		for (int i = 0; i < arrIngredient.count; i++) {
			[arrSelected addObject:@"NO"];
		}
		[self.ingredientTblView reloadData];
		[self.searchResultView reloadData];
	}
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)getRecipeDetail:(Recipe*) recipe {
	[appdata.me getRecipeDetail:(int)recipe.index  handler:^(NSDictionary *result, NSString *errorMsg) {
		if (result) {
			NSLog(@"%@", result);
			RecipeDetail* recipeDetail = [[RecipeDetail alloc] initWithDictionary:result];
			[searchResultDetail addObject:recipeDetail];
			[self.searchResultView reloadData];
		}
	}];
}

// search recipe among the created recipes
- (void)refreshPostedData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRPostedRecipe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrPostedData removeAllObjects];
		arrPostedData = [[NSMutableArray alloc] init];
		
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			NSLog(@"%@", dicSnap[kUserId]);
			NSLog(@"%@", appdata.me.token);
			
			RecipeDetail* aRecipeDetail = [[RecipeDetail alloc] initWithDictionary:dicSnap];
			[arrPostedData addObject:aRecipeDetail];
		}
		appdata.arrPosted = arrPostedData;

	}];
}

- (void)searchRecipeFromPostedData {
	if (nSelectedMethod == BYNAME) {
		for (RecipeDetail* aRecipeDetail in arrPostedData) {
			NSLog(@"%@", aRecipeDetail);
			for (NSString* keyword in arrKeywords) {
				BOOL bFind = NO;
				if ([aRecipeDetail.title.lowercaseString containsString:keyword.lowercaseString]) {
					BOOL bExist = NO;
					BOOL bCanRead = NO;
					for (UserInfo* aUser in arrUserInfos) {
						if ([aUser.user_id isEqualToString:aRecipeDetail.userid]) {
							if ([aUser.readCreatedRecipeOption isEqualToString:@"Everyone"]) {
								bCanRead = YES;
								break;
							}
						}
					}
					if (bCanRead) {
						for (Recipe* aRecipe in searchResult) {
							if (aRecipe.index == aRecipeDetail.index) {
								bExist = YES;
								break;
							}
						}
						if (!bExist) {
							[searchResultDetail addObject:aRecipeDetail];
							
							Recipe* aRecipe = [[Recipe alloc] init];
							aRecipe.index = aRecipeDetail.index;
							aRecipe.name = aRecipeDetail.title;
							[searchResult addObject:aRecipe];
							bFind = YES;
						}
					}
				}
				
				if (bFind)
					break;
			}
		}
		
		NSArray *sortedArray = [searchResult sortedArrayUsingComparator:^NSComparisonResult(Recipe *p1, Recipe *p2){
			
			return [p1.name compare:p2.name];
			
		}];
		searchResult = [sortedArray mutableCopy];
		[self.searchResultView reloadData];
	} else if (nSelectedMethod == BYINGREDIENT) {
		
		for (RecipeDetail* aRecipeDetail in arrPostedData) {
			BOOL bIncludeAll = YES;
			
			for (NSString* keyword in arrKeywords) {
				BOOL bFind = NO;
				for (Ingredient* aIngredient in aRecipeDetail.arrIngredients) {
					if ([aIngredient.name.lowercaseString containsString:keyword.lowercaseString]) {
						bFind = YES;
						break;
					}
				}
				if (!bFind) {
					bIncludeAll = NO;
					break;
				}
			}
			
			if (bIncludeAll) {
				BOOL bExist = NO;
				int nIdx = 0;
				for (int i = 0; i < searchResult.count; i++) {
					RecipeDetail* aRecipeResult = searchResult[i];

					if ([aRecipeResult.title isEqualToString:aRecipeDetail.title]) {
						nIdx = i;
						bExist = YES;
						break;
					}
				}
				
				BOOL bCanRead = NO;
				for (UserInfo* aUser in arrUserInfos) {
					if ([aUser.user_id isEqualToString:aRecipeDetail.userid]) {
						if ([aUser.readCreatedRecipeOption isEqualToString:@"Everyone"]) {
							bCanRead = YES;
							break;
						}
					}
				}
				
				if (bCanRead) {
					if (!bExist) {
						[searchResult addObject:aRecipeDetail];
					} else {
						[searchResult removeObjectAtIndex:nIdx];
						[searchResult addObject:aRecipeDetail];
					}
				}
			}
		}
		
		NSArray *sortedArray = [searchResult sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p1.title compare:p2.title];
			
		}];
		searchResult = [sortedArray mutableCopy];
		[self.searchResultView reloadData];
	}
}

//getting the registerd account infos
- (void)refreshUserInfos {
	[FIRUsers observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrUserInfos removeAllObjects];
		arrUserInfos = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap];
			[arrUserInfos addObject:aUser];
		}
	}];
}

//getting the rate info
- (void)refreshRate {
	[FIRRate observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
	}];
	[self.searchResultView reloadData];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchBar *)searchBar {
	
	NSString *searchString = [searchBar text];
	[self updateFilteredContentForName:searchString refresh:YES];
}

#pragma mark - UISearchBarDelegate
// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.searchResultView reloadData];
	
	if (nSelectedMethod == BYINGREDIENT) {
		self.recipeSearch.text = @"";
		strIngrdientNames = @"";
		self.ingredientTblView.hidden = NO;
		arrSelected = [[NSMutableArray alloc] init];
		for (int i = 0; i < arrIngredient.count; i++) {
			[arrSelected addObject:@"NO"];
		}
		[self.ingredientTblView reloadData];
	}
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	[self.searchResultView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	//[self updateSearchResultsForSearchController:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	NSString *searchString = [searchBar text];
	if (!bCancelled)
		[self updateFilteredContentForName:searchString refresh:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	bCancelled = YES;
	[self.recipeSearch resignFirstResponder];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForName:(NSString *)strSearch refresh:(BOOL)refresh{
	// Update the filtered array based on the search text and scope.
	if ((strSearch == nil) || [strSearch length] == 0) {
		return;
	}
	
	[searchResult removeAllObjects]; // First clear the filtered array.
	[searchResultDetail removeAllObjects];
	searchResultDetail = [[NSMutableArray alloc] init];
	searchResult = [[NSMutableArray alloc] init];
	
	if (nSelectedMethod == BYNAME) {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
		hud.labelText = @"Searching...";
		strKeyword = strSearch;
		arrKeywords = [[strKeyword componentsSeparatedByString: @" "] mutableCopy];
		NSString *newSearch =[strSearch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[appdata.me searchRecipe:100 query:newSearch handler:^(NSArray *result, NSString *errorMsg) {
			[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
			if (result) {
				NSLog(@"%@", result);
				searchResult = [result mutableCopy];
				[self.searchResultView reloadData];
				[self callRecipeDetail];
			}
		}];
	} else if (nSelectedMethod == BYINGREDIENT) {
		//strIngrdientNames = @"apples,flour,sugar";
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
		hud.labelText = @"Searching...";
		arrKeywords = [[strIngrdientNames componentsSeparatedByString: @","] mutableCopy];
		[appdata.me searchRecipeByIngredients:strIngrdientNames handler:^(NSArray *result, NSString *errorMsg) {
			[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
			if (result) {
				NSLog(@"%@", result);
				self.ingredientTblView.hidden = YES;
				searchResult = [result mutableCopy];
				[self searchRecipeFromPostedData];
			}
		}];
	}
}

- (void)callRecipeDetail {
	nCallIndex = 0;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		while (nCallIndex < searchResult.count) {
			Recipe* recipe = searchResult[nCallIndex];
			[self getRecipeDetail:recipe];
			nCallIndex++;
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			if (nCallIndex == searchResult.count) {
				[self searchRecipeFromPostedData];
			}
		});
	});
}

- (void)gotoPostedData:(id) sender {
	UIButton* button = (UIButton*)sender;
	if (nSelectedMethod == BYNAME) {
		Recipe* aRecipe = searchResult[(int)button.tag];
		for (RecipeDetail* aDetail in searchResultDetail) {
			if (aDetail.index == aRecipe.index) {
				strSelectedUserId = aDetail.userid;
				if ([strSelectedUserId isEqualToString:@""])
					return;
				break;
			}
		}
	} else if (nSelectedMethod == BYINGREDIENT) {
		RecipeDetail* aRecipe = searchResult[(int)button.tag];
		strSelectedUserId = aRecipe.userid;
		if ([strSelectedUserId isEqualToString:@""])
			return;
	}
	
	[self performSegueWithIdentifier:@"PostedData" sender:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
	return searchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	SearchResultCollectCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SearchResultCollectCell" forIndexPath:indexPath];
	if (nSelectedMethod == BYNAME) {
		Recipe* aRecipe = searchResult[indexPath.row];
		
		NSLog(@"%@", aRecipe.name);
		if (cell && aRecipe) {
			//
			cell.recipeImgView.image = [UIImage imageNamed:@"no_recipe"];
			cell.lblRecipeName.text = aRecipe.name;
			
			cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
			cell.avatarImgView.clipsToBounds = YES;
			cell.lblUsername.text = @"Recipe Ready Cook";
			
			cell.btnGoUserPostedData.tag = indexPath.row;
			[cell.btnGoUserPostedData addTarget:self action:@selector(gotoPostedData:) forControlEvents:UIControlEventTouchUpInside];
			
			cell.avatarImgView.image = [UIImage imageNamed:@"anonymous"];

			
			BOOL bExistRate = NO;
			for (Rate* rate in arrRate) {
				if (rate.index == aRecipe.index) {
					bExistRate = YES;
					cell.starView.hidden = NO;
					cell.starView.value = rate.mark;
					cell.starView.maximumValue = rate.mark;
					cell.starView.tintColor = [UIColor yellowColor];
					cell.starView.frame = CGRectMake(cell.starView.frame.origin.x, cell.starView.frame.origin.y, 20*rate.mark, 20);
					
					break;
				}
			}
			
			if (!bExistRate)
				cell.starView.hidden = YES;
			
			cell.avatarImgView.image = [UIImage imageNamed:@"anonymous"];
			
			for (RecipeDetail* aDetail in searchResultDetail) {
				if (aDetail.index == aRecipe.index) {
					
					NSString *imageUrlString = aDetail.imageName;
					[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
										  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
					
					for (UserInfo* aUser in arrUserInfos) {
						if ([aDetail.userid isEqualToString:aUser.user_id]) {
							cell.lblUsername.text = [NSString stringWithFormat:@"%@'s Recipe", aUser.username];
							if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId]) {
								if (![aUser.avatarName isEqualToString:@""])
									[cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:aUser.avatarName]
													  placeholderImage:[UIImage imageNamed:@"anonymous"]];
							}
							break;
						}
					}
					
					break;
				}
			}
		}
	} else if (nSelectedMethod == BYINGREDIENT) {
		RecipeDetail* aRecipe = searchResult[indexPath.row];
		if (cell && aRecipe) {
			//
			cell.lblRecipeName.text = aRecipe.title;
			NSString *imageUrlString = aRecipe.imageName;
			[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
								  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
			
			cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
			cell.avatarImgView.clipsToBounds = YES;
			cell.avatarImgView.image = [UIImage imageNamed:@"anonymous"];
			
			cell.lblUsername.text = @"Recipe Ready Cook";
			
			cell.btnGoUserPostedData.tag = indexPath.row;
			[cell.btnGoUserPostedData addTarget:self action:@selector(gotoPostedData:) forControlEvents:UIControlEventTouchUpInside];

			
			BOOL bExistRate = NO;
			for (Rate* rate in arrRate) {
				if (rate.index == aRecipe.index) {
					bExistRate = YES;
					cell.starView.hidden = NO;
					cell.starView.value = rate.mark;
					cell.starView.maximumValue = rate.mark;
					cell.starView.tintColor = [UIColor yellowColor];
					cell.starView.frame = CGRectMake(cell.starView.frame.origin.x, cell.starView.frame.origin.y, 20*rate.mark, 20);
					
					break;
				}
			}
			
			if (!bExistRate)
				cell.starView.hidden = YES;
			
			for (UserInfo* aUser in arrUserInfos) {
				if ([aRecipe.userid isEqualToString:aUser.user_id]) {
					cell.lblUsername.text = [NSString stringWithFormat:@"%@'s Recipe", aUser.username];
					
					if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId]) {
						if (![aUser.avatarName isEqualToString:@""])
							[cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:aUser.avatarName]
											  placeholderImage:[UIImage imageNamed:@"anonymous"]];
					}

					break;
				}
			}
		}
	}
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (nSelectedMethod == BYNAME) {
		Recipe* aRecipe = searchResult[indexPath.row];
		nSelectedRecipeId = (int)aRecipe.index;
		
		nSelectedRateMark = 0;
		for (Rate* rate in arrRate) {
			if (rate.index == aRecipe.index) {
				nSelectedRateMark = (int)rate.mark;
				break;
			}
		}
	} else if (nSelectedMethod == BYINGREDIENT) {
		RecipeDetail* aRecipe = searchResult[indexPath.row];
		nSelectedRecipeId = (int)aRecipe.index;
		
		nSelectedRateMark = 0;
		for (Rate* rate in arrRate) {
			if (rate.index == aRecipe.index) {
				nSelectedRateMark = (int)rate.mark;
				break;
			}
		}
	}
	
	[self performSegueWithIdentifier:@"Detail" sender:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGRect Rect= [[UIScreen mainScreen] bounds];
	CGFloat width = (Rect.size.width - 2) / 2;
	CGFloat height = width * 250 / 165;
	CGSize size = CGSizeMake(width, height);
	return size;
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrIngredient.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"IngredientHintCell";
	IngredientHintCell *cell= (IngredientHintCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
	if (cell == nil)
	{
		cell = [[IngredientHintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	Ingredient* aIngredient = arrIngredient[indexPath.row];
	cell.lblIngredientName.text = aIngredient.name;
	
	BOOL bSelect = [arrSelected[indexPath.row] boolValue];
	if (bSelect) {
		[cell.checkImgVIew setImage:[UIImage imageNamed:@"check_mark"]];
	} else {
		[cell.checkImgVIew setImage:nil];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	BOOL bSelect = [arrSelected[indexPath.row] boolValue];
	if (bSelect) {
		arrSelected[indexPath.row] = @"NO";
	} else {
		arrSelected[indexPath.row] = @"YES";
	}
	[self.ingredientTblView reloadData];
	
	strIngrdientNames = @"";
	for (int i = 0; i < arrSelected.count; i++) {
		Ingredient* aIngredient = arrIngredient[i];
		NSString* strIngredient = aIngredient.name;
		if ([arrSelected[i] boolValue]) {
			if ([strIngrdientNames isEqualToString:@""]) {
				strIngrdientNames = strIngredient;
			} else {
				strIngrdientNames = [NSString stringWithFormat:@"%@,%@", strIngrdientNames, strIngredient];
			}
		}
	}
	self.recipeSearch.text = strIngrdientNames;
	bCancelled = NO;
	[self.recipeSearch becomeFirstResponder];
	
	
}

@end