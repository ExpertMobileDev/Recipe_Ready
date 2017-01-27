//
//  NotificationPreferenceVC.m
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "NotificationPreferenceVC.h"
#import "SwitchSettingCell.h"

@interface NotificationPreferenceVC ()
{
	NSArray* arrOptions;
}
@end

@implementation NotificationPreferenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrOptions = @[@"new follower",@"favorite",@"share"];
	CGRect frame = self.notificationTblView.frame;
	frame.size.height = 50 * arrOptions.count;
	self.notificationTblView.frame = frame;
	[self.notificationTblView reloadData];
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitch:(id) sender {
	UISwitch* switchControl = (UISwitch*) sender;
	int nIdx = (int)switchControl.tag;
	if (nIdx == NEW_FOLLOWER) {
		if (appdata.bNewFollower) {
			appdata.bNewFollower = NO;
		} else {
			appdata.bNewFollower = YES;
		}
	}else if (nIdx == FAVORITE_SETTING) {
		if (appdata.bFavorite) {
			appdata.bFavorite = NO;
		} else {
			appdata.bFavorite = YES;
		}
	}else {
		if (appdata.bShare) {
			appdata.bShare = NO;
		} else {
			appdata.bShare = YES;
		}
	}
	[self.notificationTblView reloadData];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"SwitchSettingCell";
	SwitchSettingCell *cell= (SwitchSettingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil)
	{
		cell = [[SwitchSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.lblSettingName.text = arrOptions[indexPath.row];
	cell.settingSwitch.tag = indexPath.row;
	if (indexPath.row == NEW_FOLLOWER) {
		[cell.settingSwitch setOn:appdata.bNewFollower];
	} else if (indexPath.row == FAVORITE_SETTING) {
		[cell.settingSwitch setOn:appdata.bFavorite];
	} else {
		[cell.settingSwitch setOn:appdata.bShare];
	}
	[cell.settingSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

@end
