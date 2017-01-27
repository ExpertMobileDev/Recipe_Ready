//
//  UserInfo.h
//  Recipe Ready
//
//  Created by mac on 12/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *avatarName;
@property (nonatomic, assign) int nFollowNum;
@property (nonatomic, assign) int nFollowingNum;
@property (nonatomic, assign) int nFriendNum;
@property (nonatomic, assign) BOOL bFacebookLogin;
@property (nonatomic, strong) NSString *readPhotoOption;
@property (nonatomic, strong) NSString *readCreatedRecipeOption;
@property (nonatomic, strong) NSString *snapkey;


- (id) initWithDictionary:(NSDictionary *)data;
- (id) initWithDictionary:(NSDictionary *)data snapkey:(NSString*)strSnapKey;

@end
