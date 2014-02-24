//
//  MediaController.m
//  MyFirstApp
//
//  Created by Alex Hint on 2/22/14.
//  Copyright (c) 2014 Alex Hint. All rights reserved.
//

#import "MediaController.h"
#import "MediaObject.h"

@implementation MediaController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.mediaObjects = [NSArray array];
    }
    return self;
}

- (void)fetchPopularMediaWithCompletionBlock:(void (^)(BOOL success))completionBlock
{
    NSString *instagramEndpoint = @"https://api.instagram.com/v1/media/popular?client_id=5609d2fb2bf74d749716bd00a9090e5e";
    NSURL *URL = [NSURL URLWithString:instagramEndpoint];
    
    // 1. Get a reference to the shared NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 2. Invoke the dataTaskWithURL:completionHandler: method on the shared NSURLSession
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    // 3. In the completionHandler, check that the response has status code 200. If yes, call completionBlock(YES). If no, call completionBlock(NO).
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            // Use the NSJSONSerialization to convert the data into an NSDictionary
            // Check to see if serialization generated an NSError
            NSError *JSONParseError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&JSONParseError];
            if (JSONParseError)
            {
                // If yes, call completion(NO). If no, NSLog the dictionary and call completionBlock(YES).
                completionBlock(NO);
            }
            else
            {
                self.mediaObjects = [self mediaObjectsFromResponse:dictionary];
                //sort the array in order
                self.mediaObjects = [self sortMediaObjects];
                completionBlock(YES);
            }
            
        }
        else
        {
            completionBlock(NO);
        }
        
    }];
    
    // 4. Make sure you call the NSURLSessionDataTask method that actually initiates the task
    [task resume];

}

- (NSArray *)mediaObjectsFromResponse:(NSDictionary *)response
{
    // Initialize an empty NSMutableArray to hold the MediaObjects you create
    NSMutableArray * mediaObjects = [NSMutableArray array];
    
    // Extract the array value that is keyed to the key "data" in the response dictionary
    NSArray *data = [response valueForKey:@"data"];
    
    // Loop through this data array
    for (NSDictionary *mediaDictionary in data)
    {
        // Convert each dictionary it contains into a MediaObject, using our initWithDictionary constructor
        MediaObject *mediaObject = [[MediaObject alloc] initWithDictionary:mediaDictionary];
        // Adding each new MediaObject to our NSMutableArray
        [mediaObjects addObject:mediaObject];
    }
    
    //print out all the objects
    NSLog(@"%@", mediaObjects);
    //print out the number of objects
    NSLog(@"%lu", [mediaObjects count]);
    
    // Return the NSMutableArray of MediaObjects
    return mediaObjects;
    
}

- (NSArray *)sortMediaObjects
{
    // Sort mediaObjects alphabetically by username
    
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
    NSArray * descriptors = @[descriptor];
    NSArray * sortedArray = [self.mediaObjects sortedArrayUsingDescriptors:descriptors];
    
    return sortedArray;
}

@end


