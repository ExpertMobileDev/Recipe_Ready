//
//  Sport.m
//  Wnyhsports
//
//  Created by Mac on 10/29/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe : NSObject

- (id) initWithData:(NSDictionary *)data
{
    if ([self init] && data) {
        _index = [[data valueForKey:kRecipeId] integerValue];
        _name = [data valueForKey:kRecipeTitle];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeInteger:_index forKey:kRecipeId];
	[aCoder encodeObject:_name forKey:kRecipeTitle];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kRecipeId];
		_name = [aDecoder decodeObjectForKey:kRecipeTitle];
	}
	return self;
}


@end
