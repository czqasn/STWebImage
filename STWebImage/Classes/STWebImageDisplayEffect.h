//
//  STWebImageDisplayEffect.h
//  STWebImage
//
//  Created by legendry on 2018/3/30.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,STImageViewDisplayType) {
    STImageViewDisplayTypeNone = 0,//
    STImageViewDisplayTypeFadeIn = 1,//Fade in after setImage
    STImageViewDisplayTypeProgressive = 2,//Gradually show
};



@interface STWebImageDisplayEffectProssive : NSObject

- (instancetype)init NS_UNAVAILABLE ;
- (instancetype)initWithImageView:(UIImageView *)imageView ;
- (void)receiveData:(NSData *)data percent:(CGFloat)percent;


@end


//display a effect after image loaded
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static void _DisplayImageViewWithType(UIImageView *imageView,STImageViewDisplayType type) {
#pragma clang diagnostic pop
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
            break ;
            
        default:
            break;
    }
}

