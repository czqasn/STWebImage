//
//  UIImageView+STimageLoad.m
//  THKit
//
//  Created by legendry on 2018/1/29.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import "UIImageView+ST.h"
#import "STImageManager.h"
#import "STYYTransaction.h"
#import <YYImage/YYImage.h>
#import "STWebImageDisplay.h"
#import "STWebImageDisplayEffect.h"
#import "STWebImageDisplay.h"






#pragma mark - web image category
@implementation UIImageView (TH)

- (void)st_setImageWithUrl:(NSString *)imageUrl {
    [self st_setImageWithUrl:imageUrl
            placeholderImage:nil] ;
}
- (void)st_setImageWithUrl:(NSString *)imageUrl
               displayType:(STImageViewDisplayType)displayType {
    [self st_setImageWithUrl:imageUrl
            placeholderImage:nil
          immediatelyDisplay:NO
                 displayType:displayType] ;
}
- (void)st_setImageWithUrl:(NSString *)imageUrl immediatelyDisplay:(BOOL)immediatelyDisplay {
    [self st_setImageWithUrl:imageUrl
            placeholderImage:nil
          immediatelyDisplay:immediatelyDisplay] ;
}
- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage *)placeholderImage {
    [self st_setImageWithUrl:imageUrl
            placeholderImage:placeholderImage
          immediatelyDisplay:NO] ;
}
- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage *)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay {
    [self st_setImageWithUrl:imageUrl
            placeholderImage:placeholderImage
          immediatelyDisplay:immediatelyDisplay
                 displayType:STImageViewDisplayTypeNone] ;
}
- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage *)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay
               displayType:(STImageViewDisplayType)displayType {

    [self st_setImageWithUrl:imageUrl
            placeholderImage:placeholderImage
          immediatelyDisplay:immediatelyDisplay
                 displayType:displayType
               progressBlock:NULL];

}

- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage *)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay
               displayType:(STImageViewDisplayType)displayType
             progressBlock:(void(^ _Nullable)(CGFloat percent))progressBlock {

    if(!imageUrl) return ;
    __weak typeof(self) weak_self = self ;

    UIImage *image = nil ;
    image = [[STImageManager defaultImageManager] imageForImageUrl:imageUrl] ;
    //read cache from disk
    if(image) {
        !progressBlock ?: progressBlock(1.0);
        _DisplayImage(self, image, YES, displayType) ;
        return ;
    }
    
    STWebImageDisplayEffectProssive *_webImageDisplayEffectProssive = nil ;
    if(displayType == STImageViewDisplayTypeProgressive) {
        _webImageDisplayEffectProssive = [[STWebImageDisplayEffectProssive alloc] initWithImageView:self] ;
    }
    

    STWebImageProgress _progressBlock = ^(CGFloat percent,NSData *receivedData) {
        !progressBlock ?: progressBlock(percent);
        //display progressive image
        if(_webImageDisplayEffectProssive){
            [_webImageDisplayEffectProssive receiveData:receivedData percent:percent] ;
        }
    };

    STWebImageComplete _completeBlock = ^(UIImage *image,NSError *error,STWebImageCacheType cacheType) {
        __strong typeof(weak_self) strong_self = weak_self ;
        if(!strong_self) return ;
        if(!image) {
            return ;
        }
        if(!_webImageDisplayEffectProssive) {
            _DisplayImage(strong_self, image, immediatelyDisplay,displayType) ;
        }
    };
    //set placeholder image
    self.image = placeholderImage ;
    //download from network
    [[STImageManager defaultImageManager] downloadImageWithUrl:imageUrl progress:_progressBlock complete:_completeBlock] ;

}

- (void)st_setImageWithName:(NSString *)name {
    [self st_setImageWithName:name immediatelyDisplay:YES] ;
}
- (void)st_setImageWithName:(NSString *)name immediatelyDisplay:(BOOL)immediatelyDisplay {
    if(!name) return ;
    UIImage *image = [[STImageManager defaultImageManager] imageWithNamed:name] ;
    if(!image) {
        self.image = nil  ;
        return ;
    }
    _DisplayImage(self, image, immediatelyDisplay,STImageViewDisplayTypeNone) ;
    
}

@end
