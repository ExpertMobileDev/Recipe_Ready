//
//  RemoveAdsVC.m
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "RemoveAdsVC.h"
#import "SwitchSettingCell.h"

@interface RemoveAdsVC ()

@end

@implementation RemoveAdsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	CGRect frame = self.removeAdsTblView.frame;
	frame.size.height = 50;
	self.removeAdsTblView.frame = frame;
	[self.removeAdsTblView reloadData];
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitch:(id) sender {
	if (appdata.bRemoveAds) {
		appdata.bRemoveAds = NO;
	} else {
		appdata.bRemoveAds = YES;
	}
	[self.removeAdsTblView reloadData];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
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
	cell.lblSettingName.text = @"Remove Ads";
	[cell.settingSwitch setOn:appdata.bRemoveAds];
	[cell.settingSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

@end
