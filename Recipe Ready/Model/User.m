//
//  User.m
//  Wnyhsports
//
//  Created by Mac on 10/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "User.h"
#import "AFAppDotNetAPIClient.h"
#import "Recipe.h"
#import "RecipeSearchResult.h"
#import "Ingredient.h"
#import "IngredientInfo.h"

@import Firebase;
@implementation User

- (id) init
{
    if ([super init]) {
        _email = @"";
        _username = @"";
        _password = @"";
		_token = @"";
		_bFacebookLogin = NO;
		_snapKey = @"";
		_avatarName = @"";
		_nFollowNum = 0;
		_nFollowingNum = 0;
		_nFriendNum = 0;
		_readCreatedRecipeOption = @"Everyone";
		_readPhotoOption = @"Everyone";
		
    }
    return self;
}

- (void) save
{
    NSDictionary *userInfo = @{
                               kUser: _username,
                               kPass: _password,
                               kEmail: _email,
							   kToken: _token,
							   kSnapKey: _snapKey,
							   kBFacebookLogin: [NSNumber numberWithBool:_bFacebookLogin],
							   kUserAvatar: _avatarName,
							   kFollowNum: [NSNumber numberWithInt:_nFollowNum],
							   kFollowingNum: [NSNumber numberWithInt:_nFollowingNum],
							   kFriendNum: [NSNumber numberWithInt:_nFriendNum],
							   kStrProfilePhotoOption: _readPhotoOption,
							   kStrCreatedRecipeOption: _readCreatedRecipeOption
                               };
    [UD setObject:userInfo forKey:kUserInfo];
    [UD synchronize];
}

- (void) load
{
    NSDictionary *userInfo = [UD objectForKey:kUserInfo];
    if (userInfo) {
        _username = [userInfo valueForKey:kUser];
        _password = [userInfo valueForKey:kPass];
		_email = [userInfo valueForKey:kEmail];
		_token = [userInfo valueForKey:kToken];
		_snapKey = [userInfo valueForKey:kSnapKey];
		_avatarName = [userInfo valueForKey:kUserAvatar];
		_nFollowNum = [[userInfo valueForKey:kFollowNum] intValue];
		_nFollowingNum = [[userInfo valueForKey:kFollowingNum] intValue];
		_nFriendNum = [[userInfo valueForKey:kFriendNum] intValue];
		_readPhotoOption = [userInfo valueForKey:kStrProfilePhotoOption];
		_readCreatedRecipeOption = [userInfo valueForKey:kStrCreatedRecipeOption];
		_bFacebookLogin = [[userInfo valueForKey:kBFacebookLogin] boolValue];
		
        if (!_username) _username = @"";
        if (!_password) _password = @"";
		if (!_email) _email = @"";
		if (!_token) _token = @"";
		if (!_snapKey) _snapKey = @"";
    }
}

- (void) clear
{
    _username = @"";
    _password = @"";
	_token = @"";
	_email = @"";
	_bFacebookLogin = NO;
	_snapKey = @"";
}

- (void) logout
{
    [self clear];
//    [appdata.homeVC.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Search Recipe
- (void) searchRecipe:(int)nCount query:(NSString*) strQuery handler:(void (^)(NSArray *, NSString *))handler
{
	NSString *endpoint = kEndpointRecipeSearch(nCount, strQuery);
	NSLog(@"%@", endpoint);
	NSDictionary *params = @{};
	
	[[AFAppDotNetAPIClient sharedClient]
	 GET:endpoint
	 parameters:params
	 success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nullable responseObject) {
		 
		 if (responseObject) {
			 
			 NSLog(@"recipe response: %@", responseObject);
			 NSArray *recipes = responseObject;
			 if (recipes) {
				 NSMutableArray *arrRecipe = [[NSMutableArray alloc] init];
				 for (int i = 0; i < recipes.count; i++) {
					 Recipe *aRecipe = [[Recipe alloc] initWithData:[recipes objectAtIndex:i]];
					 [arrRecipe addObject:aRecipe];
				 }
				 
				 handler(arrRecipe, nil);
				 return;
			 }
			 
			 handler(responseObject, nil);
			 return;

		 }
		 else if (responseObject && ![AppData isNullOrEmptyString:[responseObject valueForKey:kError]]) {
			 handler(nil, [[responseObject valueForKey:kError] stringValue]);
			 return;
		 }
		 handler(nil, @"wrong request");
	 }
	 failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
		 if (error) {
			 NSLog(@"search details: %@", [error localizedDescription]);
			 handler(nil, [error localizedDescription]);
		 } else
			 handler(nil, @"Unknown");
	 }];
}

- (void) getRecipeDetail:(int)nIndex handler:(void (^)(NSDictionary *, NSString *))handler
{
	NSString *endpoint = kEndpointRecipeDetail(nIndex);
	NSLog(@"%@", endpoint);
	NSDictionary *params = @{};
	
	[[AFAppDotNetAPIClient sharedClient]
	 GET:endpoint
	 parameters:params
	 success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nullable responseObject) {
		 
		 if (responseObject) {
			 
			 NSLog(@"recipe response: %@", responseObject);
			 handler(responseObject, nil);
			 return;
			 
		 }
		 else if (responseObject && ![AppData isNullOrEmptyString:[responseObject valueForKey:kError]]) {
			 handler(nil, [[responseObject valueForKey:kError] stringValue]);
			 return;
		 }
		 handler(nil, @"wrong request");
	 }
	 failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
		 if (error) {
			 NSLog(@"search details: %@", [error localizedDescription]);
			 handler(nil, [error localizedDescription]);
		 } else
			 handler(nil, @"Unknown");
	 }];
}

- (void) searchRecipeByIngredients:(NSString*) strIngredients handler:(void (^)(NSArray *, NSString *))handler
{
	NSString* strUrl = [strIngredients stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *endpoint = kEndpointSearchByIngredients(@"false", strUrl, @"false", 5, 1);
	NSLog(@"%@", endpoint);
	NSDictionary *params = @{};
	
	[[AFAppDotNetAPIClient sharedClient]
	 GET:endpoint
	 parameters:params
	 success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nullable responseObject) {
		 
		 if (responseObject) {
			 
			 NSLog(@"recipe response: %@", responseObject);
			 NSArray *recipes = responseObject;
			 if (recipes) {
				 NSMutableArray *arrRecipe = [[NSMutableArray alloc] init];
				 for (int i = 0; i < recipes.count; i++) {
					 RecipeSearchResult *aRecipe = [[RecipeSearchResult alloc] initWithData:[recipes objectAtIndex:i]];
					 RecipeDetail* aDetail = [[RecipeDetail alloc] init];
					 aDetail.index = aRecipe.index;
					 aDetail.title = aRecipe.name;
					 aDetail.imageName = aRecipe.imageName;
					 aDetail.arrIngredients = [[NSMutableArray alloc] init];
					 aDetail.instructions = @"";
					 aDetail.snapkey = @"";
					 
					 [arrRecipe addObject:aDetail];
				 }
				 
				 handler(arrRecipe, nil);
				 return;
			 }
			 
			 handler(responseObject, nil);
			 return;
			 
		 }
		 else if (responseObject && ![AppData isNullOrEmptyString:[responseObject valueForKey:kError]]) {
			 handler(nil, [[responseObject valueForKey:kError] stringValue]);
			 return;
		 }
		 handler(nil, @"wrong request");
	 }
	 failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
		 if (error) {
			 NSLog(@"search details: %@", [error localizedDescription]);
			 handler(nil, [error localizedDescription]);
		 } else
			 handler(nil, @"Unknown");
	 }];
}

- (void) searchIngredients:(NSString*) strQuery handler:(void (^)(NSArray *, NSString *))handler
{
	NSString* strUrl = [strQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *endpoint = kEndpointIngredientSearch(100, strUrl);
	NSLog(@"%@", endpoint);
	NSDictionary *params = @{};
	
	[[AFAppDotNetAPIClient sharedClient]
	 GET:endpoint
	 parameters:params
	 success:^(AFHTTPRequestOperation * _Nonnull task, id  _Nullable responseObject) {
		 
		 if (responseObject) {
			 
			 NSLog(@"recipe response: %@", responseObject);
			 NSArray *arrResult = responseObject;
			 if (arrResult) {
				 NSMutableArray *arrIngredient = [[NSMutableArray alloc] init];
				 for (int i = 0; i < arrResult.count; i++) {
					 Ingredient* aIngredient = [[Ingredient alloc] init];
					 IngredientInfo *aIngredientInfo = [[IngredientInfo alloc] initWithDictionary:[arrResult objectAtIndex:i]];
					 aIngredient.index = 0;
					 aIngredient.name = aIngredientInfo.name;
					 aIngredient.imgName = [NSString stringWithFormat:@"%@%@", kImageIngredientPath, aIngredientInfo.imgName];
					 aIngredient.originalString = @"";
					 aIngredient.amount = 1.0f;
					 aIngredient.unit = @"";
					 aIngredient.snapkey = @"";
					 [arrIngredient addObject:aIngredient];
				 }
				 
				 handler(arrIngredient, nil);
				 return;
			 }
			 
			 handler(responseObject, nil);
			 return;
			 
		 }
		 else if (responseObject && ![AppData isNullOrEmptyString:[responseObject valueForKey:kError]]) {
			 handler(nil, [[responseObject valueForKey:kError] stringValue]);
			 return;
		 }
		 handler(nil, @"wrong request");
	 }
	 failure:^(AFHTTPRequestOperation * _Nullable task, NSError * _Nonnull error) {
		 if (error) {
			 NSLog(@"search details: %@", [error localizedDescription]);
			 handler(nil, [error localizedDescription]);
		 } else
			 handler(nil, @"Unknown");
	 }];
}

@end
