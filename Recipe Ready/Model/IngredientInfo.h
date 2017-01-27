//
//  IngredientInfo.h
//  Recipe Ready
//
//  Created by mac on 12/2/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientInfo : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* imgName;

- (id) initWithDictionary:(NSDictionary *)data;


@end
