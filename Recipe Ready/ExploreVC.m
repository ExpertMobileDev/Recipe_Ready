//
//  ExploreVC.m
//  Recipe Ready
//
//  Created by mac on 11/20/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "ExploreVC.h"
#import "CategoryCell.h"
#import "MBProgressHUD.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "UIImageView+WebCache.h"
#import "CategoryVC.h"


@interface ExploreVC ()
{
	NSMutableArray* arrCategory;
	UITapGestureRecognizer *singleTapGestureRecognizer;
	NSString* strCategoryName;
}
@end

@implementation ExploreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"Category" ofType:@"plist"];
 
	// Build the array from the plist
	arrCategory = [[NSMutableArray alloc] initWithContentsOfFile:path];
	[self.categoryCollectionView reloadData];
}

- (IBAction)gotoSearch:(id)sender {
	[self performSegueWithIdentifier:@"Search" sender:nil];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString: @"Category"]) {
		CategoryVC* vcCategory = (CategoryVC *) [segue destinationViewController];
		vcCategory.strSearchKey = strCategoryName;
	}
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
	return arrCategory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	CategoryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
	NSDictionary* dicCategory = arrCategory[indexPath.row];
	
	if (cell && dicCategory) {
		//
		cell.recipeIconView.image = [UIImage imageNamed:dicCategory[@"IconName"]];
		cell.lblRecipeName.text = dicCategory[@"RecipeName"];
		
		CGRect rect = self.categoryCollectionView.frame;
		self.categoryCollectionView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, cell.frame.size.height * 3);
	}
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	int nId = (int)indexPath.row;
	strCategoryName = arrCategory[nId][@"RecipeName"];
	[self performSegueWithIdentifier:@"Category" sender:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGRect Rect= self.categoryCollectionView.frame;
	CGFloat width = (Rect.size.width - 0) / 3;
	CGFloat height = width;
	CGSize size = CGSizeMake(width, height);
	return size;
}

@end
