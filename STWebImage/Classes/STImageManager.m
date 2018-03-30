//
//  STImageManager.m
//  THKit
//
//  Created by legendry on 2018/1/25.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import "STImageManager.h"
#import "YYImageCache.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "YYImage.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+ST.h"
#import "STImageDownloader.h"

static NSString *_ImageUrlToCacheKey(NSString *val)
{
    return [val st_md5String] ;
}  

@implementation STImageManager
{
    YYImageCache *_imageCache ;
    NSString *_cachePath;
    id<STWebImageProviderProtocol> _webImageProvider;
    BOOL _canUseYYCacheForWebImageProvider;
}
+ (STImageManager *)defaultImageManager{
    STImageDownloader *defaultDownloader = [[STImageDownloader alloc] init] ;
    return [STImageManager managerWithAgeLimit:12 * 60 * 60 countLimit:50 costLimit:1024 * 1024 * 5 webImageProvider:defaultDownloader] ;
}
+ (STImageManager *)managerWithAgeLimit:(NSTimeInterval)ageLimit countLimit:(NSUInteger)countLimit costLimit:(NSUInteger)costLimit webImageProvider:(id<STWebImageProviderProtocol> _Nullable)webImageProvider{
    static STImageManager * _manager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[STImageManager alloc] initWithAgeLimit:ageLimit countLimit:countLimit costLimit:costLimit webImageProvider:webImageProvider] ;
    });
    return _manager ;
}
- (instancetype)initWithAgeLimit:(NSTimeInterval)ageLimit countLimit:(NSUInteger)countLimit costLimit:(NSUInteger)costLimit webImageProvider:(id<STWebImageProviderProtocol> _Nullable)webImageProvider
{
    self = [super init];
    if (self) {
        _cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.st.kit.image"];
        _imageCache = [[YYImageCache alloc] initWithPath:_cachePath] ;
        _imageCache.memoryCache.countLimit = countLimit ;
        _imageCache.memoryCache.ageLimit = ageLimit ;
        _imageCache.memoryCache.costLimit = costLimit ;
        
        _webImageProvider = webImageProvider ;
        if(_webImageProvider) {
            _canUseYYCacheForWebImageProvider = ![_webImageProvider implementCache] ;
        }
    }
    return self;
}

- (UIImage *)imageWithNamed:(NSString *)name {
    if(!name) return nil;
    UIImage *img = [_imageCache getImageForKey:name] ;
    if(!img) {
        img = [YYImage imageNamed:name] ;
        [_imageCache setImage:img imageData:nil forKey:name withType:YYImageCacheTypeMemory] ;

    }
    return img ;
}

- (void)downloadImageWithUrl:(NSString * _Nonnull)imageUrl
                    progress:(STWebImageProgress _Nullable)progress
                    complete:(STWebImageComplete _Nullable)complete {
    NSAssert(_webImageProvider, @"Please provide a image downloader.") ;
    if(!imageUrl) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:-2 userInfo:@{@"reason":@"ImageUrl can't be nil."}] ;
        !complete ? : complete(nil,error,STWebImageCacheTypeNone) ;
        return ;
    }
    
    NSString *cacheKey = _ImageUrlToCacheKey(imageUrl) ;
    BOOL shouldCache = self->_canUseYYCacheForWebImageProvider ;
    YYImageCache *cache = self->_imageCache ;
    
    if(shouldCache) {
        UIImage *imageCache = nil ;
        imageCache = [cache getImageForKey:cacheKey withType:YYImageCacheTypeMemory] ;
        if(imageCache) {
            !complete ? : complete(imageCache,nil,STWebImageCacheTypeMemery);
            return ;
        }
        imageCache = [cache getImageForKey:cacheKey withType:YYImageCacheTypeDisk] ;
        if(imageCache) {
            [cache setImage:imageCache imageData:nil forKey:cacheKey withType:YYImageCacheTypeMemory] ;
            !complete ? : complete(imageCache,nil,STWebImageCacheTypeDisk);
            return ;
        }
    }

    STWebImageProgress _progress = ^(CGFloat percent,NSData *receivedData) {
        !progress ? : progress(percent,receivedData) ;
    };
    STWebImageComplete _complete = ^(UIImage * _Nullable image,NSError * _Nullable error,STWebImageCacheType cacheType) {
        !complete ? : complete(image,error,cacheType) ;
        if(shouldCache) {
            [cache setImage:image forKey:cacheKey] ;
        }
    };
    [_webImageProvider imageWithUrl:imageUrl progress:_progress complete:_complete] ;
}

- (UIImage *)imageForImageUrl:(NSString *)imageUrl{
    if(!imageUrl) return nil ;
    NSString *cacheKey = _ImageUrlToCacheKey(imageUrl) ;
    return [_imageCache getImageForKey:cacheKey] ;
}

- (void)cleanCache {
    [_imageCache.memoryCache removeAllObjects] ;
    [_imageCache.diskCache removeAllObjects] ;
}

- (void)dumpCache {
    
    NSString *cacheInfo = [NSString stringWithFormat:@"Memery Cache:%ld,Size:%ld\nDisk Cache:%@",_imageCache.memoryCache.totalCost,_imageCache.memoryCache.totalCount,_imageCache.diskCache.path] ;
    NSLog(@"%@",cacheInfo) ;
    
}

@end
