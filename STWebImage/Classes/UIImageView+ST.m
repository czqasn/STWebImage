//
//  UIImageView+STimageLoad.m
//  THKit
//
//  Created by legendry on 2018/1/29.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import "UIImageView+ST.h"
#import "STImageManager.h"
#import "YYImageCoder.h"
#import "STYYTransaction.h"
#import <YYImage/YYImage.h>


static dispatch_queue_t _ImageDecodeQueue(){
    static dispatch_queue_t _imageDecodeQueue = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageDecodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return _imageDecodeQueue ;
}


static void _DisplayImageViewWithType(UIImageView *imageView,STImageViewDisplayType type) {
    switch (type) {
        case STImageViewDisplayTypeFadeIn: {
            CALayer *layer = imageView.layer ;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"] ;
            animation.fromValue = @(0.1f) ;
            animation.toValue = @(1.0f) ;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
            animation.duration = 0.5f ;
            animation.fillMode = kCAFillModeForwards ;
            animation.removedOnCompletion = YES ;
            [layer addAnimation:animation forKey:@"_STimageViewDisplayTypeFadeIn"] ;
        }
        break;
            
        default:
            break;
    }
}


@interface _STimageViewTransactionImpl : NSObject
@property (nonatomic,strong)UIImage *image ;
@property (nonatomic,strong)UIImageView *imageView ;
@property (nonatomic,assign)STImageViewDisplayType displayType;
@end

@implementation _STimageViewTransactionImpl
- (void)_display {
    if(!_image  || !_imageView) {
        return ;
    }
    _imageView.image = _image ;
    _DisplayImageViewWithType(self.imageView,_displayType) ;
}
@end


static void _DisplayImage(UIImageView *imageView,UIImage *image,BOOL immediatelyDisplay,STImageViewDisplayType displayType) {
    if(immediatelyDisplay) {
        if(!image.yy_isDecodedForDisplay) {
            dispatch_async(_ImageDecodeQueue(), ^{
                UIImage *_resultImage = [image yy_imageByDecoded] ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = _resultImage ;
                    _DisplayImageViewWithType(imageView,displayType) ;
                });
            });
        } else {
            if([NSThread isMainThread]) {
                imageView.image = image ;
                _DisplayImageViewWithType(imageView, displayType) ;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image ;
                    _DisplayImageViewWithType(imageView,displayType) ;
                });
            }
        }
    } else {
        //提交到RunLoop空闲时候去显示
        dispatch_async(_ImageDecodeQueue(), ^{
            _STimageViewTransactionImpl *imageViewTransactionImpl = [[_STimageViewTransactionImpl alloc] init] ;
            imageViewTransactionImpl.image = [image yy_imageByDecoded] ;
            imageViewTransactionImpl.imageView = imageView ;
            imageViewTransactionImpl.displayType = displayType ;
            dispatch_async(dispatch_get_main_queue(), ^{
                STYYTransaction *transaction = [STYYTransaction transactionWithTarget:imageViewTransactionImpl selector:@selector(_display)] ;
                [transaction commit] ;
            });
        });
    }
}



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
    //从缓存读取到图片
    if(image) {
        !progressBlock ?: progressBlock(1.0);
        _DisplayImage(self, image, YES, displayType) ;
        return ;
    }

    STWebImageComplete _completeBlock = ^(UIImage *image,NSError *error,STWebImageCacheType cacheType) {
        __strong typeof(weak_self) strong_self = weak_self ;
        if(!strong_self) return ;
        if(!image) {
            return ;
        }
        _DisplayImage(strong_self, image, immediatelyDisplay,displayType) ;
    };
    self.image = placeholderImage ;
    [[STImageManager defaultImageManager] downloadImageWithUrl:imageUrl progress:progressBlock complete:_completeBlock] ;

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
