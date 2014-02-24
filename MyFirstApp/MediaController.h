//
//  MediaController.h
//  MyFirstApp
//
//  Created by Alex Hint on 2/22/14.
//  Copyright (c) 2014 Alex Hint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaController : NSObject

@property (nonatomic, strong) NSArray *mediaObjects;

- (void)fetchPopularMediaWithCompletionBlock:(void (^)(BOOL success))completionBlock;

//+ (BOOL)isValidElement:(id)element;

@end
