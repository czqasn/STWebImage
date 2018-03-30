//
//  STWebImageDisplay.h
//  STWebImage
//
//  Created by legendry on 2018/3/30.
//

#import <Foundation/Foundation.h>
#import "STYYTransaction.h"
#import <YYImage/YYImage.h>
#import "STWebImageDisplayEffect.h"


static dispatch_queue_t _ImageDecodeQueue(){
    static dispatch_queue_t _imageDecodeQueue = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageDecodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    });
    return _imageDecodeQueue ;
}


#pragma mark - Transaction

@interface _STimageViewTransactionImpl : NSObject
@property (nonatomic,strong)UIImage *image ;
@property (nonatomic,strong)UIImageView *imageView ;
@property (nonatomic,assign)STImageViewDisplayType displayType;
@end



#pragma mark - display image

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static void _DisplayImage(UIImageView *imageView,UIImage *image,BOOL immediatelyDisplay,STImageViewDisplayType displayType) {
#pragma clang diagnostic pop
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
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
                STYYTransaction *transaction = [STYYTransaction transactionWithTarget:imageViewTransactionImpl selector:@selector(_display)] ;
#pragma clang diagnostic pop
                [transaction commit] ;
            });
        });
    }
}
