//
//  LoginVC.h
//  Recipe Ready
//
//  Created by mac on 11/14/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseAuth/FIRAuth.h>

@import FirebaseAuth;
@interface LoginVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRemember;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *lblRememberMe;


- (IBAction)forgotPassword:(id)sender;
- (IBAction)rememberAction:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
