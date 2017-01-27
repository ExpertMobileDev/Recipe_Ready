//
//  LoginVC.m
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "LoginVC.h"
#import "MBProgressHUD.h"



@interface LoginVC ()<FBSDKLoginButtonDelegate>
{
	FIRAuthCredential *credential;
	NSMutableArray* arrUserInfos;
}

@end


@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.btnLogin.layer.cornerRadius = 5;
	self.btnLogin.clipsToBounds = YES;
	
	self.btnFBLogin.layer.cornerRadius = 5;
	self.btnFBLogin.clipsToBounds = YES;
	self.btnFBLogin.hidden = YES;
	
	UIColor *color = [UIColor lightTextColor];
	self.emailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username or Email" attributes:@{NSForegroundColorAttributeName: color}];
	self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
	
	[self.emailTF setTintColor:[UIColor whiteColor]];
	[self.passwordTF setTintColor:[UIColor whiteColor]];

	UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberUser)];
	[tap setNumberOfTapsRequired:1];
	[self.lblRememberMe addGestureRecognizer:tap];

	FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
	loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];

	loginButton.delegate = self;
	
	// Optional: Place the button in the center of your view.
	CGRect rect = CGRectMake(self.btnLogin.frame.origin.x, self.btnFBLogin.frame.origin.y, self.btnLogin.frame.size.width, self.btnLogin.frame.size.height);
	loginButton.frame = rect;
	[self.view addSubview:loginButton];
	
	if (appdata.bLoggedIn) {
		[self performSegueWithIdentifier:@"Home" sender:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	self.mainView.scrollEnabled = NO;
	[self refreshUserInfo];

	if (appdata.bFaceBookClick) {
		[self.mainView setContentOffset:CGPointMake(0, 0)];
		appdata.bFaceBookClick = NO;
	}
	else {
		[self.mainView setContentOffset:CGPointMake(0, 20)];
	}
	
	if (appdata.bRemember) {
		User * me = appdata.me;
		[me load];
		self.emailTF.text = me.email;
		self.passwordTF.text = me.password;
		[self.btnRemember setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
	} else {
		self.emailTF.text = @"";
		self.passwordTF.text = @"";
		[self.btnRemember setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide {
	self.mainView.scrollEnabled = NO;
	[self.mainView setContentOffset:CGPointMake(0, 20)];
}

- (IBAction)forgotPassword:(id)sender {
	UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Forgot Password"
																			  message: @"Enter email address."
																	   preferredStyle:UIAlertControllerStyleAlert];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Email";
		textField.keyboardType = UIKeyboardTypeEmailAddress;
		textField.textColor = [UIColor blackColor];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.borderStyle = UITextBorderStyleNone;
	}];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSArray * textfields = alertController.textFields;
		UITextField * emailField = textfields[0];
		
		NSLog(@"%@",emailField.text);
		
		self.mainView.scrollEnabled = NO;
		[self.mainView setContentOffset:CGPointMake(0, 0)];
		
		if ([AppData isNullOrEmptyString:emailField.text]) {
			[emailField resignFirstResponder];
			return;
		}
		
		if (![AppData validateEmail:emailField.text]) {
			[emailField resignFirstResponder];
			[appdata showAlertTips:@"Enter Email Address"];
			return;
		}
		
		[self sendEmailForPassword: emailField.text];
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) sendEmailForPassword:(NSString*) strEmail {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[[FIRAuth auth] sendPasswordResetWithEmail:strEmail completion:^(NSError * _Nullable error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if (!error) {
			[appdata showAlertTips:@"Password reset email sent successfully"];
		} else {
			[appdata showAlertTips:error.localizedFailureReason];
		}
	}];
}

- (IBAction)rememberAction:(id)sender {
	[self rememberUser];
}

- (void)rememberUser {
	if (appdata.bRemember) {
		[self.btnRemember setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
		appdata.bRemember = NO;
	} else {
		[self.btnRemember setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
		appdata.bRemember = YES;
	}
}

- (void)loginWithEmail:(NSString*) strEmail password:(NSString*) strPassword {
	if ([AppData isNullOrEmptyString:strEmail] || [AppData isNullOrEmptyString:strPassword])
		return;
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];	
	[[FIRAuth auth] signInWithEmail:strEmail
						   password:strPassword
						 completion:^(FIRUser *user, NSError *error) {
							 [MBProgressHUD hideHUDForView:self.view animated:YES];
							 if (!error) {
								 NSLog(@"%@", user.uid);
								 appdata.bLoggedIn = YES;
								 appdata.strUserId = user.uid;

								 UserInfo* userInfo;
								 BOOL bExist = NO;
								 for (UserInfo* aUser in arrUserInfos) {
									 if ([aUser.email isEqualToString:strEmail]) {
										 userInfo = aUser;
										 bExist = YES;
										 break;
									 }
								 }
								 
								 if (bExist) {
									 User * me = appdata.me;
									 me.email = strEmail;
									 me.password = strPassword;
									 me.username = userInfo.username;
									 me.token = user.uid;
									 me.bFacebookLogin = NO;
									 me.snapKey = userInfo.snapkey;
									 me.nFollowNum = userInfo.nFollowNum;
									 me.nFollowingNum = userInfo.nFollowingNum;
									 me.nFriendNum = userInfo.nFriendNum;
									 me.avatarName = userInfo.avatarName;
									 me.readPhotoOption = userInfo.readPhotoOption;
									 me.readCreatedRecipeOption = userInfo.readCreatedRecipeOption;
									 appdata.strProfilePhotoOption = userInfo.readPhotoOption;
									 appdata.strCreateRecipeOption = userInfo.readCreatedRecipeOption;
									 [me save];
									 [self gotoHomeScreen];
								 }								 
							 } else {
								 appdata.bLoggedIn = NO;
								 [appdata showAlertTips:@"Login Failed"];
							 }
						 }];
}

- (IBAction)loginAction:(id)sender {
	[self loginWithEmail:self.emailTF.text password:self.passwordTF.text];
}

- (IBAction)createAccount:(id)sender {
	[self gotoSignUp];
}

- (void)gotoSignUp {
	[self performSegueWithIdentifier:@"Signup" sender:nil];
}

- (void) gotoHomeScreen
{
	[self performSegueWithIdentifier:@"Home" sender:nil];
}

- (void)refreshUserInfo {
	[FIRUsers observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		[arrUserInfos removeAllObjects];
		arrUserInfos = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			UserInfo* aUser = [[UserInfo alloc] initWithDictionary:dicSnap snapkey:snap.key];
			[arrUserInfos addObject:aUser];
		}
	}];
}

#pragma mark- FBLoginButton Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
			  error:(NSError *)error {
	if (error == nil) {
		// ...
		credential = [FIRFacebookAuthProvider
										 credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
										 .tokenString];
		if (![FBSDKAccessToken currentAccessToken])
			return;
		
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		[[FIRAuth auth] signInWithCredential:credential
								  completion:^(FIRUser *user, NSError *error) {
									  // ...
									  [MBProgressHUD hideHUDForView:self.view animated:YES];
									  if (!error) {
										  appdata.bLoggedIn = YES;
										  
										  appdata.strUserId = user.uid;
										  
										  NSString* strEmail = @"";
										  if ([AppData isNullOrEmptyString:user.email])
											  strEmail = user.providerID;
										  else
											  strEmail = user.email;
										  
										  UserInfo* userInfo;
										  BOOL bExist = NO;
										  for (UserInfo* aUser in arrUserInfos) {
											  if ([aUser.email isEqualToString:strEmail]) {
												  userInfo = aUser;
												  bExist = YES;
												  break;
											  }
										  }

										  User * me = appdata.me;
										  
										  if (!bExist) {
											  UserInfo* account = [[UserInfo alloc] init];
											  account.email = strEmail;
											  account.password = user.providerID;
											  account.username = user.displayName;
											  account.user_id = user.uid;
											  account.nFollowingNum = 0;
											  account.nFollowNum = 0;
											  account.nFriendNum = 0;
											  account.bFacebookLogin = YES;
											  account.readPhotoOption = @"Everyone";
											  account.readCreatedRecipeOption = @"Everyone";
											  account.avatarName = [user.photoURL absoluteString];
											  [appdata addUserInfoToPersonalData:account];
											  account.snapkey = [appdata addUserInfoToUserList:account];
											  
											  me.email = strEmail;
											  me.username = user.displayName;
											  me.password = user.providerID;
											  me.token = user.uid;
											  me.bFacebookLogin = YES;
											  me.nFollowingNum = account.nFollowingNum;
											  me.nFollowNum = account.nFollowNum;
											  me.nFriendNum = account.nFriendNum;
											  me.avatarName = account.avatarName;
											  me.readPhotoOption = @"Everyone";
											  me.readCreatedRecipeOption = @"Everyone";
											  me.snapKey = account.snapkey;
											  
											  appdata.strProfilePhotoOption = @"Everyone";
											  appdata.strCreateRecipeOption = @"Everyone";

										  } else {
											  me.email = strEmail;
											  me.username = user.displayName;
											  me.password = user.providerID;
											  me.token = user.uid;
											  me.bFacebookLogin = YES;
											  me.snapKey = userInfo.snapkey;
											  me.nFollowingNum = userInfo.nFollowingNum;
											  me.nFollowNum = userInfo.nFollowNum;
											  me.nFriendNum = userInfo.nFriendNum;
											  me.avatarName = userInfo.avatarName;
											  me.readPhotoOption = @"Everyone";
											  me.readCreatedRecipeOption = @"Everyone";
											  me.snapKey = userInfo.snapkey;
											  appdata.strProfilePhotoOption = userInfo.readPhotoOption;
											  appdata.strCreateRecipeOption = userInfo.readCreatedRecipeOption;
										  }
										  
										  appdata.strCreateRecipeOption = me.readCreatedRecipeOption;
										  appdata.strProfilePhotoOption = me.readPhotoOption;
										  [me save];
										  [self gotoHomeScreen];
									  } else {
										  appdata.bLoggedIn = NO;
										  [appdata showAlertTips:error.description];
									  }
								  }];
	} else {
		[appdata showAlertTips:error.localizedDescription];
	}
}

- (void)resetDefaults {
	NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
	NSDictionary * dict = [defs dictionaryRepresentation];
	for (id key in dict) {
		[defs removeObjectForKey:key];
	}
	[defs synchronize];
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
	
}

#pragma mark- textField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.emailTF resignFirstResponder];
	[self.passwordTF resignFirstResponder];
	
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (textField == self.passwordTF) {
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
