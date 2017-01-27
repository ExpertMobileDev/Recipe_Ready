//
//  CreatedRecipe.m
//  Recipe Ready
//
//  Created by mac on 12/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "CreatedRecipe.h"

@implementation CreatedRecipe

- (id) initWithDictionary:(NSDictionary *)data
{
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_title = [data valueForKey:kRecipeTitle];
		_imageName = [data valueForKey:kRecipeImgName];
		_instructions = [data valueForKey:kRecipeInstruction];
		_user_id = [data valueForKey:kUserId];
		
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
	[aCoder encodeObject:_user_id forKey:kUserId];
	[aCoder encodeObject:_arrIngredients forKey:kRecipeIngredient];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kRecipeId];
		_title = [aDecoder decodeObjectForKey:kRecipeTitle];
		_imageName = [aDecoder decodeObjectForKey:kRecipeImgName];
		_instructions = [aDecoder decodeObjectForKey:kRecipeInstruction];
		_user_id = [aDecoder decodeObjectForKey:kUserId];
		_arrIngredients = [aDecoder decodeObjectForKey:kRecipeIngredient];
	}
	return self;
}

@end
