//
//  UserInfo.m
//  Recipe Ready
//
//  Created by mac on 12/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id) initWithDictionary:(NSDictionary *)data
{
	if ([self init] && data) {
		_email = [data valueForKey:kEmail];
		_username = [data valueForKey:kUserName];
		_password = [data valueForKey:kPass];
		_user_id = [data valueForKey:kUserId];
		_bFacebookLogin = [[data valueForKey:kBFacebookLogin] boolValue];
		if ([data valueForKey:kUserAvatar])
			_avatarName = [data valueForKey:kUserAvatar];
		else
			_avatarName = @"";
		if ([data valueForKey:kFollowNum])
			_nFollowNum = [[data valueForKey:kFollowNum] integerValue];
		else
			_nFollowNum = 0;
		
		if ([data valueForKey:kFriendNum])
			_nFriendNum = [[data valueForKey:kFriendNum] integerValue];
		else
			_nFriendNum = 0;
		
		if ([data valueForKey:kFollowingNum])
			_nFollowingNum = [[data valueForKey:kFollowingNum] integerValue];
		else
			_nFollowingNum = 0;
		if ([data valueForKey:kStrProfilePhotoOption])
			_readPhotoOption = [data valueForKey:kStrProfilePhotoOption];
		else
			_readPhotoOption = @"";
		if ([data valueForKey:kStrCreatedRecipeOption])
			_readCreatedRecipeOption = [data valueForKey:kStrCreatedRecipeOption];
		else
			_readCreatedRecipeOption = @"";
		if ([data valueForKey:kSnapKey])
			_snapkey = [data valueForKey:kSnapKey];
		else
			_snapkey = @"";

	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)data snapkey:(NSString*)strSnapKey {
	if ([self init] && data) {
		_email = [data valueForKey:kEmail];
		_username = [data valueForKey:kUserName];
		_password = [data valueForKey:kPass];
		_user_id = [data valueForKey:kUserId];
		_bFacebookLogin = [[data valueForKey:kBFacebookLogin] boolValue];
		if ([data valueForKey:kUserAvatar])
			_avatarName = [data valueForKey:kUserAvatar];
		else
			_avatarName = @"";
		if ([data valueForKey:kFollowNum])
			_nFollowNum = [[data valueForKey:kFollowNum] integerValue];
		else
			_nFollowNum = 0;
		
		if ([data valueForKey:kFriendNum])
			_nFriendNum = [[data valueForKey:kFriendNum] integerValue];
		else
			_nFriendNum = 0;
		
		if ([data valueForKey:kFollowingNum])
			_nFollowingNum = [[data valueForKey:kFollowingNum] integerValue];
		else
			_nFollowingNum = 0;
		if ([data valueForKey:kStrProfilePhotoOption])
			_readPhotoOption = [data valueForKey:kStrProfilePhotoOption];
		else
			_readPhotoOption = @"";
		if ([data valueForKey:kStrCreatedRecipeOption])
			_readCreatedRecipeOption = [data valueForKey:kStrCreatedRecipeOption];
		else
			_readCreatedRecipeOption = @"";

		_snapkey = strSnapKey;		
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:_email forKey:kEmail];
	[aCoder encodeObject:_username forKey:kUserName];
	[aCoder encodeObject:_password forKey:kPass];
	[aCoder encodeObject:_user_id forKey:kUserId];
	[aCoder encodeObject:_avatarName forKey:kUserAvatar];
	[aCoder encodeInteger:_nFollowNum forKey:kFollowNum];
	[aCoder encodeInteger:_nFollowingNum forKey:kFollowingNum];
	[aCoder encodeInteger:_nFriendNum forKey:kFriendNum];
	[aCoder encodeBool:_bFacebookLogin forKey:kBFacebookLogin];
	[aCoder encodeObject:_readPhotoOption forKey:kStrProfilePhotoOption];
	[aCoder encodeObject:_readCreatedRecipeOption forKey:kStrCreatedRecipeOption];
	[aCoder encodeObject:_snapkey forKey:kSnapKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_email = [aDecoder decodeObjectForKey:kEmail];
		_username = [aDecoder decodeObjectForKey:kUserName];
		_password = [aDecoder decodeObjectForKey:kPass];
		_user_id = [aDecoder decodeObjectForKey:kUserId];
		_avatarName = [aDecoder decodeObjectForKey:kUserAvatar];
		_nFollowNum = [aDecoder decodeIntegerForKey:kFollowNum];
		_nFollowingNum = [aDecoder decodeIntegerForKey:kFollowingNum];
		_nFriendNum = [aDecoder decodeIntegerForKey:kFriendNum];
		_bFacebookLogin = [aDecoder decodeBoolForKey:kBFacebookLogin];
		_readPhotoOption = [aDecoder decodeObjectForKey:kStrProfilePhotoOption];
		_readCreatedRecipeOption = [aDecoder decodeObjectForKey:kStrCreatedRecipeOption];
		_snapkey = [aDecoder decodeObjectForKey:kSnapKey];
	}
	return self;
}

@end
