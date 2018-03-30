//
//  STWebImageProviderProtocol.h
//
//  Created by legendry on 2018/1/25.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol STWebImageProviderProtocol <NSObject>

typedef NS_ENUM(NSInteger,STWebImageCacheType) {
    STWebImageCacheTypeNone = 0,
    STWebImageCacheTypeWeb,
    STWebImageCacheTypeMemery,
    STWebImageCacheTypeDisk
};

typedef void(^STWebImageProgress)(CGFloat percent,NSData  * _Nonnull receivedData);
typedef void(^STWebImageComplete)(UIImage * _Nullable image,NSError * _Nullable error,STWebImageCacheType cacheType);

/**
 从网络获取图片

 @param imageUrl 图片地址
 @param progress 处理回调
 @param complete 获取图片完成回调
 */
- (void)imageWithUrl:(NSString * _Nonnull)imageUrl progress:(STWebImageProgress _Nullable)progress complete:(STWebImageComplete _Nullable)complete;


/**
 是否已经提供了缓存了,如果返回NO,则回自动增加缓存处理
 */
- (BOOL)implementCache;
@end
