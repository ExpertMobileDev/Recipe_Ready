//
//  MyRecipeVC.m
//  Recipe Ready
//
//  Created by mac on 11/23/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "MyRecipeVC.h"
#import "SearchResultCollectCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FavoriteRecipeDetailVC.h"

@interface MyRecipeVC ()
{
	NSMutableArray* arrFavorite;
	NSMutableArray* arrCreated;
	NSMutableArray* arrRate;
	NSMutableArray* arrUserInfos;
	int nSelectedRecipeId;
	int nSelectedRateMark;
	int nSelectedMode;
	RecipeDetail* createdRecipe;
}

@end

@implementation MyRecipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrFavorite = [[NSMutableArray alloc] init];
	arrCreated = [[NSMutableArray alloc] init];
	arrRate = [[NSMutableArray alloc] init];
	arrUserInfos = [[NSMutableArray alloc] init];	
}

- (void)viewWillAppear:(BOOL)animated {
	nSelectedMode = appdata.nMyRecipeShowMode;
	[self setTabState:appdata.nMyRecipeShowMode];
	//[self refreshFavoriteData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString: @"Detail"]) {
		FavoriteRecipeDetailVC* vcDetail = (FavoriteRecipeDetailVC *) [segue destinationViewController];
		vcDetail.nId = nSelectedRecipeId;
		vcDetail.nStarMark = nSelectedRateMark;
		vcDetail.nMode = nSelectedMode;
		vcDetail.currentRecipeDetail = createdRecipe;
	}
}

- (void)setTabState:(int)nIdx {
	if (nIdx == CREATED) {
		self.lblFavoriteTab.textColor = [UIColor darkGrayColor];
		self.favorBottomBar.hidden = YES;
		self.lblCreatedTab.textColor = SelectedColor;
		self.createBottomBar.hidden = NO;
		self.favoriteView.hidden = YES;
		self.createdView.hidden = NO;
		self.btnCreateRecipe.hidden = NO;
		nSelectedMode = CREATED;
		[self refreshCreatedData];
	} else if (nIdx == FAVORITE){
		self.lblFavoriteTab.textColor = SelectedColor;
		self.favorBottomBar.hidden = NO;
		self.lblCreatedTab.textColor = [UIColor darkGrayColor];
		self.createBottomBar.hidden = YES;
		self.favoriteView.hidden = NO;
		self.createdView.hidden = YES;
		self.btnCreateRecipe.hidden = YES;
		nSelectedMode = FAVORITE;
		[self refreshFavoriteData];
	}
}

- (IBAction)selectCreatedTab:(id)sender {
	[self setTabState:CREATED];
}

- (IBAction)selectFavorTab:(id)sender {
	[self setTabState:FAVORITE];
}

- (void)refreshFavoriteData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRFavoriteRecipe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrFavorite removeAllObjects];
		arrFavorite = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			RecipeDetail* aRecipe = [[RecipeDetail alloc] initWithDictionary:dicSnap snapKey:snap.key];
			BOOL bCanRead = NO;
			BOOL bExist = NO;
			for (UserInfo* aUser in arrUserInfos) {
				if ([aUser.user_id isEqualToString:aRecipe.userid]) {
					bExist = YES;
					if ([aUser.readCreatedRecipeOption isEqualToString:@"Everyone"]) {
						bCanRead = YES;
						break;
					}
				}
			}
			if (bCanRead || !bExist)
				[arrFavorite addObject:aRecipe];
		}
		
		NSArray *sortedArray = [arrFavorite sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p1.title compare:p2.title];
			
		}];
		arrFavorite = [sortedArray mutableCopy];
		appdata.arrFavorite = [arrFavorite mutableCopy];
		
		[self refreshRate];
	}];
}

- (void)refreshCreatedData {
	NSLog(@"%@",appdata.me.token);
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRCreatedRecipe observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrCreated removeAllObjects];
		arrCreated = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			NSLog(@"%@", dicSnap[kUserId]);
			NSLog(@"%@", appdata.me.token);
			if ([dicSnap[kUserId] isEqualToString:appdata.me.token]) {
				RecipeDetail* aRecipe = [[RecipeDetail alloc] initWithDictionary:dicSnap];
				[arrCreated addObject:aRecipe];
			}
		}
		
		NSArray *sortedArray = [arrCreated sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p1.title compare:p2.title];
			
		}];
		arrCreated = [sortedArray mutableCopy];
		appdata.arrCreated = [arrCreated mutableCopy];
		
		[self refreshRate];
	}];
}

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
	}];
}


- (IBAction)createNewRecipe:(id)sender {
	[self performSegueWithIdentifier:@"Create" sender:nil];
}

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
		if (nSelectedMode == CREATED)
			[self.createdCollectView reloadData];
		else
			[self.favoriteCollectView reloadData];
		
		[self refreshUserInfo];
	}];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
	int nCount = 0;
	if (nSelectedMode == CREATED)
		nCount = arrCreated.count;
	else if (nSelectedMode == FAVORITE)
		nCount = arrFavorite.count;
	return nCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	SearchResultCollectCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SearchResultCollectCell" forIndexPath:indexPath];
	
	RecipeDetail* aRecipe;
	if (nSelectedMode == CREATED) {
		aRecipe = arrCreated[indexPath.row];
	}
	else if (nSelectedMode == FAVORITE) {
		aRecipe = arrFavorite[indexPath.row];
	}
	
	if (cell && aRecipe) {
		//
		cell.recipeImgView.image = [UIImage imageNamed:@"no_recipe"];
		cell.lblRecipeName.text = aRecipe.title;
		NSString *imageUrlString = aRecipe.imageName;
		[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
							  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
		cell.avatarImgView.clipsToBounds = YES;
		cell.lblUsername.text = @"Recipe Ready Cook";
		
		cell.avatarImgView.image = [UIImage imageNamed:@"anonymous"];
		
		for (UserInfo* aUser in arrUserInfos) {
			if ([aUser.user_id isEqualToString:aRecipe.userid]) {
				cell.lblUsername.text = [NSString stringWithFormat:@"%@'s Recipe", aUser.username];
				
				if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId]) {
					if (![aUser.avatarName isEqualToString:@""])
						[cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:aUser.avatarName]
										  placeholderImage:[UIImage imageNamed:@"anonymous"]];
				}

				break;
			}
		}
		
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
	}
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (nSelectedMode == CREATED) {
		appdata.nMyRecipeShowMode = CREATED;
		createdRecipe = arrCreated[indexPath.row];
	}
	else if (nSelectedMode == FAVORITE) {
		nSelectedMode = FAVORITE;
		appdata.nMyRecipeShowMode = FAVORITE;
		createdRecipe = arrFavorite[indexPath.row];
		for (UserInfo* aUser in arrUserInfos) {
			if ([aUser.user_id isEqualToString:createdRecipe.snapkey]) {
				nSelectedMode = CREATED;
				break;
			}
		}
	}
	
	nSelectedRecipeId = createdRecipe.index;
	
	nSelectedRateMark = 0;
	for (Rate* rate in arrRate) {
		if (rate.index == createdRecipe.index) {
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
