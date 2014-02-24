//
//  MediaObject.h
//  MyFirstApp
//
//  Created by Alex Hint on 2/23/14.
//  Copyright (c) 2014 Alex Hint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaObject : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *imageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
