//
//  User.h
//  Wnyhsports
//
//  Created by Mac on 10/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) BOOL  bFacebookLogin;
@property (nonatomic, strong) NSString *snapKey;
@property (nonatomic, strong) NSString *avatarName;
@property (nonatomic, assign) int nFollowNum;
@property (nonatomic, assign) int nFollowingNum;
@property (nonatomic, assign) int nFriendNum;
@property (nonatomic, strong) NSString *readPhotoOption;
@property (nonatomic, strong) NSString *readCreatedRecipeOption;


- (void) save;
- (void) load;

// Auth
- (void) logout;

- (void) searchRecipe:(int)nCount query:(NSString*) strQuery handler:(void (^)(NSArray *, NSString *))handler;
- (void) getRecipeDetail:(int)nIndex handler:(void (^)(NSDictionary *, NSString *))handler;
- (void) searchRecipeByIngredients:(NSString*) strIngredients handler:(void (^)(NSArray *, NSString *))handler;
- (void) searchIngredients:(NSString*) strQuery handler:(void (^)(NSArray *, NSString *))handler;

@end
