//
//  CreatedRecipe.h
//  Recipe Ready
//
//  Created by mac on 12/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatedRecipe : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* instructions;
@property (nonatomic, retain) NSMutableArray*	arrIngredients;
@property (nonatomic, strong) NSString* user_id;

- (id) initWithDictionary:(NSDictionary *)data;

@end
