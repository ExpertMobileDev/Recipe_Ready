//
//  Rate.h
//  RecipeReady
//
//  Created by Mac on 10/29/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rate : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger member;
@property (nonatomic, assign) NSInteger mark;
@property (nonatomic, strong) NSString* snapKey;

- (id) initWithData:(NSDictionary *)data;
- (id) initWithData:(NSDictionary *)data snapkey:(NSString*) strKey;
@end
