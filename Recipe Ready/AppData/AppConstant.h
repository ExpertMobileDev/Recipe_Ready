//
//  AppConstant.h
//  Dopple
//
//  Created by mac on 25/06/2016.
//  Copyright (c) 2016 mac. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

#pragma mark - Notifications


// Domain Name

#define kDomainUrl					@"https://spoonacular-recipe-food-nutrition-v1.p.mashape.com"
#define kImageIngredientPath		@"https://spoonacular.com/cdn/ingredients_100x100/"
#define kImageRecipePath			@"https://spoonacular.com/recipeImages/"

//API_Key
#define X_Mashape_Key				@"2tlfZt7bQomshymAMkIvQWqP9DCPp1u8dpwjsn8Lts1It5HNC0"

//EndPoints
#define kEndpointRecipeSearch(number, query)	[NSString stringWithFormat:@"/recipes/autocomplete?number=%d&query=%@", number, query]
#define kEndpointRecipeDetail(id)				[NSString stringWithFormat:@"/recipes/%d/information", id]
#define kEndpointSearchByIngredients(bFill, ingredients, limitLicense, number, ranking)				[NSString stringWithFormat:@"/recipes/findByIngredients?fillIngredients=%@&ingredients=%@&limitLicense=%@&number=%d&ranking=%d", bFill, ingredients, limitLicense, number, ranking]

#define kEndpointIngredientSearch(number, query)   [NSString stringWithFormat:@"/food/ingredients/autocomplete?metaInformation=false&number=%d&query=%@", number, query]


// App Relative Key
#define kFirebaseURL        @"https://recipe-ready-204aa.firebaseio.com"

// UserInfo Key
#define kUserInfo           @"recipeready.userinfo"

// Parameters for Request
#define kSuccess            @"success"
#define kError              @"error"
#define kErrorMsg           @"error_msg"
#define kToken              @"token"
#define kLoginToken         @"login_token"
#define kResults            @"results"
#define kFavorite           @"favorites"
#define kBasket				@"basket"
#define kCreated			@"created"
#define kPosted				@"posted"
#define kSelectedIngredients	@"selectedingredient"
#define kCurrentUserId		@"current_user_id"

#define kRecipeId			@"id"
#define kRecipeTitle		@"title"
#define kRecipeImgName		@"image"
#define kRecipeInstruction  @"instructions"
#define kRecipeIngredient	@"extendedIngredients"
#define kUserId				@"user_id"
#define kRecipeDateTime		@"createddatetime"
#define kSnapKey			@"snapkey"

#define kIngredientId		@"id"
#define kIngredientName		@"name"
#define kIngredientImgName	@"image"
#define kIngredientOriginal	@"originalString"
#define kIngredientAmount   @"amount"
#define kIngredientUnit		@"unit"

// Parameters for Response
#define kMember             @"member"
#define kMemberId           @"member_id"
#define kUser               @"user"
#define kPass               @"pass"
#define kCred               @"cred"
#define kEmail              @"email"
#define kToken              @"token"
#define kLogin              @"login"
#define kUserName           @"user_name"
#define kUserAvatar			@"avatar"
#define kFollowNum			@"follownum"
#define kFollowingNum		@"followingnum"
#define kFriendNum			@"friendnum"
#define kBFacebookLogin		@"facebooklogin"

#define kAvatarStorage		@"Avatars"

#define kBRemoveAds  		@"removeAds"
#define kBFavorite			@"notification_favorite"
#define kBFollower			@"notification_follower"
#define kBShare				@"notification_share"

#define kStrProfilePhotoOption  		@"profilephotooption"
#define kStrCreatedRecipeOption  		@"createdrecipeoption"

// Constants
#define kBRemember  		@"remember"
#define kBLoggedIn          @"login"
#define kNCreateMode        @"createmode"
#define kNMyRecipeShowMode  @"myrecipeshowmode"
#define kNSelectedIndex     @"selectedindex"
#define kStrImageName  		@"imagename"

//Firebase key
#define kFavoriteRecipe		@"Favorite"
#define kIngredient			@"Ingredients"
#define kCreatedRecipe		@"Created_Recipe"
#define kPostedRecipe		@"Posted_Recipe"
#define kPersonalData		@"Personal_Data"
#define kUserData			@"User_list"
#define kFollowingUser		@"following_user"

#define kLowerBound			10000000

//Rate
#define kRateMemberCount	@"count"
#define kRateMark			@"mark"
#define kRate				@"rate"
#define kRateKey			@"snapKey"

#define kNotificationURL    @"https://fcm.googleapis.com/fcm/send"
#define kServerKey			@"key=AIzaSyDgat4hMVqpewmkxKoZYVNBXOxDhsqOku8"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define SelectedColor			RGB(61, 138, 182)
#define UnSelectedWordColor		RGB(147, 150, 152)
#define WhiteColor				RGB(255, 255, 255)


typedef enum {
	SHOP = 0,
	TRUCKNUM,
	TRAILERNUM,
	MECHANIC
}SELECTITEM;

typedef enum {
	LANIP = 0,
	WANIP
}IPMODE;

typedef enum {
	PHOTO = 0,
	VIDEO,
	AUDIO
}UPLOAD_TYPE;

typedef enum {
	CREATED = 0,
	FAVORITE
}RECIPE_SHOW;

typedef enum {
	RECENT_RECIPES = 0,
	SETTINGS,
	RECENT_INGREDIENTS
}PROFILE_OPTION;

typedef enum {
	BYNAME = 0,
	BYINGREDIENT
}SEARCH_METHOD;

typedef enum {
	NONE_MODE = 0,
	BYSEARCH,
	BYBARCODE
}ADD_METHOD;

typedef enum {
	GENERATE_MODE = 2,
	TAKE_MODE = 3
}CREATE_MODE;

typedef enum {
	PRIVACY = 0,
	NOTIFICATION_PREF,
	REMOVE_ADS,
	CONTACT_US,
	LOGOUT
}PROFILE_SETTINGS;

typedef enum {
	NEW_FOLLOWER = 0,
	FAVORITE_SETTING,
	SHARE
}NOTIFICATION_SETTING;

typedef enum {
	PROFILEPHOTO = 0,
	CREATEDRECIPE
}PRIVACY_OPTION;
#endif
