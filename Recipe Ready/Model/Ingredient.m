//
//  Ingredient.m
//  Recipe Ready
//
//  Created by mac on 11/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

- (id) initWithDictionary:(NSDictionary *)data
{
	if ([self init] && data) {
		_index = [[data valueForKey:kIngredientId] integerValue];
		_name = [data valueForKey:kIngredientName];
		_imgName = [data valueForKey:kIngredientImgName];
		_originalString = [data valueForKey:kIngredientOriginal];
		if ([data valueForKey:kIngredientUnit])
			_unit = [data valueForKey:kIngredientUnit];
		else
			_unit = @"";
		
		if ([data valueForKey:kIngredientAmount])
			_amount = [[data valueForKey:kIngredientAmount] floatValue];
		else
			_amount = 1.0f;
		
		_snapkey = @"";
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*)strKey
{
	if ([self init] && data) {
		_index = [[data valueForKey:kIngredientId] integerValue];
		_name = [data valueForKey:kIngredientName];
		_imgName = [data valueForKey:kIngredientImgName];
		_originalString = [data valueForKey:kIngredientOriginal];
		if ([data valueForKey:kIngredientUnit])
			_unit = [data valueForKey:kIngredientUnit];
		else
			_unit = @"";
		
		if ([data valueForKey:kIngredientAmount])
			_amount = [[data valueForKey:kIngredientAmount] floatValue];
		else
			_amount = 1.0f;
		
		_snapkey = strKey;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeInteger:_index forKey:kIngredientId];
	[aCoder encodeObject:_name forKey:kIngredientName];
	[aCoder encodeObject:_imgName forKey:kIngredientImgName];
	[aCoder encodeObject:_originalString forKey:kIngredientOriginal];
	[aCoder encodeObject:_unit forKey:kIngredientUnit];
	[aCoder encodeFloat:_amount forKey:kIngredientAmount];
	[aCoder encodeObject:_snapkey forKey:kSnapKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kIngredientId];
		_name = [aDecoder decodeObjectForKey:kIngredientName];
		_imgName = [aDecoder decodeObjectForKey:kIngredientImgName];
		_originalString = [aDecoder decodeObjectForKey:kIngredientOriginal];
		if ([aDecoder decodeObjectForKey:kIngredientUnit])
			_unit = [aDecoder decodeObjectForKey:kIngredientUnit];
		else
			_unit = @"";
		
		if ([aDecoder decodeFloatForKey:kIngredientAmount])
			_amount = [aDecoder decodeFloatForKey:kIngredientAmount];
		else
			_amount = 1.0f;
		
		_snapkey = [aDecoder decodeObjectForKey:kSnapKey];
	}
	return self;
}

- (NSComparisonResult)compare:(Ingredient *)otherObject {
	return [self.name compare:otherObject.name];
}

@end
