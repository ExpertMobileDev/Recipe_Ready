//
//  PrivacyVC.m
//  Recipe Ready
//
//  Created by mac on 12/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "PrivacyVC.h"
#import "PrivacyCell.h"

@interface PrivacyVC ()
{
	NSArray* arrOptions;
}
@end

@implementation PrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrOptions = @[@"Profile Photo", @"Created Recipe"];
	CGRect frame = self.privacyTblView.frame;
	frame.size.height = 50 * arrOptions.count;
	self.privacyTblView.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.privacyTblView reloadData];
}

- (IBAction)backAction:(id)sender {
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
	static NSString *simpleTableIdentifier = @"PrivacyCell";
	PrivacyCell *cell= (PrivacyCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil)
	{
		cell = [[PrivacyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.lblSettingName.text = arrOptions[indexPath.row];
	if (indexPath.row == PROFILEPHOTO)
		cell.lblReadOption.text = appdata.strProfilePhotoOption;
	else
		cell.lblReadOption.text = appdata.strCreateRecipeOption;
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == PROFILEPHOTO) {
		[self performSegueWithIdentifier:@"ProfilePhoto" sender:nil];
	} else {
		[self performSegueWithIdentifier:@"CreatedRecipe" sender:nil];
	}
}
@end
