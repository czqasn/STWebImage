//
//  UIImageView+THImageLoad.h
//  THKit
//
//  Created by legendry on 2018/1/29.
//  Copyright © 2018年 legendry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STWebImageDisplayEffect.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIImageView (TH)

//immediatelyDisplay 为YES 立即显示,为NO则提示到RunLoop空闲时显示
- (void)st_setImageWithUrl:(NSString *)imageUrl;

- (void)st_setImageWithUrl:(NSString *)imageUrl
               displayType:(STImageViewDisplayType)displayType ;

- (void)st_setImageWithUrl:(NSString *)imageUrl
        immediatelyDisplay:(BOOL)immediatelyDisplay;

- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage * _Nullable)placeholderImage ;

- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage * _Nullable)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay;

- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage * _Nullable)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay
               displayType:(STImageViewDisplayType)displayType ;

- (void)st_setImageWithUrl:(NSString *)imageUrl
          placeholderImage:(UIImage * _Nullable)placeholderImage
        immediatelyDisplay:(BOOL)immediatelyDisplay
               displayType:(STImageViewDisplayType)displayType
             progressBlock:(void(^ _Nullable)(CGFloat percent))progressBlock;

- (void)st_setImageWithName:(NSString *)name ;
- (void)st_setImageWithName:(NSString *)name immediatelyDisplay:(BOOL)immediatelyDisplay ;

@end
NS_ASSUME_NONNULL_END
