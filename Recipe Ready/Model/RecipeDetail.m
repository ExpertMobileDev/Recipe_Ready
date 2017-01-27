//
//  RecipeDetail.m
//  Recipe Ready
//
//  Created by mac on 11/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

@implementation RecipeDetail

- (id) initWithDictionary:(NSDictionary *)data
{
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_title = [data valueForKey:kRecipeTitle];
		_imageName = [data valueForKey:kRecipeImgName];
		_instructions = [data valueForKey:kRecipeInstruction];
		if ([data valueForKey:kRecipeDateTime])
			_createdDateTime = [data valueForKey:kRecipeDateTime];
		else
			_createdDateTime = @"";

		if ([data valueForKey:kSnapKey])
			_snapkey = [data valueForKey:kSnapKey];
		else
			_snapkey = @"";

		if ([data valueForKey:kUserId])
			_userid = [data valueForKey:kUserId];
		else
			_userid = @"";
	
		NSArray* ingreArr = [data valueForKey:kRecipeIngredient];
		
		_arrIngredients = [[NSMutableArray alloc] init];
		for (NSDictionary* dicIngredient in ingreArr) {
			Ingredient* ingredient = [[Ingredient alloc] initWithDictionary:dicIngredient];
			[_arrIngredients addObject:ingredient];
		}
		
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*) strKey{
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_title = [data valueForKey:kRecipeTitle];
		_imageName = [data valueForKey:kRecipeImgName];
		_instructions = [data valueForKey:kRecipeInstruction];
		if ([data valueForKey:kRecipeDateTime])
			_createdDateTime = [data valueForKey:kRecipeDateTime];
		else
			_createdDateTime = @"";
		if ([data valueForKey:kUserId])
			_userid = [data valueForKey:kUserId];
		else
			_userid = @"";
		
		_snapkey = strKey;

		NSArray* ingreArr = [data valueForKey:kRecipeIngredient];
		
		_arrIngredients = [[NSMutableArray alloc] init];
		for (NSDictionary* dicIngredient in ingreArr) {
			Ingredient* ingredient = [[Ingredient alloc] initWithDictionary:dicIngredient];
			[_arrIngredients addObject:ingredient];
		}
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*) strKey userId:(NSString*) strUserId {
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_title = [data valueForKey:kRecipeTitle];
		_imageName = [data valueForKey:kRecipeImgName];
		_instructions = [data valueForKey:kRecipeInstruction];
		if ([data valueForKey:kRecipeDateTime])
			_createdDateTime = [data valueForKey:kRecipeDateTime];
		else
			_createdDateTime = @"";
		_snapkey = strKey;
		_userid = strUserId;
		
		NSArray* ingreArr = [data valueForKey:kRecipeIngredient];
		
		_arrIngredients = [[NSMutableArray alloc] init];
		for (NSDictionary* dicIngredient in ingreArr) {
			Ingredient* ingredient = [[Ingredient alloc] initWithDictionary:dicIngredient];
			[_arrIngredients addObject:ingredient];
		}
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeInteger:_index forKey:kRecipeId];
	[aCoder encodeObject:_title forKey:kRecipeTitle];
	[aCoder encodeObject:_imageName forKey:kRecipeImgName];
	[aCoder encodeObject:_instructions forKey:kRecipeInstruction];
	[aCoder encodeObject:_snapkey forKey:kSnapKey];
	[aCoder encodeObject:_userid forKey:kUserId];
	[aCoder encodeObject:_createdDateTime forKey:kRecipeDateTime];
	[aCoder encodeObject:_arrIngredients forKey:kRecipeIngredient];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kRecipeId];
		_title = [aDecoder decodeObjectForKey:kRecipeTitle];
		_imageName = [aDecoder decodeObjectForKey:kRecipeImgName];
		_instructions = [aDecoder decodeObjectForKey:kRecipeInstruction];
		_snapkey = [aDecoder decodeObjectForKey:kSnapKey];
		_userid = [aDecoder decodeObjectForKey:kUserId];
		_createdDateTime = [aDecoder decodeObjectForKey:kRecipeDateTime];
		_arrIngredients = [aDecoder decodeObjectForKey:kRecipeIngredient];
	}
	return self;
}

@end
