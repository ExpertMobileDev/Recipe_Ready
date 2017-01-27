//
//  FollowVC.m
//  Recipe Ready
//
//  Created by mac on 12/19/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "FollowVC.h"
#import "MBProgressHUD.h"
#import "SearchResultCollectCell.h"
#import "FollowDetailVC.h"

@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface FollowVC ()<NSURLSessionDelegate>
{
	NSMutableArray* arrPostData;
	NSMutableArray* arrUserInfo;
	NSMutableArray* arrFollowingUserId;
	UserInfo* selectedUser;
	int nSelectedRateMark;
	RecipeDetail* selectedRecipe;
	NSString* strUserSnapKey;
	NSString* strFollowingSnapKey;
	BOOL bFollowed;
}

@end


@implementation FollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.avatarImgView.layer.cornerRadius = self.avatarImgView.frame.size.width / 2;
	self.avatarImgView.clipsToBounds = YES;
	self.avatarImgView.image = [UIImage imageNamed:@"anonymous"];
	
	if ([self.strUserId isEqualToString:appdata.me.token]) {
		self.btnFollow.enabled = NO;
	}
	
	[self refreshPostedData];
	[self refreshFollowInfo];
	[self refreshUserInfo];
}

- (IBAction)followAction:(id)sender {
	if (bFollowed) {
		[self.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
		[self.btnFollow setTitleColor:WhiteColor forState:UIControlStateNormal];
		[self.btnFollow setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];


		[[FIRFollowing child:strFollowingSnapKey] removeValue];
		[[[FIRUsers child:strUserSnapKey] child:kFollowingNum] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			int nFollow = [currentData.value intValue];
			currentData.value = [NSNumber numberWithInt:nFollow - 1];
			return [FIRTransactionResult successWithValue:currentData];
		}];
		bFollowed = NO;
	}
	else {
		[self.btnFollow setTitleColor:SelectedColor forState:UIControlStateNormal];
		[self.btnFollow setBackgroundImage:[UIImage imageNamed:@"round_rect"] forState:UIControlStateNormal];
		[self.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
		
		strFollowingSnapKey = [appdata addUserInfoToFollowingList:selectedUser.user_id];
		[[[FIRUsers child:strUserSnapKey] child:kFollowingNum] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
			int nFollow = [currentData.value intValue];
			currentData.value = [NSNumber numberWithInt:nFollow + 1];
			return [FIRTransactionResult successWithValue:currentData];
		}];
		bFollowed = YES;
		//[self follow];
	}
}

- (void) follow {
	NSString *refreshedToken = [[FIRInstanceID instanceID] token];
	if (!refreshedToken) {
		return;
	}
	
	NSURL* url = [NSURL URLWithString:kNotificationURL];
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setValue:kServerKey forHTTPHeaderField:@"Authorization"];
	[request setValue:refreshedToken forHTTPHeaderField:@"Authentification"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	request.HTTPMethod = @"POST";
	NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSDictionary* dicJson = @{@"to":refreshedToken,
							  @"priority":@"high",
							  @"content_available":@YES,
							  @"notification":@{@"body":@"Robert Follow you",@"title":@"Robert test Firebase sdk"}};
	
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:NSJSONWritingPrettyPrinted error:nil];

	request.HTTPBody = jsonData;
	NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate: self delegateQueue: [NSOperationQueue mainQueue]];
	
	NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		NSString* strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", strData);
		if (error != nil) {
			NSLog(@"%@", error);
		}
	}];
	
	[dataTask resume];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString: @"Detail"]) {
		FollowDetailVC* vcDetail = (FollowDetailVC*) [segue destinationViewController];
		vcDetail.nStarMark = nSelectedRateMark;
		vcDetail.selectedRecipe = selectedRecipe;
		vcDetail.user = selectedUser;
	}
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

//getting the registerd follow infos
- (void)refreshFollowInfo {
	bFollowed = NO;
	[FIRFollowing observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		arrFollowingUserId = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			[arrFollowingUserId addObject:dicSnap[kUserId]];
			if ([dicSnap[kUserId] isEqualToString:selectedUser.user_id]) {
				strFollowingSnapKey = snap.key;
				[self.btnFollow setTitleColor:SelectedColor forState:UIControlStateNormal];
				[self.btnFollow setBackgroundImage:[UIImage imageNamed:@"round_rect"] forState:UIControlStateNormal];
				[self.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
				bFollowed = YES;
			}
		}
		
		if (!bFollowed) {
			[self.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
			[self.btnFollow setTitleColor:WhiteColor forState:UIControlStateNormal];
			[self.btnFollow setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
		}
	}];
}


//getting the registerd account infos
- (void)refreshUserInfo {
	[FIRUsers observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		arrUserInfo = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap];
			[arrUserInfo addObject:aUser];
			if ([aUser.user_id isEqualToString:self.strUserId]) {
				selectedUser = aUser;
				self.lblUserName.text = selectedUser.username;
				self.lblPostUserName.text = selectedUser.username;
				self.lblFollowNum.text = [NSString stringWithFormat:@"%d", aUser.nFollowingNum];
				if ([aUser.readPhotoOption isEqualToString:@"Everyone"] || [aUser.user_id isEqualToString:appdata.strUserId])
					[self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:aUser.avatarName]
									  placeholderImage:[UIImage imageNamed:@"anonymous"]];
			}
			
			if ([appdata.me.token isEqualToString:aUser.user_id])
				strUserSnapKey = snap.key;
		}
	}];
}

- (void)refreshPostedData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	FIRDatabaseReference* ref = [[[FIRRef child:kPersonalData] child:self.strUserId] child:kPostedRecipe];
	[ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[arrPostData removeAllObjects];
		arrPostData = [[NSMutableArray alloc] init];
		
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			NSLog(@"%@", dicSnap[kUserId]);
			NSLog(@"%@", appdata.me.token);
			
			RecipeDetail* aRecipeDetail = [[RecipeDetail alloc] initWithDictionary:dicSnap];
			[arrPostData addObject:aRecipeDetail];
		}
		
		NSArray *sortedArray = [arrPostData sortedArrayUsingComparator:^NSComparisonResult(RecipeDetail *p1, RecipeDetail *p2){
			
			return [p2.createdDateTime compare:p1.createdDateTime];			
		}];
		
		arrPostData = [sortedArray mutableCopy];
		self.lblRecipeNum.text = [NSString stringWithFormat:@"%d", arrPostData.count];
		[self.recipeCollectView reloadData];
	}];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
	return arrPostData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	SearchResultCollectCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SearchResultCollectCell" forIndexPath:indexPath];
	RecipeDetail* aRecipe = arrPostData[indexPath.row];
	
	if (cell && aRecipe) {
		//
		cell.recipeImgView.image = [UIImage imageNamed:@"no_recipe"];
		cell.lblRecipeName.text = aRecipe.title;
		cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
		cell.avatarImgView.clipsToBounds = YES;
		cell.lblUsername.text = @"Recipe Ready Cook";
		
		[cell.recipeImgView sd_setImageWithURL:[NSURL URLWithString:aRecipe.imageName]
							  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		
		BOOL bExistRate = NO;
		for (Rate* rate in appdata.arrRate) {
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
		
		for (UserInfo* aUser in arrUserInfo) {
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
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	RecipeDetail* aRecipeDetail = arrPostData[indexPath.row];
	nSelectedRateMark = 0;
	for (Rate* rate in appdata.arrRate) {
		if (rate.index == aRecipeDetail.index) {
			nSelectedRateMark = rate.mark;
			break;
		}
	}
	
	selectedRecipe = aRecipeDetail;
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
