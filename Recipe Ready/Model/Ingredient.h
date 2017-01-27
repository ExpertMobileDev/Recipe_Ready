//
//  Ingredient.h
//  Recipe Ready
//
//  Created by mac on 11/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* imgName;
@property (nonatomic, strong) NSString* originalString;
@property (nonatomic, strong) NSString* unit;
@property (nonatomic, strong) NSString* snapkey;

- (id) initWithDictionary:(NSDictionary *)data;
- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*) strKey;
- (NSComparisonResult)compare:(Ingredient *)otherObject;

@end
