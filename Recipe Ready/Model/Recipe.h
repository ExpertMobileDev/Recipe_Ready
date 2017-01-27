//
//  Sport.h
//  Wnyhsports
//
//  Created by Mac on 10/29/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* name;

- (id) initWithData:(NSDictionary *)data;

@end
