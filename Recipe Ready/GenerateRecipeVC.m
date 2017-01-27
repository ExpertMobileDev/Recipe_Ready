//
//  GenerateRecipeVC.m
//  Recipe Ready
//
//  Created by mac on 12/10/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "GenerateRecipeVC.h"
#import "Rate.h"
#import "MBProgressHUD.h"
#import "SearchResultCollectCell.h"
#import "UIImageView+WebCache.h"
#import "IngredientHintCell.h"

@interface GenerateRecipeVC ()
{
	NSMutableArray* searchResult;
	NSMutableArray* searchResultDetail;
	NSString* strIngrdientNames;
	NSMutableArray* arrSelected;
	NSMutableArray* arrMyIngredient;
	NSMutableArray* arrRate;
	NSMutableArray* arrSelectedIngredients;
	BOOL bCancelled;
	int nCallIndex;
	int nSelectedRecipeId;
	int nSelectedRateMark;
}

@end

@implementation GenerateRecipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	searchResult = [[NSMutableArray alloc] init];
	searchResultDetail = [[NSMutableArray alloc] init];
	arrSelectedIngredients = [[NSMutableArray alloc] init];
	[self refreshMyIngredients];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshMyIngredients {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRIngredient observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[arrMyIngredient removeAllObjects];
		arrMyIngredient = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Ingredient* aIngredient = [[Ingredient alloc] initWithDictionary:dicSnap snapKey:snap.key];
			[arrMyIngredient addObject:aIngredient];
		}
		
		NSArray *sortedArray = [arrMyIngredient sortedArrayUsingComparator:^NSComparisonResult(Ingredient *p1, Ingredient *p2){
			
			return [p1.name compare:p2.name];
			
		}];
		arrMyIngredient = [sortedArray mutableCopy];
		appdata.arrBasket = [arrMyIngredient mutableCopy];
		
		arrSelected = [[NSMutableArray alloc] init];
		for (int i = 0; i < arrMyIngredient.count; i++) {
			[arrSelected addObject:@"NO"];
		}
		self.myIngredientTblView.hidden = YES;
		[self.myIngredientTblView reloadData];
		[self refreshRate];
	}];
}

- (void)refreshRate {
	[FIRRate observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
	}];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchBar *)searchBar {
	
	NSString *searchString = [searchBar text];
	[self updateFilteredContentForName:searchString refresh:YES];
}

#pragma mark - UISearchBarDelegate
// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.searchResultCollectView reloadData];
	
	self.recipeSearch.text = @"";
	strIngrdientNames = @"";
	self.myIngredientTblView.hidden = NO;
	arrSelected = [[NSMutableArray alloc] init];
	for (int i = 0; i < arrMyIngredient.count; i++) {
		[arrSelected addObject:@"NO"];
	}	
	[self.myIngredientTblView reloadData];
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	[self.searchResultCollectView reloadData];
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
	
	if (appdata.arrBasket.count == 0) {
		strIngrdientNames = self.recipeSearch.text;
	}
	
	appdata.arrSelectedIngredients = arrSelectedIngredients;
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
	hud.labelText = @"Searching...";
	[appdata.me searchRecipeByIngredients:strIngrdientNames handler:^(NSArray *result, NSString *errorMsg) {
		[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
		if (result) {
			NSLog(@"%@", result);
			self.myIngredientTblView.hidden = YES;
			searchResult = [result mutableCopy];
			[self.searchResultCollectView reloadData];
		}
	}];
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
	RecipeDetail* aRecipe = searchResult[indexPath.row];
	if (cell && aRecipe) {
		//
		cell.lblRecipeName.text = aRecipe.title;
		NSString *imageUrlString = aRecipe.imageName;
		[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
							  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		
		cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
		cell.avatarImgView.clipsToBounds = YES;
		cell.lblUsername.text = @"Recipe Ready Cook";
		
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
	RecipeDetail* aRecipe = searchResult[indexPath.row];
	nSelectedRecipeId = (int)aRecipe.index;
	
	appdata.strSelectedImgName = aRecipe.imageName;
	
	appdata.nSelectRecipeIndex = nSelectedRecipeId;
	[self.navigationController popViewControllerAnimated:YES];
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
	return arrMyIngredient.count;
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
	
	Ingredient* aIngredient = arrMyIngredient[indexPath.row];
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
	[self.myIngredientTblView reloadData];
	
	strIngrdientNames = @"";
	[arrSelectedIngredients removeAllObjects];
	for (int i = 0; i < arrSelected.count; i++) {
		Ingredient* aIngredient = arrMyIngredient[i];
		NSString* strIngredient = aIngredient.name;
		if ([arrSelected[i] boolValue]) {
			[arrSelectedIngredients addObject:strIngredient];
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

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	appdata.nSelectRecipeIndex = -1;
}
@end
