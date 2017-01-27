//
//  CategoryVC.m
//  Recipe Ready
//
//  Created by mac on 11/27/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "CategoryVC.h"
#import "MBProgressHUD.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "SearchResultCollectCell.h"
#import "UIImageView+WebCache.h"
#import "RecipeDetailVC.h"
#import "FollowVC.h"

@interface CategoryVC ()
{
	int nCallIndex;
	NSMutableArray* searchResult;
	NSMutableArray* searchResultDetail;
	NSMutableArray* arrPosted;
	NSMutableArray* arrUserInfos;
	NSMutableArray* arrRate;
	int nSelectedRecipeId;
	int nSelectedRateMark;
	NSString* strSelectedUserId;
}

@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.lblCategoryName.text = self.strSearchKey;
	
	nSelectedRateMark = 0;
	searchResultDetail = [[NSMutableArray alloc] init];
	searchResult = [[NSMutableArray alloc] init];
	arrRate = [[NSMutableArray alloc] init];
	arrUserInfos = [[NSMutableArray alloc] init];
	arrPosted = [[NSMutableArray alloc] init];
	[self getRecipesPerCategory];
	[self refreshRate];
}

// getting recipese from API with category name as keyword
- (void)getRecipesPerCategory {
	[MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
	[appdata.me searchRecipe:100 query:self.strSearchKey handler:^(NSArray *result, NSString *errorMsg) {
		[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
		if (result) {
			NSLog(@"%@", result);
			searchResult = [result mutableCopy];
			[self.recipeCollectView reloadData];
			[self callRecipeDetail];
		}
	}];
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
				[self refreshPostedData];
			}
		});
	});
	
}

- (void)getRecipeDetail:(Recipe*) recipe {
	[appdata.me getRecipeDetail:(int)recipe.index handler:^(NSDictionary *result, NSString *errorMsg) {
		if (result) {
			NSLog(@"%@", result);
			RecipeDetail* recipeDetail = [[RecipeDetail alloc] initWithDictionary:result snapKey:@""];
			[searchResultDetail addObject:recipeDetail];
			[self.recipeCollectView reloadData];
		}
	}];
}

//getting the rated recipes
- (void)refreshRate {
	[FIRRate observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrRate removeAllObjects];
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
		[self.recipeCollectView reloadData];
	}];
}

// search recipe among the created recipes
- (void)searchRecipeFromPostedData {
	for (RecipeDetail* aRecipeDetail in arrPosted) {
		if ([aRecipeDetail.title.lowercaseString containsString:self.strSearchKey.lowercaseString]) {
			BOOL bExist = NO;
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
			}
		}
	}
	
	NSArray *sortedArray = [searchResult sortedArrayUsingComparator:^NSComparisonResult(Recipe *p1, Recipe *p2){
		
		return [p1.name compare:p2.name];
		
	}];
	searchResult = [sortedArray mutableCopy];
}

- (void)refreshPostedData {
	[FIRPostedRecipe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrPosted removeAllObjects];
		arrPosted = [[NSMutableArray alloc] init];

		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			
			RecipeDetail* aRecipeDetail = [[RecipeDetail alloc] initWithDictionary:dicSnap];
			[arrPosted addObject:aRecipeDetail];
		}
		
		appdata.arrPosted = arrPosted;

		[self searchRecipeFromPostedData];
		[self refreshUserInfo];
	}];
}

//getting the registerd account infos
- (void)refreshUserInfo {
	[FIRUsers observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		[arrUserInfos removeAllObjects];
		arrUserInfos = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap];
			[arrUserInfos addObject:aUser];
		}
		[self.recipeCollectView reloadData];
	}];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"Detail"]) {
		RecipeDetailVC* vcDetail = (RecipeDetailVC*) [segue destinationViewController];
		vcDetail.nId = nSelectedRecipeId;
		vcDetail.nStarMark = nSelectedRateMark;
	}
	if ([segue.identifier isEqualToString: @"PostedData"]) {
		FollowVC* vcDetail = (FollowVC*) [segue destinationViewController];
		vcDetail.strUserId = strSelectedUserId;
	}
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoPostedData:(id) sender {
	UIButton* button = (UIButton*)sender;
	Recipe* aRecipe = searchResult[(int)button.tag];
	for (RecipeDetail* aDetail in searchResultDetail) {
		if (aDetail.index == aRecipe.index) {
			strSelectedUserId = aDetail.userid;
			if ([strSelectedUserId isEqualToString:@""])
				return;
			break;
		}
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
	Recipe* aRecipe = searchResult[indexPath.row];
	
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
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	Recipe* aRecipe = searchResult[indexPath.row];
	nSelectedRecipeId = aRecipe.index;

	nSelectedRateMark = 0;
	for (Rate* rate in arrRate) {
		if (rate.index == aRecipe.index) {
			nSelectedRateMark = rate.mark;
			break;
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

@end
