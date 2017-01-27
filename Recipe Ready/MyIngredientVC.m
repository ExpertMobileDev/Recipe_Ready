//
//  MyIngredientVC.m
//  Recipe Ready
//
//  Created by mac on 11/20/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "MyIngredientVC.h"
#import "IngredientCollectCell.h"
#import "IngredientCell.h"
#import "Ingredient.h"
#import "IngredientInfo.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "IngredientSearchCell.h"
#import "IngredientNameCell.h"
#import "HeaderCell.h"

@interface MyIngredientVC ()
{
	NSMutableArray* arrIngredient;
	NSMutableArray* arrSearchResult;
	NSMutableArray* arrUnitSingular;
	NSMutableArray* arrUnitPlural;
	BOOL bShowAddView;
	BOOL bEditable;
	int nAddMode;
	int nSelectedIndex;
	NSMutableArray* arrSelected;
}

@end

@implementation MyIngredientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	bEditable = NO;
	nAddMode = NONE_MODE;
	
	arrSelected = [[NSMutableArray alloc] init];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"Unit" ofType:@"plist"];
	NSString *paths = [[NSBundle mainBundle] pathForResource:
					  @"Units" ofType:@"plist"];
 
	// Build the array from the plist
	arrUnitSingular = [[NSMutableArray alloc] initWithContentsOfFile:path];
	arrUnitPlural = [[NSMutableArray alloc] initWithContentsOfFile:paths];
	
	NSLog(@"%@", arrUnitSingular);
	
	UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearUnitView)];
	[tap setNumberOfTapsRequired:1];
	[self.maskView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
	bShowAddView = NO;
	self.ingreditTblView.hidden = YES;
}

- (void)disappearUnitView {
	self.maskView.hidden = YES;
	self.selectUnitView.hidden = YES;
}

- (void)refreshData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRIngredient observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[arrIngredient removeAllObjects];
		arrIngredient = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;			
			Ingredient* aIngredient = [[Ingredient alloc] initWithDictionary:dicSnap snapKey:snap.key];
			[arrIngredient addObject:aIngredient];
		}
		
//		NSArray *sortedArray = [arrIngredient sortedArrayUsingComparator:^NSComparisonResult(Ingredient *p1, Ingredient *p2){
//			
//			return [p1.name compare:p2.name];
//			
//		}];
//		arrIngredient = [sortedArray mutableCopy];
		appdata.arrBasket = [arrIngredient mutableCopy];
		self.ingreditTblView.hidden = NO;
		[self.ingreditTblView reloadData];
	}];	
}

- (IBAction)editIngredient:(id)sender {
	if (nAddMode == NONE_MODE) {
		if (!bEditable) {
			bEditable = YES;
			[self.btnEdit setTitle:@"Done" forState:UIControlStateNormal];
			[self.ingreditTblView setEditing:YES animated:YES];
		} else {
			bEditable = NO;
			[self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
			[self.ingreditTblView setEditing:NO animated:YES];
		}
	} else {
		BOOL bSelected = NO;
		for (int i = 0; i < arrSearchResult.count; i++) {
			Ingredient* search = arrSearchResult[i];
			if ([arrSelected[i] boolValue]) {
				bSelected = YES;
				
				BOOL bSameExist = NO;
				for (Ingredient* aIngredient in arrIngredient) {
					if ([aIngredient.name isEqualToString:search.name]) {
						bSameExist = YES;
						break;
					}
				}
				
				if (!bSameExist) {
					NSString* strKey = [appdata addIngredientToFirebase:search];
					search.snapkey = strKey;
					NSLog(@"%@", search);
					[arrIngredient addObject:search];
				}
			}
		}
		
		if (!bSelected) {
			return;
		}

		self.searchResultTblView.hidden = YES;
		self.ingredientSearch.hidden = YES;
		self.ingredientSearch.frame = CGRectMake(0, -44, self.ingredientSearch.frame.size.width, self.ingredientSearch.frame.size.height);
		[self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
		
		nAddMode = NONE_MODE;
	}
}

- (IBAction)addIngredients:(id)sender {
	[self showAddIngredientView];
}

- (IBAction)addIngredientBySearch:(id)sender {
	bShowAddView = NO;
	self.addIngredientView.hidden = YES;
	nAddMode = BYSEARCH;
	
	self.ingredientSearch.hidden = NO;
	
	self.ingredientSearch.frame = CGRectMake(0, 0, self.ingredientSearch.frame.size.width, self.ingredientSearch.frame.size.height);
}

- (IBAction)addIngredientByBarcode:(id)sender {
	bShowAddView = NO;
	self.addIngredientView.hidden = YES;
	nAddMode = BYBARCODE;
}

- (void)showAddIngredientView {
//	if (bShowAddView) {
//		bShowAddView = NO;
//		//self.addIngredientView.hidden = YES;
//	} else {
//		bShowAddView = YES;
//		//self.addIngredientView.hidden = NO;
//	}
	[self addIngredientBySearch:nil];
}

- (void)minusAmount:(int) nId {
	Ingredient* aIngredient = arrIngredient[nId];
	float nAmount = aIngredient.amount;
	
	NSMutableArray* arrUnit;
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	int nCategoryIndex = 0, nUnitIndex = 0;
	NSString* strUnit = aIngredient.unit;
	BOOL bExist = NO;
	for (int i = 0; i < arrUnit.count; i++) {
		NSDictionary* unit = arrUnit[i];
		NSArray* arrSub = unit[@"units"];
		for (NSString* strName in arrSub) {
			if ([strName isEqualToString:strUnit]) {
				nCategoryIndex = i;
				nUnitIndex = [arrSub indexOfObject:strName];
				bExist = YES;
				break;
			}
		}
		if (bExist)
			break;
	}
	
	if (nAmount > 1.0f)
		nAmount -= 1.0f;
	
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	[[[FIRIngredient child:aIngredient.snapkey] child:kIngredientAmount] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
		currentData.value = [NSNumber numberWithInt:nAmount];
		return [FIRTransactionResult successWithValue:currentData];
	}];

	if (bExist) {
		NSString* strUpdatedUnit = arrUnit[nCategoryIndex][@"units"][nUnitIndex];
		[[[FIRIngredient child:aIngredient.snapkey] child:kIngredientUnit] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			currentData.value = strUpdatedUnit;
			return [FIRTransactionResult successWithValue:currentData];
		}];
	}
}

- (void)plusAmount:(int) nId {
	Ingredient* aIngredient = arrIngredient[nId];
	float nAmount = aIngredient.amount;
	
	NSMutableArray* arrUnit;
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	int nCategoryIndex = 0, nUnitIndex = 0;
	NSString* strUnit = aIngredient.unit;
	BOOL bExist = NO;
	for (int i = 0; i < arrUnit.count; i++) {
		NSDictionary* unit = arrUnit[i];
		NSArray* arrSub = unit[@"units"];
		for (NSString* strName in arrSub) {
			if ([strName isEqualToString:strUnit]) {
				nCategoryIndex = i;
				nUnitIndex = [arrSub indexOfObject:strName];
				bExist = YES;
				break;
			}
		}
		if (bExist)
			break;
	}

	nAmount += 1.0f;
	[[[FIRIngredient child:aIngredient.snapkey] child:kIngredientAmount] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
		currentData.value = [NSNumber numberWithInt:nAmount];
		return [FIRTransactionResult successWithValue:currentData];
	}];
	
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	if (bExist) {
		NSString* strUpdatedUnit = arrUnit[nCategoryIndex][@"units"][nUnitIndex];
		[[[FIRIngredient child:aIngredient.snapkey] child:kIngredientUnit] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			currentData.value = strUpdatedUnit;
			return [FIRTransactionResult successWithValue:currentData];
		}];
	}
}

- (void)changeUnits:(int)nId {
	self.maskView.hidden = NO;
	self.selectUnitView.hidden = NO;
	nSelectedIndex = nId;
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int nCount = 0;
	if (tableView.tag == 101)
		nCount = (int)arrIngredient.count;
	else if (tableView.tag == 102)
		nCount = (int)arrSearchResult.count;
	else if (tableView.tag == 103) {
		nCount = (int)[arrUnitSingular[section][@"units"] count];
	}
	return nCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int nCount = 1;
	if (tableView.tag == 103) {
		nCount = (int)arrUnitSingular.count;
	}
	return nCount;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	HeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];

	if (tableView.tag == 103) {
		// 1. Dequeue the custom header cell
		
		NSLog(@"%@", arrUnitSingular[section][@"category"]);
		// 2. Set the various properties
		headerCell.lblSectionName.text = arrUnitSingular[section][@"category"];
		
		// 3. And return
		return headerCell;
	} else
		return nil;
	return headerCell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	int nHeight = 0;
	if (tableView.tag == 103)
		nHeight = 44;
	return nHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"IngredientCell";
	IngredientCell *cell= (IngredientCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

	if (tableView.tag == 101) {
		IngredientCell *cell= (IngredientCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

		if (cell == nil)
		{
			cell = [[IngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.viewController = self;
		cell.btnMinus.tag = (int)indexPath.row;
		cell.btnPlus.tag = (int)indexPath.row;
		cell.btnUnits.tag = (int)indexPath.row;
		
		Ingredient* aIngredient = arrIngredient[indexPath.row];
		cell.lblInggredientName.text = aIngredient.name;
		if (aIngredient.amount - floor(aIngredient.amount) > 0)
			cell.lblAmount.text = [NSString stringWithFormat:@"%0.2f", aIngredient.amount];
		else if (aIngredient.amount - floor(aIngredient.amount) == 0) {
			cell.lblAmount.text = [NSString stringWithFormat:@"%d", (int)aIngredient.amount];
		}
		
		NSLog(@"%@", aIngredient.unit);
		if (![aIngredient.unit isEqualToString:@""])
			cell.lblUnit.text = [NSString stringWithFormat:@"(%@)", aIngredient.unit];
		else
			cell.lblUnit.text = @"";
		
		NSString *imageUrlString = aIngredient.imgName;
		[cell.ingredientImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
								  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		return cell;
	} else if (tableView.tag == 102) {
		static NSString *simpleTableIdentifier = @"IngredientSearchCell";
		IngredientSearchCell *cell= (IngredientSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

		if (cell == nil)
		{
			cell = [[IngredientSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		Ingredient* aIngredient = arrSearchResult[indexPath.row];
		cell.lblIngredientName.text = aIngredient.name;
		
		NSString *imageUrlString = aIngredient.imgName;
		[cell.ingredientImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
								  placeholderImage:[UIImage imageNamed:@"no_recipe"]];

		
		BOOL bSelect = [arrSelected[indexPath.row] boolValue];
		if (bSelect) {
			[cell.checkImgView setImage:[UIImage imageNamed:@"check_mark"]];
		} else {
			[cell.checkImgView setImage:nil];
		}
		
		return cell;
	} else if (tableView.tag == 103) {
		static NSString *simpleTableIdentifier = @"IngredientNameCell";
		IngredientNameCell *cell= (IngredientNameCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
		
		if (cell == nil)
		{
			cell = [[IngredientNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		NSString* strUnit = arrUnitSingular[indexPath.section][@"units"][indexPath.row];
		cell.lblIngredientName.text = strUnit;
	
		return cell;
	}
	
	return cell;
}
	
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (tableView.tag == 101) {
	} else if (tableView.tag == 102) {
		BOOL bSelect = [arrSelected[indexPath.row] boolValue];
		if (bSelect) {
			arrSelected[indexPath.row] = @"NO";
		} else {
			arrSelected[indexPath.row] = @"YES";
		}
		[self.searchResultTblView reloadData];
		
		for (int i = 0; i < arrSelected.count; i++) {
			if ([arrSelected[i] boolValue]) {
				[self.btnEdit setTitle:@"Done" forState:UIControlStateNormal];
				break;
			}
		}
	} else if (tableView.tag == 103) {
		NSString* strUnitName;
		Ingredient* aIngredient = arrIngredient[nSelectedIndex];
		if (aIngredient.amount > 1)
			strUnitName = arrUnitPlural[indexPath.section][@"units"][indexPath.row];
		else
			strUnitName = arrUnitSingular[indexPath.section][@"units"][indexPath.row];
		
		[[[FIRIngredient child:aIngredient.snapkey] child:kIngredientUnit] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			currentData.value = strUnitName;
			return [FIRTransactionResult successWithValue:currentData];
		}];
		self.maskView.hidden = YES;
		self.selectUnitView.hidden = YES;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Ingredient* aIngredient = arrIngredient[indexPath.row];
		[[FIRIngredient child:aIngredient.snapkey] removeValue];
		[arrIngredient removeObjectAtIndex:indexPath.row];
		[self.ingreditTblView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark Table View Delegate Methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchBar *)searchBar {
	
//	NSString *searchString = [searchBar text];
//	[self updateFilteredContentForName:searchString refresh:YES];
}

#pragma mark - UISearchBarDelegate
// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.searchResultTblView reloadData];
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	[self.searchResultTblView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	//[self updateSearchResultsForSearchController:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	NSString *searchString = [searchBar text];
	[self updateFilteredContentForName:searchString refresh:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.ingredientSearch.frame = CGRectMake(0, -44, self.ingredientSearch.frame.size.width, self.ingredientSearch.frame.size.height);
	nAddMode = NONE_MODE;
	self.searchResultTblView.hidden = YES;
	self.ingredientSearch.hidden = YES;
	[self.ingredientSearch resignFirstResponder];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForName:(NSString *)strSearch refresh:(BOOL)refresh{
	// Update the filtered array based on the search text and scope.
	if ((strSearch == nil) || [strSearch length] == 0) {
		return;
	}
	
	[arrSearchResult removeAllObjects]; // First clear the filtered array.
	arrSearchResult = [[NSMutableArray alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
	[appdata.me searchIngredients:strSearch handler:^(NSArray *result, NSString *errorMsg) {
		[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
		if (result) {
			NSLog(@"%@", result);
			arrSearchResult = [result mutableCopy];
			if (arrSearchResult.count > 0) {
				arrSelected = [[NSMutableArray alloc] init];
				for (int i = 0; i < arrSearchResult.count; i++) {
					[arrSelected addObject:@"NO"];
				}
				self.searchResultTblView.hidden = NO;
				[self.searchResultTblView reloadData];
			}
		}
	}];
}

@end
