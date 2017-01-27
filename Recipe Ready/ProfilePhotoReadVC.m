//
//  ProfilePhotoReadVC.m
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "ProfilePhotoReadVC.h"
#import "ReadOptionCell.h"

@interface ProfilePhotoReadVC ()
{
	NSArray* arrOptions;
	int nSelectedIndex;
}
@end

@implementation ProfilePhotoReadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrOptions = @[@"Everyone", @"Friend Only", @"None"];
	nSelectedIndex = (int)[arrOptions indexOfObject:appdata.strProfilePhotoOption];
	CGRect frame = self.readOptionTblView.frame;
	frame.size.height = 50 * arrOptions.count;
	self.readOptionTblView.frame = frame;
	[self.readOptionTblView reloadData];
}

- (IBAction)backAction:(id)sender {
	[[[FIRUsers child:appdata.me.snapKey] child:kStrProfilePhotoOption] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
		currentData.value = arrOptions[nSelectedIndex];
		return [FIRTransactionResult successWithValue:currentData];
	}];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
	[[[FIRUsers child:appdata.me.snapKey] child:kStrProfilePhotoOption] runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
		currentData.value = arrOptions[nSelectedIndex];
		return [FIRTransactionResult successWithValue:currentData];
	}];
	[self.navigationController popViewControllerAnimated:YES];
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
	static NSString *simpleTableIdentifier = @"ReadOptionCell";
	ReadOptionCell *cell= (ReadOptionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil)
	{
		cell = [[ReadOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.lblReadOption.text = arrOptions[indexPath.row];
	if (indexPath.row == nSelectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else
		cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	nSelectedIndex = (int)indexPath.row;
	appdata.strProfilePhotoOption = arrOptions[indexPath.row];
	[self.readOptionTblView reloadData];
}

@end
