//
//  SocialFeedVC.m
//  Recipe Ready
//
//  Created by mac on 11/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SocialFeedVC.h"
#import "SocialFeedCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SocialFeedDetailVC.h"
#import "FollowVC.h"


@interface SocialFeedVC ()
{
	NSMutableArray* arrFeedList;
	NSMutableArray* arrCreated;
	NSMutableArray* arrAccount;
	NSMutableArray* arrRate;
	NSMutableArray* arrFavorite;
	NSMutableArray* arrFollowingUserId;

	int nSelectedRateMark;
	RecipeDetail* selectedRecipe;
	NSString* strSelectedUserId;
	BOOL bCanReadPhoto;
}

@end

@implementation SocialFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrFeedList = [[NSMutableArray alloc] init];
	arrRate = [[NSMutableArray alloc] init];
	arrAccount = [[NSMutableArray alloc] init];
	arrCreated = [[NSMutableArray alloc] init];
	arrFavorite = [[NSMutableArray alloc] init];
	arrFollowingUserId = [[NSMutableArray alloc] init];
	bCanReadPhoto = NO;
}

- (void) viewWillAppear:(BOOL)animated {
	[self refreshFollowInfo];
//	arrFavorite = appdata.arrFavorite;
	[self.socialFeedTblView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"Detail"]) {
		SocialFeedDetailVC* vcDetail = (SocialFeedDetailVC *) [segue destinationViewController];
		vcDetail.aRecipeDetail = selectedRecipe;
		vcDetail.nStarMark = nSelectedRateMark;
		vcDetail.bCanReadPhoto = bCanReadPhoto;
	}
	if ([segue.identifier isEqualToString: @"PostedData"]) {
		FollowVC* vcDetail = (FollowVC*) [segue destinationViewController];
		vcDetail.strUserId = strSelectedUserId;
	}
}

- (void)refreshFollowInfo {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRFollowing observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		arrFollowingUserId = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			[arrFollowingUserId addObject:dicSnap[kUserId]];
		}
		
		if (arrFollowingUserId.count > 0) {
			[self refreshPostedData];
		} else {
			[self refreshPostedDataPerUser];
		}
	}];
}

- (void)refreshPostedDataPerUser {
	[FIRPostedRecipePerUser observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		arrFeedList = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			
			RecipeDetail* aRecipeDetail = [[RecipeDetail alloc] initWithDictionary:dicSnap];
			[arrFeedList addObject:aRecipeDetail];
		}
		
		NSArray *sortedArray = [arrFeedList sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p2.createdDateTime compare:p1.createdDateTime];
			
		}];
		
		arrFeedList = [sortedArray mutableCopy];
		appdata.arrPosted = arrFeedList;
		[self refreshAccountData];
		[self.socialFeedTblView reloadData];
	}];
}

- (void)refreshPostedData {
	[FIRPostedRecipe observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		[arrCreated removeAllObjects];
		[arrFeedList removeAllObjects];
		arrCreated = [[NSMutableArray alloc] init];
		arrFeedList = [[NSMutableArray alloc] init];
		
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;

			RecipeDetail* aRecipeDetail = [[RecipeDetail alloc] initWithDictionary:dicSnap];
			
			BOOL bExist = NO;
			if ([aRecipeDetail.userid isEqualToString:appdata.me.token])
				bExist = YES;
			else {
				BOOL bCanRead = NO;
				for (UserInfo* aUser in arrAccount) {
					if ([aUser.user_id isEqualToString:aRecipeDetail.userid]) {
						if ([aUser.readCreatedRecipeOption isEqualToString:@"Everyone"]) {
							bCanRead = YES;
							break;
						}
					}
				}
				
				if (bCanRead) {
					for (NSString* strUserId in arrFollowingUserId) {
						if ([strUserId isEqualToString:aRecipeDetail.userid]) {
							bExist = YES;
							break;
						}
					}
				}
			}
			
			if (bExist)
				[arrCreated addObject:aRecipeDetail];
		}
		
		NSArray *sortedArray = [arrCreated sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p2.createdDateTime compare:p1.createdDateTime];
			
		}];
		
		arrFeedList = [sortedArray mutableCopy];
		appdata.arrPosted = arrFeedList;
		[self refreshAccountData];
		[self.socialFeedTblView reloadData];
	}];
}

//getting the registerd account infos
- (void)refreshAccountData {
	[FIRUsers observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		[arrAccount removeAllObjects];
		arrAccount = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap snapkey:snap.key];
			[arrAccount addObject:aUser];
		}
		[self refreshRate];
		[self.socialFeedTblView reloadData];
	}];
}

- (void)refreshRate {
	[FIRRate observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrRate removeAllObjects];
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
		[self.socialFeedTblView reloadData];
	}];
}

- (void)gotoPersonalData:(id)sender {
	UIButton* button = (UIButton*)sender;
	RecipeDetail* aDetail = arrFeedList[(int)button.tag];
	strSelectedUserId = aDetail.userid;
	
	[self performSegueWithIdentifier:@"PostedData" sender:nil];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrFeedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"SocialFeedCell";
	SocialFeedCell *cell= (SocialFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
	if (cell == nil)
	{
		cell = [[SocialFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.viewController = self;

	cell.favoriteView.layer.cornerRadius = cell.favoriteView.frame.size.width / 2;
	cell.favoriteView.clipsToBounds = YES;
	
	cell.btnGotoPersonData.tag = indexPath.row;
	[cell.btnGotoPersonData addTarget:self action:@selector(gotoPersonalData:) forControlEvents:UIControlEventTouchUpInside];
	
	RecipeDetail* aDetail = arrFeedList[indexPath.row];
	cell.lblDateTime.text = aDetail.createdDateTime;
	[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:aDetail.imageName]
						  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
	cell.lblRecipeName.text = aDetail.title;
	cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
	cell.avatarImgView.clipsToBounds = YES;
	cell.lblPosterName.text = @"Recipe Ready Cook";
	
	cell.avatarImgView.image = [UIImage imageNamed:@"anonymous"];
	
	[cell.btnFavorite setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
	
	for (UserInfo* aUser in arrAccount) {
		if ([aUser.user_id isEqualToString:aDetail.userid]) {
			cell.lblPosterName.text = [NSString stringWithFormat:@"%@ created a recipe", aUser.username];
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
		if (rate.index == aDetail.index) {
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

	
	for (RecipeDetail* detail in appdata.arrFavorite) {
		if (detail.index == aDetail.index) {
			[cell.btnFavorite setImage:[UIImage imageNamed:@"heart_icon_checked"] forState:UIControlStateNormal];
			break;
		}
	}

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	RecipeDetail* aDetail = arrFeedList[indexPath.row];
	selectedRecipe = aDetail;
	
	nSelectedRateMark = 0;
	for (Rate* rate in arrRate) {
		if (rate.index == aDetail.index) {
			nSelectedRateMark = rate.mark;
			break;
		}
	}
	
	bCanReadPhoto = NO;
	for (UserInfo* aUser in arrAccount) {
		if ([aUser.user_id isEqualToString:aDetail.userid]) {
			if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId]) {
				bCanReadPhoto = YES;
			}
			break;
		}
	}
	[self performSegueWithIdentifier:@"Detail" sender:nil];
}

@end
