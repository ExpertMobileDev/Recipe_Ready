//
//  RecipeSearchResult.m
//  Recipe Ready
//
//  Created by mac on 11/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "RecipeSearchResult.h"

@implementation RecipeSearchResult

- (id) initWithData:(NSDictionary *)data
{
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_name = [data valueForKey:kRecipeTitle];
		_imageName = [data valueForKey:kRecipeImgName];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeInteger:_index forKey:kRecipeId];
	[aCoder encodeObject:_name forKey:kRecipeTitle];
	[aCoder encodeObject:_imageName forKey:kRecipeImgName];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kRecipeId];
		_name = [aDecoder decodeObjectForKey:kRecipeTitle];
		_imageName = [aDecoder decodeObjectForKey:kRecipeImgName];
	}
	return self;
}

@end
