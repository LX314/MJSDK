#
# Be sure to run `pod lib lint MJSDK-iOS-cocoapods.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJSDK-iOS-cocoapods'
  s.version          = '1.4.1.6'
  s.summary          = 'summary of MJSDK-iOS-cocoapods.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
description of MJSDK-iOS-cocoapods.
                       DESC

  s.homepage         = 'https://github.com/LX314/MJSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LX314' => '1094426094@qq.com' }
  s.source           = { :git => 'https://github.com/LX314/MJSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'MJSDK-iOS-cocoapods/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MJSDK-iOS-cocoapods' => ['MJSDK-iOS-cocoapods/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'AFNetworking'
s.dependency 'Masonry'
s.dependency 'Mantle'
#s.dependency 'OpenSSL'
s.dependency 'MBProgressHUD'
s.dependency 'SSKeychain'
s.dependency 'ReactiveCocoa', '~>2.0'

end
