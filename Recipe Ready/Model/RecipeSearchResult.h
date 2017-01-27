//
//  RecipeSearchResult.h
//  Recipe Ready
//
//  Created by mac on 11/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeSearchResult : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* imageName;

- (id) initWithData:(NSDictionary *)data;

@end
