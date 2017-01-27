//
//  IngredientInfo.m
//  Recipe Ready
//
//  Created by mac on 12/2/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "IngredientInfo.h"

@implementation IngredientInfo

- (id) initWithDictionary:(NSDictionary *)data
{
	if ([self init] && data) {
		_name = [data valueForKey:kIngredientName];
		_imgName = [data valueForKey:kIngredientImgName];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:_name forKey:kIngredientName];
	[aCoder encodeObject:_imgName forKey:kIngredientImgName];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_name = [aDecoder decodeObjectForKey:kIngredientName];
		_imgName = [aDecoder decodeObjectForKey:kIngredientImgName];
	}
	return self;
}

@end
