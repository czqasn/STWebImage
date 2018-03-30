//
//  STWebImageDisplay.m
//  STWebImage
//
//  Created by legendry on 2018/3/30.
//

#import "STWebImageDisplay.h"


@implementation _STimageViewTransactionImpl
- (void)_display {
    if(!_image  || !_imageView) {
        return ;
    }
    _imageView.image = _image ;
    _DisplayImageViewWithType(self.imageView,_displayType) ;
}
@end
