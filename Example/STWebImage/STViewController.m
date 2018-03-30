//
//  STViewController.m
//  STWebImage
//
//  Created by czqasngit on 03/29/2018.
//  Copyright (c) 2018 czqasngit. All rights reserved.
//

#import "STViewController.h"
#import <STWebImage/STWebImage.h>

@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[STImageManager defaultImageManager] cleanCache] ;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill ;
}



- (IBAction)loadImage:(id)sender {
    
    [self.imageView st_setImageWithUrl:@"https://s2.showstart.com/qn_69c05fad78174f2ea6c70b57dfd8ec73_1080_1528_362983.0x0.jpg" placeholderImage:[UIImage imageNamed:@"ford_mustang"] immediatelyDisplay:NO displayType:STImageViewDisplayTypeProgressive progressBlock:^(CGFloat percent) {
        NSLog(@"%.2f",percent)  ;
    }] ;
    
}
@end
