//
//  SIgnupVC.m
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SIgnupVC.h"
#import "MBProgressHUD.h"

@import FirebaseAuth;
@interface SIgnupVC ()

@end

@implementation SIgnupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.mainView.scrollEnabled = NO;
	[self.mainView setContentOffset:CGPointMake(0, 20)];
	
	self.btnSignup.layer.cornerRadius = 5;
	self.btnSignup.clipsToBounds = YES;
	
	self.lblCheckFB.text = [NSString stringWithFormat:@"%@\n%@", @"Don't have Facebook?", @"Create one..."];
	
	UIColor *color = [UIColor lightTextColor];
	self.usernameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
	self.emailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
	self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
	self.confirmTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];

	
	[self.emailTF setTintColor:[UIColor whiteColor]];
	[self.passwordTF setTintColor:[UIColor whiteColor]];
	[self.usernameTF setTintColor:[UIColor whiteColor]];
	[self.confirmTF setTintColor:[UIColor whiteColor]];

}


- (IBAction)signupAction:(id)sender {
	[self.usernameTF resignFirstResponder];
	[self.passwordTF resignFirstResponder];
	[self.confirmTF resignFirstResponder];
	[self.emailTF resignFirstResponder];

	self.mainView.scrollEnabled = NO;
	[self.mainView setContentOffset:CGPointMake(0, 0)];

	if (self.usernameTF.text.length == 0 || self.passwordTF.text.length == 0 ) {
		[appdata showAlertTips:@"Please input the valid data!"];
		return;
	}
	
	if (![AppData validateEmail:self.emailTF.text] ) {
		return;
	}
	
	NSString* strPass = self.passwordTF.text;
	NSString* strConfirm = self.confirmTF.text;
	
	if (![strPass isEqualToString:strConfirm]) {
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[[FIRAuth auth] createUserWithEmail:self.emailTF.text password:self.passwordTF.text completion:^(FIRUser *user, NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if (!error) {
			
			appdata.strUserId = user.uid;
			
			UserInfo* account = [[UserInfo alloc] init];
			account.email = self.emailTF.text;
			account.password = self.passwordTF.text;
			account.username = self.usernameTF.text;
			account.user_id = user.uid;
			account.nFollowingNum = 0;
			account.nFollowNum = 0;
			account.nFriendNum = 0;
			account.avatarName = @"";
			account.bFacebookLogin = NO;
			account.readPhotoOption = @"Everyone";
			account.readCreatedRecipeOption = @"Everyone";
			[appdata addUserInfoToPersonalData:account];
			NSString* strSnapKey = [appdata addUserInfoToUserList:account];
			
			User * me = appdata.me;
			me.email = self.emailTF.text;
			me.password = self.passwordTF.text;
			me.username = self.usernameTF.text;
			me.token = user.uid;
			me.bFacebookLogin = NO;
			me.snapKey = strSnapKey;
			[me save];
			
			[appdata showAlertWithTitle:@"Success" message:@"Registered A New Account!"];
			[self.navigationController popViewControllerAnimated:YES];
			
		} else {
			[appdata showAlertTips:error.localizedFailureReason];
		}
	}];
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-textField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.usernameTF resignFirstResponder];
	[self.passwordTF resignFirstResponder];
	[self.emailTF resignFirstResponder];
	[self.confirmTF resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (textField == self.passwordTF || textField == self.confirmTF) {
		NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
		BOOL isPressedBackspaceAfterSingleSpaceSymbol = [string isEqualToString:@""] && [resultString isEqualToString:@""] && range.location == 0 && range.length == 1;
		if (isPressedBackspaceAfterSingleSpaceSymbol) {
			//  your actions for deleteBackward actions
			textField.text = @"";
		}
	}
	return YES;
}

@end
