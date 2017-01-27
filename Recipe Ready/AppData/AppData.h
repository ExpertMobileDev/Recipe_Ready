//
//  AppData.h
//  Dopple
//
//  Created by mac on 25/06/2016.
//  Copyright (c) 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface AppData : NSObject


+ (AppData*) sharedData;
+ (BOOL) isNullOrEmptyString:(NSString *)inString;
+ (BOOL)validateEmail:(NSString *)emailStr;

// Properties
@property (nonatomic, strong) User *me;
@property (nonatomic) BOOL bRemember;
@property (nonatomic) BOOL bLoggedIn;
@property (nonatomic) BOOL bFaceBookClick;
@property (nonatomic) BOOL bRemoveAds;

//Notification Setting Options
@property (nonatomic) BOOL bNewFollower;
@property (nonatomic) BOOL bShare;
@property (nonatomic) BOOL bFavorite;

@property (nonatomic, strong) NSMutableArray *arrFavorite;
@property (nonatomic, strong) NSMutableArray *arrBasket;
@property (nonatomic, strong) NSMutableArray *arrRate;
@property (nonatomic, strong) NSMutableArray *arrCreated;
@property (nonatomic, strong) NSMutableArray *arrPosted;
@property (nonatomic, strong) NSMutableArray *arrSelectedIngredients;

@property (nonatomic, assign) int nCreateMode;
@property (nonatomic, assign) int nMyRecipeShowMode;
@property (nonatomic, assign) int nSelectRecipeIndex;

@property (nonatomic, strong) NSString *strSelectedImgName;
@property (nonatomic, strong) NSString *strProfilePhotoOption;
@property (nonatomic, strong) NSString *strCreateRecipeOption;
@property (nonatomic, strong) NSString *strUserId;

@property (nonatomic, strong) UIViewController *homeVC;

- (void)showAlertAndReturn:(NSString *)_message andController:(UIViewController*) controller;
- (void)showAlertTips:(NSString *)_message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)_message;

- (NSString *) getCurrentTime;
- (NSString *) getCurrentEstTime;
- (NSString *) getCurrentTimeStamp;
- (NSString *) getUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime;

-(NSString *) randomStringWithLength: (int) len;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

- (NSString*)addIngredientToFirebase:(Ingredient*) aIngredient;
- (NSString*)addRecipeToFavorite:(RecipeDetail*) aRecipe;
- (NSString*)addCreatedRecipeToFirebase:(RecipeDetail*) aRecipe;
- (NSString*)addUserInfoToPersonalData:(UserInfo*) aUser;
- (NSString*)addPostedRecipeToPersonalData:(RecipeDetail*) aRecipe;
- (NSString*)addUserInfoToUserList:(UserInfo*) aUser;
- (NSString*)addPostedRecipeToGlobal:(RecipeDetail*) aRecipe;
- (NSString*)addUserInfoToFollowingList:(NSString*) userId;
@end
