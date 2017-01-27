//
//  ProfileVC.m
//  Recipe Ready
//
//  Created by mac on 11/23/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "ProfileVC.h"
#import "SettingCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
	NSArray* arrSetting;
	NSString* strAvatarImageName;
	NSString* strAvatarURL;
	NSString* strSnapKey;
	UserInfo* aUser;
}
@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrSetting = @[@"Privacy", @"Notification Preferences", @"Remove Ads", @"Contact Us", @"Log out"];
	[self.settingTblView reloadData];
	
	self.avatarImgView.layer.cornerRadius = self.avatarImgView.frame.size.width / 2;
	self.avatarImgView.clipsToBounds = YES;
	
	NSString *imageUrlString = appdata.me.avatarName;
	[self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
						  placeholderImage:[UIImage imageNamed:@"anonymous"]];
	
	self.lblUserName.text = appdata.me.username;
	self.lblFollowNum.text = [NSString stringWithFormat:@"%d", appdata.me.nFollowingNum];
	self.lblFriendNum.text = [NSString stringWithFormat:@"%d", appdata.me.nFriendNum];
	
	strSnapKey = appdata.me.snapKey;
	
	CGRect frame = self.settingTblView.frame;
	frame.size.height = 44 * arrSetting.count + self.headerView.frame.size.height + self.mainView.frame.origin.y;
	self.settingTblView.frame = frame;
	self.settingTblView.scrollEnabled = NO;
	[self.settingTblView reloadData];
}

- (IBAction)addAvatar:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Take photo", @"Choose From Library", nil];
	[actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) {
		@try
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker.delegate = self;
			
			[self presentViewController:picker animated:YES completion:^{
				
			}];
		}
		@catch (NSException *exception)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}
	} else if (buttonIndex == 1){
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		picker.delegate = self;
		
		[self presentViewController:picker animated:YES completion:^{
			
		}];
	}
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	UIImage* resizedImage = [appdata imageWithImage:chosenImage convertToSize:CGSizeMake(300, 300)];
	self.avatarImgView.image = resizedImage;
	
	strAvatarImageName = [NSString stringWithFormat:@"%@_%@.png", aUser.username, [appdata randomStringWithLength:10]];
	
	NSData* uploadData = UIImagePNGRepresentation(resizedImage);
	[self uploadAvatarToFirebase:uploadData];
}

- (void)uploadAvatarToFirebase:(NSData*) uploadData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[[FIRStorageAvatar child:strAvatarImageName] putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if (error != nil) {
			UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																					  message: @"Upload Personal's Avatar Failed"
																			   preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
			return;
		}
		
		strAvatarURL = [metadata.downloadURL absoluteString];
		[self updateUserInfo];
	}];
}

- (void) updateUserInfo {
	[[[FIRUsers child:strSnapKey] child:kUserAvatar] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
		currentData.value = strAvatarURL;
		return [FIRTransactionResult successWithValue:currentData];
	}];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrSetting.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"SettingCell";
	SettingCell *cell= (SettingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
	if (cell == nil)
	{
		cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.lblSettingName.text = arrSetting[indexPath.row];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int nId = (int)indexPath.row;
	NSError *signOutError;
	if (nId == LOGOUT) {
		BOOL status = [[FIRAuth auth] signOut:&signOutError];
		if (!status) {
			NSLog(@"Error signing out: %@", signOutError);
			return;
		} else {
			if (appdata.me.bFacebookLogin) {
				FBSDKLoginManager* manager = [[FBSDKLoginManager alloc] init];
				[manager logOut];
				[FBSDKAccessToken setCurrentAccessToken:nil];
			}
			appdata.bLoggedIn = NO;
			[appdata.homeVC.navigationController popViewControllerAnimated:YES];
		}
	} else if (nId == REMOVE_ADS) {
		[self performSegueWithIdentifier:@"RemoveAds" sender:nil];
	} else if (nId == NOTIFICATION_PREF) {
		[self performSegueWithIdentifier:@"Notification" sender:nil];
	} else if (nId == CONTACT_US) {
		[self performSegueWithIdentifier:@"ContactUs" sender:nil];
	} else if (nId == PRIVACY) {
		[self performSegueWithIdentifier:@"Privacy" sender:nil];
	}
}

@end
