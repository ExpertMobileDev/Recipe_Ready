//
//  Rate.m
//  Wnyhsports
//
//  Created by Mac on 10/29/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Rate.h"

@implementation Rate : NSObject

- (id) initWithData:(NSDictionary *)data
{
    if ([self init] && data) {
        _index = [[data valueForKey:kRecipeId] integerValue];
		_member = [[data valueForKey:kRateMemberCount] integerValue];
		_mark = [[data valueForKey:kRateMark] integerValue];
    }
    return self;
}

- (id) initWithData:(NSDictionary *)data snapkey:(NSString*) strKey {
	if ([self init] && data) {
		_index = [[data valueForKey:kRecipeId] integerValue];
		_member = [[data valueForKey:kRateMemberCount] integerValue];
		_mark = [[data valueForKey:kRateMark] integerValue];
		_snapKey = strKey;
	}
	return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeInteger:_index forKey:kRecipeId];
	[aCoder encodeInteger:_member forKey:kRateMemberCount];
	[aCoder encodeInteger:_mark forKey:kRateMark];
	[aCoder encodeObject:_snapKey forKey:kRateKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super init]){
		_index = [aDecoder decodeIntegerForKey:kRecipeId];
		_member = [aDecoder decodeIntegerForKey:kRateMemberCount];
		_mark = [aDecoder decodeIntegerForKey:kRateMark];
		_snapKey = [aDecoder decodeObjectForKey:kRateKey];
	}
	return self;
}


@end
