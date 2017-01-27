//
//  RecipeDetail.h
//  Recipe Ready
//
//  Created by mac on 11/24/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeDetail : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* instructions;
@property (nonatomic, retain) NSMutableArray*	arrIngredients;
@property (nonatomic, strong) NSString* snapkey;
@property (nonatomic, strong) NSString* userid;
@property (nonatomic, strong) NSString* createdDateTime;

- (id) initWithDictionary:(NSDictionary *)data;
- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*) strKey;
- (id) initWithDictionary:(NSDictionary *)data snapKey:(NSString*) strKey userId:(NSString*) strUserId;
@end
