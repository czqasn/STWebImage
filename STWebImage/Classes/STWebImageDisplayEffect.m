//
//  STWebImageDisplayEffect.m
//  STWebImage
//
//  Created by legendry on 2018/3/30.
//

#import "STWebImageDisplayEffect.h"
#import <YYImage/YYImage.h>


static dispatch_queue_t _GetSTWebImageDisplayEffectProssiveQueue() {
    static dispatch_queue_t __STWebImageDisplayEffectProssiveQueue = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __STWebImageDisplayEffectProssiveQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0) ;
    });
    return __STWebImageDisplayEffectProssiveQueue ;
}

@implementation STWebImageDisplayEffectProssive
{
    NSMutableData *_data ;
    YYImageDecoder *_decoder ;
    UIImageView *_imageView ;
    CGFloat _granularity ;
    CGFloat _percent;
    CGFloat _nextDecodePercent;
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s",__func__) ;
#endif
}
- (instancetype)initWithImageView:(UIImageView *)imageView
{
    self = [super init];
    if (self) {
        _imageView = imageView ;
        _data = [[NSMutableData alloc] init] ;
        _decoder = [[YYImageDecoder alloc] initWithScale:[UIScreen mainScreen].scale] ;
        _granularity = 1.0 / 5 ;
        _nextDecodePercent = _granularity ;
    }
    return self;
}

- (void)receiveData:(NSData *)data percent:(CGFloat)percent{
    [_data appendData:data] ;
    _percent = percent ;
    if(_percent >= _nextDecodePercent) {
        [_decoder updateData:_data final:NO] ;
        dispatch_async(_GetSTWebImageDisplayEffectProssiveQueue(), ^{
            YYImageFrame *frame = [_decoder frameAtIndex:0 decodeForDisplay:YES] ;
            _nextDecodePercent = _percent + _granularity ;
            if(_nextDecodePercent > 1.0) {
                _nextDecodePercent = 1.0 ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = frame.image ;
            });
        });
    }
    
}
@end
