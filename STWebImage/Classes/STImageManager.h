//
//  STImageManager.h
//  THKit
//
//  Created by legendry on 2018/1/25.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STWebImageProviderProtocol.h"

@interface STImageManager : NSObject

- (instancetype _Nonnull)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype _Nonnull)new UNAVAILABLE_ATTRIBUTE;
+ (STImageManager * _Nonnull)defaultImageManager;
+ (STImageManager * _Nonnull)managerWithAgeLimit:(NSTimeInterval)ageLimit
                                      countLimit:(NSUInteger)countLimit
                                       costLimit:(NSUInteger)costLimit
                                webImageProvider:(id<STWebImageProviderProtocol> _Nullable)webImageProvider;
- (UIImage * _Nullable)imageWithNamed:(NSString * _Nonnull)name ;
- (void)downloadImageWithUrl:(NSString * _Nonnull)imageUrl
                    progress:(STWebImageProgress _Nullable)progress
                    complete:(STWebImageComplete _Nullable)complete;
- (UIImage * _Nullable)imageForImageUrl:(NSString * _Nullable)imageUrl ;
- (void)cleanCache;
- (void)dumpCache;

@end
