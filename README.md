# STWebImage

[![CI Status](http://img.shields.io/travis/czqasngit/STWebImage.svg?style=flat)](https://travis-ci.org/czqasngit/STWebImage)
[![Version](https://img.shields.io/cocoapods/v/STWebImage.svg?style=flat)](http://cocoapods.org/pods/STWebImage)
[![License](https://img.shields.io/cocoapods/l/STWebImage.svg?style=flat)](http://cocoapods.org/pods/STWebImage)
[![Platform](https://img.shields.io/cocoapods/p/STWebImage.svg?style=flat)](http://cocoapods.org/pods/STWebImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

STWebImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'STWebImage'
```

## Sample Code

```Objective-C
[self.imageView st_setImageWithUrl:@"https://s2.showstart.com/qn_69c05fad78174f2ea6c70b57dfd8ec73_1080_1528_362983.0x0.jpg" placeholderImage:nil immediatelyDisplay:NO displayType:STImageViewDisplayTypeFadeIn progressBlock:^(CGFloat percent) {
    NSLog(@"%.2f",percent)  ;
}] ;
```


## Author

czqasngit, czqasn_6@163.com

## License

STWebImage is available under the MIT license. See the LICENSE file for more info.
