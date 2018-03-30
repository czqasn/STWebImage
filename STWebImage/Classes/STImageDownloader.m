//
//  STImageDownloader.m
//  THKit
//
//  Created by legendry on 2018/1/26.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import "STImageDownloader.h"
#import <STDownloader/STDownloader.h>
#import "NSString+ST.h"
#import "YYImage.h"

NS_INLINE void _CleanDownloadCache(NSString * _Nonnull path) {
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    [fileManager removeItemAtPath:path error:NULL] ;
}

@implementation STImageDownloader
{
    STDownloader *_downloader ;
    dispatch_queue_t _downloadQueue ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *defaultDownloadDirectory = nil ;
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] ;
        NSString *defaultDownloadDirName = @"com.st.download.image";
        defaultDownloadDirectory = [cacheDir stringByAppendingPathComponent:defaultDownloadDirName] ;
        _downloader = [[STDownloader alloc] initWithMaximumDownloadCount:3 downloadDirectory:defaultDownloadDirectory] ;
        _downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0) ;
    }
    return self;
}

- (void)imageWithUrl:(NSString * _Nonnull)imageUrl progress:(STWebImageProgress _Nullable)progress complete:(STWebImageComplete _Nullable)complete {
    if(!imageUrl) return ;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ;
    STWebImageProgress copyProgress = [progress copy] ;
    STWebImageComplete copyComplete = [complete copy] ;
    NSString *imageURLMD5 = [imageUrl st_md5String] ;
    NSUUID *receiptID = [[NSUUID alloc] initWithUUIDString:imageURLMD5] ;
    __weak typeof(self->_downloadQueue) weak_queue = self->_downloadQueue ;
    STDownloadSuccess successBlock = ^(NSURLRequest *request,NSString *filePath) {
        __strong typeof(weak_queue) strong_queue = weak_queue ;
        if(!filePath) return ;
        if(!copyComplete) return ;
        if(!strong_queue) return ;
        dispatch_async(strong_queue, ^{
            YYImage *image = [YYImage imageWithContentsOfFile:filePath] ;
            copyComplete(image,nil,STWebImageCacheTypeWeb);
        });
    };
    STDownloadProgress progressBlock = ^(NSURLRequest * request,NSUInteger receiveDataLength,NSUInteger totalDataLength,NSData *receivedData){
        if(!copyProgress) return ;
        copyProgress(receiveDataLength * 1.0f / totalDataLength,receivedData);

    };
    STDownloadFailure failureBlock = ^(NSURLRequest * request,NSError * error) {
        if(!copyComplete) return ;
        copyComplete(nil,error,STWebImageCacheTypeNone);
    };
    STDownloadComplete taskComplete = ^(NSURLRequest *request,NSString *path) {
        __strong typeof(weak_queue) strong_queue = weak_queue ;
        dispatch_async(strong_queue, ^{
            _CleanDownloadCache(path) ;
        });
    };
    NSURL *url = [NSURL URLWithString:imageUrl] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    [_downloader downloadFileForURLRequest:request receiptID:receiptID success:successBlock progress:progressBlock failure:failureBlock complete:taskComplete] ;
}
- (BOOL)implementCache {
    return NO ;
}
@end
