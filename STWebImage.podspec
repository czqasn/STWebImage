
Pod::Spec.new do |s|
  s.name             = 'STWebImage'
  s.version          = '1.0.0'
  s.summary          = 'A light weight data web image load libiary.'
  s.description      = 'A simple and easy light weight data web image load libiary'
  s.homepage         = 'https://github.com/czqasngit/STWebImage'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'czqasngit' => 'czqasn_6@163.com' }
  s.source           = { :git => 'https://github.com/czqasngit/STWebImage.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'STWebImage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'STWebImage' => ['STWebImage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'STDownloader'
  s.dependency 'YYImage'
  s.dependency 'YYCache'
  s.dependency 'YYWebImage'
end
